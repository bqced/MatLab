
function [HourMem] = LoadAllHours (FileName,Contents)
HourMem = 0; 
StartLat = 1; 
NumLat = 400; 
StartLon = 1; 
NumLon = 700; 
% StartHour = 1; 
NumHour = 1; 

% for loop
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
end