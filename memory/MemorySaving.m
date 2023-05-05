clear all % clear all variables
close all % close all windows

FileName = '..\Model\o3_surface_20180701000000.nc'; % define the name of the file to be used, the path is included

Contents = ncinfo(FileName); % Store the file content information in a variable.


for idx = 1: 8
    AllData(idx,:,:,:) = ncread(FileName, Contents.Variables(idx).Name);
    fprintf('Loading %s\n', Contents.Variables(idx).Name); % display loading information
end

AllDataMem = whos('AllData').bytes/1000000;
fprintf('Memory used for all data: %.3f MB\n', AllDataMem)

StartLat = 1; % starting latitude
NumLat = 400; % number of latitude positions
StartLon = 1; % starying longitude
NumLon = 700; % number of lingitude positions
StartHour = 1; % starting time for analyises
NumHour = 1; % Number of hours of data to load

Models2Load = [1, 2, 4, 5, 6, 7, 8]; % list of models to load
idxModel = 0; % current model
for idx = 1:7
    idxModel = idxModel + 1; % move to next model index
    LoadModel = Models2Load(idx); % which model to load
    ModelData(idxModel,:,:,:) = ncread(FileName, Contents.Variables(LoadModel).Name,...
        [StartLon, StartLat, StartHour], [NumLon, NumLat, NumHour]);
    fprintf('Loading %s\n', Contents.Variables(LoadModel).Name); % display loading information
end

HourDataMem = whos('ModelData').bytes/1000000;
fprintf('Memory used for 1 hour of data: %.3f MB\n', HourDataMem)

HourMem = 0; % storage variable for the maximum memory in use by our data variable
StartLat = 1; % starting latitude
NumLat = 400; % number of latitude positions
StartLon = 1; % starying longitude
NumLon = 700; % number of lingitude positions
% StartHour = 1; % starting time for analyises
NumHour = 1; % Number of hours of data to load

% loop through the hours loading one at a time
for StartHour = 1:25
    Models2Load = [1, 2, 4, 5, 6, 7, 8]; % list of models to load
    idxModel = 0; % current model
    for idx = 1:7
        idxModel = idxModel + 1; % move to next model index
        LoadModel = Models2Load(idx);% which model to load
        HourlyData(idxModel,:,:,:) = ncread(FileName, Contents.Variables(LoadModel).Name,...
            [StartLon, StartLat, StartHour], [NumLon, NumLat, NumHour]);
        fprintf('Loading %s\n', Contents.Variables(LoadModel).Name); % display loading information
    end
    
% max memory
    HourMem = max( [ HourMem, whos('HourlyData').bytes/1000000 ] );
    fprintf('Loaded Hour %i, memory used: %.3f MB\n', StartHour, HourMem); % display loading information
end

fprintf('\nResults:\n')
fprintf('Memory used for all data: %.2f MB\n', AllDataMem)
fprintf('Memory used for hourly data: %.2f MB\n', HourDataMem)
fprintf('Maximum memory used hourly = %.2f MB\n', HourMem)
fprintf('Hourly memory as fraction of all data = %.2f\n\n', HourMem / AllDataMem)