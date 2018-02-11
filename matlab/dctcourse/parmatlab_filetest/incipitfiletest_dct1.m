%qscatter


jobname='wjob';
%env=getenv('SGE_TASK_ID');
env='1';
sgetid=sscanf(env,'%d');



%simple demo script for matlab dce
%test by Mike Griffiths 22nd January 2007
resource = findResource('scheduler', 'configuration', 'sge');
set(resource, 'configuration', 'sge');
%resource=findResource('scheduler','type','generic');
set(resource, 'SubmitFcn', @sgeSubmitFcn);
%set(resource, 'ParallelSubmitFcn', @sgeParallelBatchSubmitFcn);
set(resource, 'ParallelSubmitFcn', @sgeParallelSubmitFcn);
set(resource, 'ClusterMatlabRoot', '/usr/local/packages/matlab_mdcdem_r06b');

parjob=createParallelJob(resource);
nprocs=1;
set(parjob,'MinimumNumberOfWorkers',nprocs);
set(parjob,'MaximumNumberOfWorkers',nprocs);
%createTask(parjob, 'rand', 1, {3});
%createTask(parjob, 'myrandpar', 2, {5});
%createTask(parjob, 'incipitfiletestpar1', 1, {'filelist.txt','/scratch/cs1mkg/temp/MS_865','/scratch/cs1mkg/temp/ms865',0.1});
%createTask(parjob, 'incipitfiletestpar1', 1, {'filelist.txt','/scratch/cs1mkg/temp/MS_865','/scratch/cs1mkg/temp/ms865',0.1});
%createTask(parjob, 'incipitfiletestpar1', 1, {'filelist.txt','/tmp/myms865','/tmp/mynewms865',0.1});
createTask(parjob, 'incipitfiletestpar1', 1, {'filelist.txt','/tmp/ms865','/scratch/cs1mkg/temp/ms865',0.1});
submit(parjob);
tic
waitForState(parjob);
myruntime=toc
%disp(' myruntime');
%   disp(myruntime)
parout = getAllOutputArguments(parjob);

save('results1.mat', 'parout', '-v6');

truntime=0;
for i=1:nprocs;
    truntime=truntime+parout{i,1};
end
runtime=truntime/nprocs
%a2=parout{1,2};
%a3=parout{2,1};
%a4=parout{2,2};
%save('jobdat1.out', 'sumouter', '-ascii')
%save('jobout.mat','-v6');
  
%  plot(sumouter);
