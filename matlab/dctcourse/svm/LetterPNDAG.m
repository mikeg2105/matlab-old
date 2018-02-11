
clear;clc;
load Ctrain_validate_datasets;
[cvalidate_size,classattr]=size(cvalidate);
% num_class = 26;
% class = [1:num_class];
% decision_series = [];
% orgclass = class;
tic
level = 1;
iclass = 2; %% need to change value from 1 till 26 at the first level
%%this is what we want to run parallel 26 class at the same time at first level
%%ctrain = idata1; cvalidate = idata2;    
%%[cvalidate_size,classattr]=size(cvalidate);
versus      = strcat(int2str(iclass),'vsRemain',int2str(level));
ctrainname  = strcat('ndagtrain',int2str(iclass),'vsRemain');
cvalname    = strcat('ndagval',int2str(iclass),'vsRemain');

[x,y]=CreateSVMlightFile(ctrain,classattr,iclass,ctrainname);
[x,y]=CreateSVMlightFile(cvalidate,classattr,iclass,cvalname);
real = y;
modelname   = strcat('ndagmodel',int2str(iclass),'vsRemain');
[optimalC,optimalGamma,cgaccuracy] = FindOptCGamma(ctrainname,cvalname,modelname,'tmpfindout',real,versus); 
%%% save into file %%%
fid1 = fopen('savePNDAGAccuracy.txt','a');   
    if (fid1 <0) 
        error('could not open file "savePNDAGAccuracy.txt"');
    end  
    fprintf(fid1,'%s \t %f %f %f \n',versus,optimalC,optimalGamma,cgaccuracy); 
fclose(fid1);
toc
