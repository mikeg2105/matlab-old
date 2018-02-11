%simple demo script for matlab dce
%test by Mike Griffiths 22nd January 2007
resource = findResource('scheduler', 'configuration', 'sge');

%The set function can be used to set different propoerties of the resource
set(resource, 'configuration', 'sge');
%set(resource, 'SubmitFcn', @sgeSubmitFcn);
%set(resource, 'ClusterMatlabRoot', '/usr/local/packages5/matlab_r2007b');

job=createJob(resource);


for i=1:16
    createTask(job, @beats, 1, {i,20,100});
end

%submit all the tasks
submit(job);

%wait for job to complete before continuing
waitForState(job);

%The above script file can be executed as a single command using the dfeval
%function as follows
%results=dfeval(@rand,{1 2 3 4},{20 20 20 20},{100 100 100 100}, 'Configuration', 'sge')



results=getAllOutputArguments(job)
save('myresults1','results');



for ic=1:4
    subplot(2,2,ic);
    surf(results{ic});
end