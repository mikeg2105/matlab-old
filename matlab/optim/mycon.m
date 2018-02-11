 function [c , eq] = mycon(x)
% 
%  
%
% constraints are:  1.5 + x x  - x  - x <= 0
%                          1 2    1    2
%     and   
%                     -x x  - 10 <= 0
%                       1 2
%
% 

  c(1) = 1.5 + x(1)*x(2) - x(1) - x(2) ;
  c(2) =  -x(1)*x(2) - 10 ;
  eq =[];