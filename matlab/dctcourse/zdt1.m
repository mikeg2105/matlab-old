function objv = zdt1(ind)

% This is the first ZDT test function for multi-objective optimisation.
%
% * It is a 30 variable problem with a convex Pareto-optimal set.
% * The variables should lie in the range [0, 1].
% * The Pareto-optimal region corresponds to 0 <= x1 <= 1, and xi = 0,
%   for i = 2 - 30.
%
% This is the easiest of all the ZDT problems, having a continuous
% Pareto-optimal front and a uniform distribution of solutions across the
% front.
%
% See Zitzler, Deb, and Thiele, (2000), "Comparison of Multi-Objective
% Evolutionary Algorithms: Empirical Results", Evolutionary Computation,
% 8(2), pp 125-148

nvar = length(ind);

% objective function 1
f1 = ind(1);

% objective function 2

% g(x)
g = 1;
for j = 2:nvar
    g = g + ((9 / (nvar - 1)) * ind(j));
end

% h(f1, x)
h = 1 - sqrt(f1 / g);

% f2(x)
f2 = g * h;

objv = [f1; f2]';
