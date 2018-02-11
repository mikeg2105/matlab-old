%simple demo script for matlab dce
%test by Mike Griffiths 22nd January 2007

%resource=findResource('scheduler','type','generic');
%resource=findResource('scheduler','configuration','generic');
resource=findResource('scheduler','type','generic');
set(resource, 'configuration', 'sge');
set(resource, 'SubmitFcn', @sgeSubmitFcn);
%set(resource, 'ParallelSubmitFcn', @sgeParallelSubmitFcn);

%The following is used when we ar submitting to normal batch 
%queues and not using interactive mode
set(resource, 'ParallelSubmitFcn', @sgeParallelBatchSubmitFcn);
set(resource, 'ClusterMatlabRoot', '/usr/local/packages/matlab_mdcdem_r06b');
%parjob=resource.createParallelJob('MaximumNumberOfWorkers',4,'Configuration','sge');
%parjob=createParallelJob(resource);

