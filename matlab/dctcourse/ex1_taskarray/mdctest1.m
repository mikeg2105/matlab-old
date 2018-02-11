%simple demo script for matlab dce
%test by Mike Griffiths 22nd January 2007
resource = findResource('scheduler', 'configuration', 'local');

%The set function can be used to set different propoerties of the resource
%set(resource, 'configuration', 'sge');
%set(resource, 'SubmitFcn', @sgeSubmitFcn);
%set(resource, 'ClusterMatlabRoot', '/usr/local/packages5/matlab_r2007b');

job=createJob(resource);

createTask(job, @rand, 1, {3,3});
createTask(job, @rand, 1, {4,4});
createTask(job, @rand, 1, {5,5});
createTask(job, @rand, 1, {6,6});

%submit all the tasks
submit(job);

%wait for job to complete before continuing
waitForState(job);
results=getAllOutputArguments(job)
%save('myresults1','results');

%The above script file can be executed as a single command using the dfeval
%function as follows
%results=dfeval(@rand,{[3,3],[4,4],[5,5],[6,6]}, 'Configuration', 'sge')