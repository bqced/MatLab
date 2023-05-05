clear all 
close all
samples =[30000,60000] ; 
numofworkers = [1,2,3,4,5,6,7,8] ;
lenoflist2 = length(numofworkers);
lenoflist = length(samples);
for kidx = 1 : lenoflist
  samplesize = samples(kidx) ;
  for jidx = 1 : lenoflist2
      numofworkerss = numofworkers(jidx) ; 
      ParallelProcessing(numofworkerss,samplesize)
  end
end
