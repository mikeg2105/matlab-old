% this is an example sequence of matlab commands to solve the 
% constraint minimisation problem as defined by the objective
% function and constraint equations in the file myfunc.m .
% help toolbox/optim and   help constr and  help foptions
% will give information.
echo off; 
x0 = [ -1 0 ]; 

[ x , fval] = fmincon('mynewfun' , x0, [] , [] , [] , [] ,[],[], 'mycon');
%
 disp( ' The results are:');
 disp (x);
 disp ('with the function value at: ');
 disp ( fval );
