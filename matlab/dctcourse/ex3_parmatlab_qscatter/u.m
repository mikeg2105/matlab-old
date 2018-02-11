%u
function [u]=u(l,r)
  alpha=6.12;
  e=3;
  C=sqrt(e*alpha/25)
  u=exp( (-1)*C*r^(-5));
%endfunction
