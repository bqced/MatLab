%% sequencial testing
function [tSeq] = SequentialProcessing(SampleSize)



FileName = '..\Model\o3_surface_20180701000000.nc';

Contents = ncinfo(FileName);

Lat = ncread(FileName, 'lat'); % load the latitude locations
Lon = ncread(FileName, 'lon'); % loadthe longitude locations

%% Processing parameters provided by customer
RadLat = 30.2016; % cluster radius value for latitude
RadLon = 24.8032; % cluster radius value for longitude
RadO3 = 4.2653986e-08; % cluster radius value for the ozone data
LOG_ID=fopen('SequentialTimeLog.txt','a'); % opens file identifier 
%% Cycle through the hours and load all the models for each hour and record memory use
% We use an index named 'NumHour' in our loop
% The section 'sequential processing' will process the data location one
% after the other, reporting on the time involved.

StartLat = 1; % latitude location to start laoding
NumLat = 400; % number of latitude locations ot load
StartLon = 1; % longitude location to start loading
NumLon = 700; % number of longitude locations ot load
tic
TestAll('../Model/o3_surface_20180701000000.nc')
for NumHour = 1:25 % loop through each hour
    fprintf('Processing hour %i\n', NumHour)
    DataLayer = 1; % which 'layer' of the array to load the model data into
    for idx = [1, 2, 4, 5, 6, 7, 8] % model data to load
        % load the model data
        HourlyData(DataLayer,:,:) = ncread(FileName, Contents.Variables(idx).Name,...
            [StartLon, StartLat, NumHour], [NumLon, NumLat, 1]);
        DataLayer = DataLayer + 1; % step to the next 'layer'
    end
    
    % We need to prepare our data for processing. This method is defined by
    % our customer. You are not required to understand this method, but you
    % can ask your module leader for more information if you wish.
    [Data2Process, LatLon] = PrepareData(HourlyData, Lat, Lon);
    
    %% Sequential analysis    
    t1 = toc;
    t2 = t1;
    %SampleSize = 500 ; 
    %fprintf('%i\n',size(Data2Process,1))
    for idx =1 : SampleSize  %1: size(Data2Process,1) % step through each data location to process the data
        
        % The analysis of the data creates an 'ensemble value' for each
        % location. This method is defined by
        % our customer. You are not required to understand this method, but you
        % can ask your module leader for more information if you wish.
        [EnsembleVector(idx, NumHour)] = EnsembleValue(Data2Process(idx,:,:,:), LatLon, RadLat, RadLon, RadO3);
        
        % To monitor the progress we will print out the status after every
        % 50 processes.
        if idx/500 == ceil( idx/500)
            tt = toc-t2;
            fprintf('Total %i of %i, last 500 in %.2f s  predicted time for all data %.1f s\n',...
                idx, size(Data2Process,1), tt, size(Data2Process,1)/500*25*tt)
            t2 = toc;
        end
    end
    T2(NumHour) = toc - t1; % record the total processing time for this hour
    fprintf('Processing hour %i - %.2f s\n\n', NumHour, sum(T2));
    %fprintf(fid, toc);
        
end
tSeq = toc;
%output the results to a file 
fprintf(LOG_ID,'Total time for sequential processing with %i of data = %.2f s\n\n',SampleSize,tSeq);
fclose(LOG_ID) ; % closes file identifier
fprintf('Total time for sequential processing = %.2f s\n\n', tSeq)
end
