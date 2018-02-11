%solve radial wave equation using numerov 
%predictor method to fourth order 
%for 2nd order de's

function [numerov]=numerov(u1,u2,l,r,delta,e,sigma,epsilon)

  num1=1/(1-(delta^2/12)*f(l,r+delta,e,sigma,epsilon));
  bracket1=2*u2-u1+(delta^2/12)*(10*f(l,r,e,sigma,epsilon)*u2+f(l,r,e,sigma,epsilon)*u1);
  numerov=num1*bracket1;

%endfunction
