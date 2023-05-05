clear all % clear all variables
close all % close all windows

FileName = '..\Model\o3_surface_20180701000000.nc'; % define the name of the file to be used, the path is included

Contents = ncinfo(FileName); % Store the file content information in a variable.
fprintf('Loading Hour by hour ...\n')
[HourDataMem] = LoadHours(FileName,Contents) ;
fprintf('Loading all Hours ...\n')
[HourMem] = LoadAllHours (FileName,Contents) ;
fprintf('Loading all data ... \n')
[AllDataMem]=LoadAllData(FileName,Contents) ; 
fprintf('Loading Results ... \n')
Results(AllDataMem,HourDataMem,HourMem) ;