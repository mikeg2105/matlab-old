function [f]=f(l,r,e,sigma,epsilon)
global m
global hb

%ra=r*(10^(-10));
  f=v(r,sigma,epsilon)+(hb^2/(2*m*r^2))-e;
%endfunction


