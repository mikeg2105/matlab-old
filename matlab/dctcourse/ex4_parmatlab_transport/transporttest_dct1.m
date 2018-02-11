%qscatter


jobname='wjob';
%env=getenv('SGE_TASK_ID');
env='1';
sgetid=sscanf(env,'%d');



%simple demo script for matlab dce
%test by Mike Griffiths 22nd January 2007
resource = findResource('scheduler', 'configuration', 'local');
set(resource, 'configuration', 'local');
%resource=findResource('scheduler','type','generic');
%set(resource, 'SubmitFcn', @sgeeemicroSubmitFcn);
%set(resource, 'SubmitFcn', @sgeSubmitFcn);
%set(resource, 'ParallelSubmitFcn', @sgeParallelSubmitFcn);

%set(resource, 'ParallelSubmitFcn', @sgeParallelBatchSubmitFcn);
%set(resource, 'ParallelSubmitFcn', @sgeeemicroParallelSubmitFcn);
%set(resource, 'ClusterMatlabRoot', '/usr/local/packages/matlab_mdcdem_r06b');
%set(resource, 'ClusterMatlabRoot', '/usr/local/packages5/matlab_r2007b');



nprocs=[1 2 3 4 5 6 8 10 12 20 24];
ntests=2;
timea=zeros(ntests,3);
%for j=1:11
for k=1:ntests
for j=4:4
numprocs=nprocs(j);
parjob=createParallelJob(resource);
set(parjob,'MaximumNumberOfWorkers',numprocs);
set(parjob,'MinimumNumberOfWorkers',numprocs);

createTask(parjob, 'transporttestpar1', 1, {1});
%createTask(parjob, 'rand', 1, {3});
%createTask(parjob, 'myrandpar', 2, {5});
%createTask(parjob, 'incipitfiletestpar1', 1, {'filelist.txt','/scratch/cs1mkg/temp/MS_865','/scratch/cs1mkg/temp/ms865',0.1});


submit(parjob);
tic
waitForState(parjob);
myruntime=toc
%disp(' myruntime');
%   disp(myruntime)
parout = getAllOutputArguments(parjob);

%save('results1.mat', 'parout', '-v6');
%runtime=parout{1,1}

time=0;
for i=1:numprocs
    time=time+1000*parout{i,1};
end
timea(k,:)=time'/numprocs

destroy(parjob);

end

end %looping over tests
%a2=parout{1,2};
%a3=parout{2,1};
%a4=parout{2,2};
%save('jobdat1.out', 'sumouter', '-ascii')
save('jobdat1.mat', 'timea', '-v6')
%save('jobout.mat','-v6');
  
%  plot(sumouter);
