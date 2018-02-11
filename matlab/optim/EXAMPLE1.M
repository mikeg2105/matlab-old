% this is an example sequence of matlab commands to solve the 
% constraint minimisation problem as defined by the objective
% function and constraint equations in the file myfunc.m .
% help toolbox/optim and   help constr and  help foptions
% will give information.
echo off; 
x = [ -1 0 ]; 

[ xnew , options] = constr('myfunc' , x);
% or simply      constr('myfunc' , x);
 disp( ' The results are:');
 disp (xnew);
 disp ('with the function value at: ');
 disp ( options(8) );
