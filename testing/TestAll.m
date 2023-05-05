function TestAll(FileName)

%% Test a good file
%% Set file to test
%%FileName = 'Model/o3_surface_20180701000000.nc'; % define our test file

Contents = ncinfo(FileName); % Store the file content information in a variable.
FileID = netcdf.open(FileName,'NC_NOWRITE'); % open file read only and create handle

LOG_ID = fopen('TestingLog.txt', 'w');
fprintf(LOG_ID, 'Looking for text data in %s.. \n',  FileName);

%% Define plain text variable types
DataTypes = {'NC_Byte', 'NC_Char', 'NC_Short', 'NC_Int', 'NC_Float', 'NC_Double'};

for idx = 0:size(Contents.Variables,2)-1 % loop through each variable
    % read data type for each variable and store
    [~, datatype(idx+1), ~, ~] = netcdf.inqVar(FileID,idx);
end

%% display data types
DataInFile = DataTypes(datatype)'

%% find character data types
FindText = strcmp('NC_Char', DataInFile);

%% print results
fprintf('Testing file: %s\n', FileName)
if any(FindText)
    fprintf('Error, text variables present:\n')
    fprintf(LOG_ID,'Error, text variables present:\n');
else
    fprintf('All data is numeric, continue analysis.\n')
    fprintf(LOG_ID, 'All data is numeric, continue analysis\n');
end
fprintf(LOG_ID, '%s\n', DataInFile{:});

%% #####

%% Test a good file
NaNErrors = 0;
%% Set file to test
%%FileName = 'Model/o3_surface_20180701000000.nc'; % define our test file

%%Contents = ncinfo(FileName); % Store the file content information in a variable.

%%LogFileName = 'AnalysisLog.txt';
%%LogID = fopen('AnalysisLog.txt', 'w');
%%fprintf(LogID, '%s: Starting analysis for %s.. \n', datestr(now, 0), FileName);

StartLat = 1;
StartLon = 1;

for idxHour = 1:25
    
    for idxModel = 1:8
        Data(idxModel,:,:) = ncread(FileName, Contents.Variables(idxModel).Name,...
            [StartLat, StartLon, idxHour], [inf, inf, 1]);
    end
    
    % check for NaNs
    if any(isnan(Data), 'All')
        fprintf('NaNs present\n')
        fprintf(LOG_ID, 'NaNs present during hour: %i\n', idxHour);
        fprintf(LOG_ID, 'NaNs present\n');
        NaNErrors = NaNErrors + 1;
    end
end
    
fprintf('Looking NaNs in file: %s\n', FileName)
fprintf(LOG_ID, 'Testing files: %s\n', FileName);
if NaNErrors
    fprintf('NaN errors present!\n')
    fprintf(LOG_ID, ' NaN errors present!\n');
else
    fprintf('No errors!\n')
    fprintf(LOG_ID,'No errors!\n');
end
fprintf('NAN TOTAL : %i\n',NaNErrors)
fclose(LOG_ID);