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
parconfig='sge';
resource = findResource('scheduler', 'configuration', parconfig);
set(resource, 'configuration', parconfig);
%resource=findResource('scheduler','type','generic');
%set(resource, 'SubmitFcn', @sgeSubmitFcn);
%set(resource, 'ParallelSubmitFcn', @sgeParallelSubmitFcn);
%set(resource, 'ParallelSubmitFcn', @sgeParallelSubmitFcn);
%set(resource, 'ClusterMatlabRoot', '/usr/local/packages/matlab_mdcdem_r06b');
%set(resource, 'ClusterMatlabRoot', '/usr/local/packages5/matlab_r2007b');
nprocs=[1 2 3 4 5 6 8 10 12 20 24];
%for j=1:11
for j=[11]
numprocs=nprocs(j);
parjob=createParallelJob(resource);

set(parjob,'MinimumNumberOfWorkers',numprocs);
set(parjob,'MaximumNumberOfWorkers',numprocs);
%createTask(parjob, 'rand', 1, {3});
%createTask(parjob, 'myrandpar', 2, {5});
createTask(parjob, 'qscatterpar2', 2, {1});


submit(parjob);
tic
waitForState(parjob);
myruntime=toc
%disp(' myruntime');
%   disp(myruntime)
parout = getAllOutputArguments(parjob);

%save('results1.mat', 'parout', '-v6');
sumouter=parout{1,1};

time=0;
for i=1:numprocs
    time=time+1000*parout{i,2};
end
time=time/numprocs
destroy(parjob);
%a3=parout{2,1};
%a4=parout{2,2};
%save('jobdat1.out', 'sumouter', '-ascii')
%save('jobout.mat','-v6');
  
%  plot(sumouter);
end
