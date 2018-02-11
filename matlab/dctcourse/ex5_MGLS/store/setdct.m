%simple demo script for matlab dce
%test by Mike Griffiths 22nd January 2007

resource=findResource('scheduler','type','generic');
set(resource, 'SubmitFcn', @sgeSubmitFcn);
set(resource, 'ParallelSubmitFcn', @sgeParallelSubmitFcn);
set(resource, 'ClusterMatlabRoot', '/usr/local/packages/matlab_mdcdem_r06b');

parjob=createParallelJob(resource);

