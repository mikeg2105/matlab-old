% run the objective function in parallel
function [objvout] = pareval(numobjs, pop)

% get the size of the input population
[nind, nvar] = size(pop);

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