%simple demo script for matlab dce
%test by Mike Griffiths 22nd January 2007
resource = findResource('scheduler', 'configuration', 'local');
set(resource, 'configuration', 'local');
%resource=findResource('scheduler','type','generic');
%set(resource, 'SubmitFcn', @sgeSubmitFcn);
%set(resource, 'ParallelSubmitFcn', @sgeParallelBatchSubmitFcn);
%set(resource, 'ParallelSubmitFcn', @sgeParallelSubmitFcn);
%set(resource, 'ClusterMatlabRoot', '/usr/local/packages/matlab_mdcdem_r06b');

parjob=createParallelJob(resource);
set(parjob,'MinimumNumberOfWorkers',4);
set(parjob,'MaximumNumberOfWorkers',4);
%createTask(parjob, 'rand', 1, {3});
%createTask(parjob, 'myrandpar', 2, {5});
createTask(parjob, 'quadpi', 1, {});

submit(parjob);

waitForState(parjob);
parout = getAllOutputArguments(parjob);

save('results1.mat', 'parout', '-v6');
%a1=parout{1,1};
%a2=parout{1,2};
%a3=parout{2,1};
%a4=parout{2,2};
%save('jobdat1.out', 'a1','a2','a3','a4', '-ascii')

