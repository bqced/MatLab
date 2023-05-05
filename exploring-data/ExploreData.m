%% explore .nc data files provided
clear all
close all

% data loading-- deliverable 1a
FileName = '..\Model\o3_surface_20180701000000.nc';

Contents = ncinfo(FileName);

fprintf('Data Dimension Names: %s, %s, %s\n',...
    Contents.Dimensions(1).Name,...
    Contents.Dimensions(2).Name,...
    Contents.Dimensions(3).Name)

%% variables

NumVariables = size(Contents.Variables,2);
fprintf('Variable names and sizes:\n')
for idx = 1: NumVariables
    fprintf('%i %s  %i, %i, %i',...
        idx, Contents.Variables(idx).Name, Contents.Variables(idx).Size);
    fprintf('\n');
end


%% data selection

StartLat = 1;
NumLat = 400;
StartLon = 1;
NumLon = 700;
StartHour = 1;
NumHour = 1;

Data = ncread(FileName, 'chimere_ozone', [StartLon, StartLat, StartHour], [NumLon, NumLat, NumHour]);

%% loading the models

for idx = [1, 2, 4, 5, 6, 7, 8]
    fprintf('Model %i : %s\n', idx, Contents.Variables(idx).Name);
end
