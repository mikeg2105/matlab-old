% Simple Parallel Job 

% find the scheduler
sched = findResource('scheduler', 'configuration', 'sge');
set(sched, 'configuration', 'sge');

% create a parallel job with maximum of 3 workers
parJob = sched.createParallelJob('max', 3);

% create a simple task
parJob.createTask(@labindex, 1, {});

% submit job and wait
parJob.submit;
parJob.waitForState;

% get the results.  Hopefully, we'll get {[1], [2], [3]}
results = parJob.getAllOutputArguments

% destroy the job
parJob.destroy;
