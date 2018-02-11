User Guide for MGLS optimisation:

The main file is mgls_ga_rv.m.  This is a script that runs moga on the controller loop shaping problem in this directory.  It takes user inputs for the population size, number of generations, and maximum number of labs to use.  Note, it would probably be best to use a population size that is divisible by the number of labs used.

The script sets up the parallel scheduler here:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set up the parallel job
sched = findResource('scheduler', 'configuration', 'sge')
set(sched, 'configuration', 'sge');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

and runs the parallel job like:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% run objective function in parallel:    
% set up the parallel job
parjob = sched.createParallelJob('max', maxlabs);

% create the task here
createTask(parjob, 'pareval', 1, {nobj, phen});

% run objective function in parallel
submit(parjob);
waitForState(parjob);

% get the results
res = getAllOutputArguments(parjob);
    
% destroy the job
destroy(parjob);
    
% process the output (the cells should all be the same, so just get
% the first one)
objv = res{1};    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

the actual function pareval.m basically wraps the objfun.m function in a parallel for loop.  First it initialises the output matrix, objv, then runs the parfor loop, and then "gathers" the objv matrix to return the result.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initialise objv, and set up the distributor describing how the pieces of 
% the distributed array are laid out across the available labs - in this 
% case it is by rows (dim = 1), and there are 'numobjs' objectives
d = distributor(1);
objv = zeros(nind, numobjs, d);

% create the tasks
parfor i = 1:nind
    objv(i,:) = objfun(pop(i,:));    
end

% gather the results
objvout = gather(objv);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Visualisation at the end can be performed using the command:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
parallelcoords(best_objv);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Hope this helps!

Alex Shenfield
