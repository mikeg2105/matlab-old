% add some paths
addpath('/usr/local/storage/matlabdc/moga_base');
addpath('/usr/local/storage/matlabdc/MGLS');

% set up a population to evaluate
ub = [7 7 300 300];
lb = [1 1 1 1];
fieldd = [lb; ub];
phen = crtrp(12, fieldd);

nobj = 9;

% set up the scheduler information
sched = findResource('scheduler', 'configuration', 'sge');
set(sched, 'configuration', 'sge');

for i = 1:3

    % set up the parallel job
    parjob = sched.createParallelJob('max', 4);

    % create the task here
    createTask(parjob, 'pareval', 1, {nobj, phen});

    % run objective function in parallel
    submit(parjob);
    waitForState(parjob);

    % get the results
    objv = getAllOutputArguments(parjob);
    
    % process the results
    obj{i} = objv{1};
    
    % destroy the job
    destroy(parjob);

end