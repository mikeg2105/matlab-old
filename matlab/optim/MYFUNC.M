 function [f , g] = fun(x)
 
% here is the objective function in terms of variables x1 and x2
%             x1     2     2 
% i.e it is  e   ( 4x  + 2x  + 4x x   + 2x   + 1  )
%                    1     2     1 2      2
%
% constraints are:  1.5 + x x  - x  - x <= 0
%                          1 2    1    2
%     and   
%                     -x x  - 10 <= 0
%                       1 2
%
% 
  f = exp( x(1) ) * ( 4*x(1)^2 + 2*x(2)^2 + 4*x(1)*x(2) + 2*x(2) + 1) ;

  g(1) = 1.5 + x(1)*x(2) - x(1) - x(2) ;
  g(2) =  -x(1)*x(2) - 10 ;
