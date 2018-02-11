%simple demo script for matlab dce
%test by Mike Griffiths 22nd January 2007

%resource=findResource('scheduler','type','generic');

resource=findResource('scheduler','configuration','generic');
set(resource, 'configuration', 'generic');

set(resource, 'SubmitFcn', @sgeSubmitFcn);
set(resource, 'ParallelSubmitFcn', @sgeParallelSubmitFcn);
set(resource, 'ClusterMatlabRoot', '/usr/local/packages/matlab_mdcdem_r06b');


j=resource.createParallelJob('MaximumNumberOfWorkers',4,'Configuration','generic');
t=j.createTask(@matlabroot,1);
submit(j);

%waitForState(parjob);
%parout = getAllOutputArguments(parjob);
