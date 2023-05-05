%% data per hour

function [HourDataMem] = LoadHours(FileName,Contents)
StartLat = 1; 
NumLat = 400;
StartLon = 1; 
NumLon = 700; 
StartHour = 1; 
NumHour = 1; 
Models2Load = [1, 2, 4, 5, 6, 7, 8]; % list of models to load
idxModel = 0;
for idx = 1:7
    idxModel = idxModel + 1; 
    LoadModel = Models2Load(idx); 
    ModelData(idxModel,:,:,:) = ncread(FileName, Contents.Variables(LoadModel).Name,...
        [StartLon, StartLat, StartHour], [NumLon, NumLat, NumHour]);
    fprintf('Loading %s\n', Contents.Variables(LoadModel).Name); 
end

HourDataMem = whos('ModelData').bytes/1000000;
fprintf('Memory used for 1 hour of data: %.3f MB\n', HourDataMem)
end