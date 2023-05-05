function [T2] = ParallelProcessing(workers,SampleSize , NumHours )
%% Load Data
close all

FileName = '..\Model\o3_surface_20180701000000.nc';

Contents = ncinfo(FileName);

Lat = ncread(FileName, 'lat');
Lon = ncread(FileName, 'lon');


%%  Processing parameters
% ##  provided by customer  ##
RadLat = 30.2016;
RadLon = 24.8032;
RadO3 = 4.2653986e-08;
LogID = fopen('ParallelTimeLog.txt', 'a');
StartLat = 1;
NumLat = 400;
StartLon = 1;
NumLon = 700;

%%  allocate output array memory
NumLocations = (NumLon - 4) * (NumLat - 4);
EnsembleVectorPar = zeros(NumLocations, NumHours); % pre-allocate memory

%% load all the models for each hour and record memory use
tic
TestAll('../Model/o3_surface_20180701000000.nc')
for idxTime = 1:NumHours
    
    DataLayer = 1;
    for idx = [1, 2, 4, 5, 6, 7, 8]
        HourlyData(DataLayer,:,:) = ncread(FileName, Contents.Variables(idx).Name,...
            [StartLon, StartLat, idxTime], [NumLon, NumLat, 1]);
        DataLayer = DataLayer + 1;
    end
    
    %%  Pre-process the data for parallel processing
    
    [Data2Process, LatLon] = PrepareData(HourlyData, Lat, Lon);
   
    
%% Parallel Analysis
    PoolSize = workers ; % define the number of processors to use in parallel
    if isempty(gcp('nocreate'))
        parpool('local',PoolSize);
    end
    poolobj = gcp;
    addAttachedFiles(poolobj,{'EnsembleValue'});
    end
    
    %close(hWaitBar); % close the wait bar
    
    T3(idxTime) = toc - T4; % record the parallel processing time for this hour of data
    fprintf('Parallel processing time for hour %i : %.1f s\n', idxTime, T3(idxTime))
    
end % end time loop
T2 = toc;
%delete(gcp);
fprintf(LogID, 'Total time for processing with %i Worker and %i of data = %.2f s\n\n',workers, SampleSize, T2);
EnsembleVectorPar = reshape(EnsembleVectorPar, 696, 396, []);
fprintf('Total processing time for %i workers = %.2f s\n', PoolSize, sum(T3));

%% save pre-processed data

function nUpdateWaitbar(~) % nested function
    waitbar(p/N, hWaitBar,  sprintf('Hour %i, %.3f complete, %i out of %i', idxTime, p/N*100, p, N));
    p = p + 1;
end
fclose(LogID);
end % end function
