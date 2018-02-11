% MGLS_ga_rv.m
% A Genetic Algorithm Script to solve a Controller Design Problem
%

% Author:   Alex Shenfield
% Date:     17-12-2007



% take user inputs
%nind = input('Number of individuals? ');
%maxgen = input('Maximum number of generations? ');
%maxlabs = input('Maximum number of labs to use? ');
nind=10;
maxgen=2;
maxlabs=4;
defaultParallelConfig('sge');
matlabpool('open','sge',maxlabs);
% add path to moga
addpath('../moga_base/')

% number of objectives
nobjv = 9;

% initialisation
gen = 0;
objv = zeros(nind, nobjv);
goalv = [4 5 0.349 0.52 -30 -1 -.7143 4 4];
priorityv = [1 0 1 1 1 0 1 0 0];

bestobjv = Inf * ones(1, nobjv);
bestphen = NaN * ones(1, 4);

% create a real valued population with 'nind' individuals, ...
% and 'fieldd' as the bounds
ub = [7 7 300 300];
lb = [1 1 1 1];
fieldd = [lb; ub];
phen = crtrp(nind, fieldd);

% set up the scheduler information

%sched = findResource('scheduler', 'configuration', 'sge');
%set(sched, 'configuration', 'sge');

% iterative loop
while gen < maxgen
    
    gen = gen + 1;
    
    % store the solns to be evaluated
    if gen==1
        pop = [phen]; 
    else
        pop = [pop; phen]; 
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % run objective function in parallel:    
    
    % set up the parallel job
    %parjob=createMatlabPoolJob('Name','test', 'max',maxlabs);
    %parjob = sched.createParallelJob('max', maxlabs);

    % create the task here
    %createTask(parjob, 'pareval', 1, {nobjv, phen});

    % run objective function in parallel
    %submit(parjob);
    %waitForState(parjob);

    % get the results
    %res = getAllOutputArguments(parjob);
    
    % destroy the job
    %destroy(parjob);
    %pctRunOnAll(pareval(nobjv,phen));
    % process the output (the cells should all be the same, so just get
    % the first one)
    %objv = res{1};
    % get the size of the input population
    [nind, nvar] = size(phen);

    % initialise objv, and set up the distributor describing how the pieces of 
    % the distributed array are laid out across the available labs - in this 
    % case it is by rows (dim = 1), and there are 'numobjs' objectives
    d = distributor(1);
    objv = zeros(nind, nobjv, d);

    % create the tasks
    parfor i = 1:nind
        objv(i,:) = objfun(phen(i,:));    
    end

    % gather the results
    objvout = gather(objv);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ... and back to the moea:
    
    % find the non-dominated points
    [ix, bestix] = find_nd(objvout, bestobjv);
    bestobjv = [bestobjv(logical(bestix),:); objv(logical(ix),:)];
    bestphen = [bestphen(logical(bestix),:); phen(logical(ix),:)];
    
    % rank the data
    rankv = rank_prf(objv, goalv, priorityv);
        
    % assign fitness
    fitness = ranking(rankv);
   
    % perform selection using Stochastic Universal Sampling
    ix2 = sus(fitness, nind);
    selphen = phen(ix2,:);    
    
    % perform intermediate recombination
    selphen = boundedrecint(selphen, 0.7, fieldd);  %xovr prob not used    
    
    % perform mutation
    phen = mutbga(selphen, fieldd);
    
end
save('results.mat','-v6');





















