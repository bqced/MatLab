clear all 
close all
samples =[250 , 5000 , 10000] ; 
lenoflist = length(samples);
for kidx = 1 : lenoflist
  samplesize = samples(kidx) ;
  SequentialProcessing(samplesize)
end