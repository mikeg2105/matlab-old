%qscatter
%exec('v.sce');
%exec('f.sce');
%exec('u.sce');
%exec('tdl.sce');
%exec('sigma.sce');
%exec('numerov.sce');

jobname='wjob';
%env=getenv('SGE_TASK_ID');
env='1';
sgetid=sscanf(env,'%d');
%partial wave analysis of scattering

deltah=0.01;
nsteps=200;

%simple demo script for matlab dce
%test by Mike Griffiths 22nd January 2007
resource = findResource('scheduler', 'configuration', 'sge');
set(resource, 'configuration', 'sge');
%resource=findResource('scheduler','type','generic');
set(resource, 'SubmitFcn', @sgeSubmitFcn);
set(resource, 'ParallelSubmitFcn', @sgeParallelBatchSubmitFcn);
%set(resource, 'ParallelSubmitFcn', @sgeParallelSubmitFcn);
set(resource, 'ClusterMatlabRoot', '/usr/local/packages/matlab_mdcdem_r06b');

parjob=createParallelJob(resource);
set(parjob,'MinimumNumberOfWorkers',8);
set(parjob,'MaximumNumberOfWorkers',8);
%createTask(parjob, 'rand', 1, {3});
%createTask(parjob, 'myrandpar', 2, {5});
createTask(parjob, 'qdipsigpar1', 1, {});


submit(parjob);
tic
waitForState(parjob);
myruntime=toc
disp(' myruntime');
   disp(myruntime)
parout = getAllOutputArguments(parjob);

save('results1.mat', 'parout', '-v6');
sumouter=parout{1,1};
%a2=parout{1,2};
%a3=parout{2,1};
%a4=parout{2,2};
save('jobdat1.out', 'sumouter', '-ascii')
save('jobout.mat','-v6');
  
  plot(sumouter);
