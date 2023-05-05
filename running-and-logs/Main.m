close all
ExploreData
% Display memory usage 
MainMemory
% Set a couple of variables to be used later
samples =[5000,7500 ,10000] ; 
numofworkers = [1,2,3,4,5,6,7,8] ;
numofhours = 3 ;
lenoflist2 = length(numofworkers);
lenoflist = length(samples);
%loop
for kidx = 1 : lenoflist
  samplesize = samples(kidx) ;
 
  for jidx = 1 : lenoflist2
      fprintf("Parallel Processing  Total data of : %i  , Number of Workers : %i , Num of Hours : %i \n" ,samplesize , numofworkers(jidx),numofhours )
      numofworkerss = numofworkers(jidx) ; 
      SequentialProcessing(samplesize)
      ParallelProcessing(numofworkerss,samplesize , numofhours)
      
  end

end

