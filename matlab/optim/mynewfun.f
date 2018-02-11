 function [f] = mynewfun(x)
 
% here is the objective function in terms of variables x1 and x2
%             x1     2     2 
% i.e it is  e   ( 4x  + 2x  + 4x x   + 2x   + 1  )
%                    1     2     1 2      2
% 
%
% 
  f = exp( x(1) ) * ( 4*x(1)^2 + 2*x(2)^2 + 4*x(1)*x(2) + 2*x(2) + 1) ;

   