 function f = mynewfun(xx,yy)
%function f = mynewfun1(x)
% here is the objective function in terms of variables x1 and x2
%             x1     2     2 
% i.e it is  e   ( 4x  + 2x  + 4x x   + 2x   + 1  )
%                    1     2     1 2      2
% 
%
% 

%xx=x(1,:)
%yy=x(2,:)
%xx=x(1)
%yy=x(2)
f = exp( xx ).* ( 4*yy.^2 + 2*yy.^2 + 4*xx.*yy + 2*yy + 1) ;

   