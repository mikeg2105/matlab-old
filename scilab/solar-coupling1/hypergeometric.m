#hypergeometric
#return a 2d matrix of wave amplitudes
function [hypergeo]=hypergeometric(a,b,z,N)
  i=1;
  
  hypergeo=0;
  pocha=1;
  pochb=1;
  fac=1;
  while i<N
    pocha=pocha*(a+i-1);
    pochb=pochb*(b+i-1);  
    fac=fac*i;
    hypergeo=hypergeo+((pocha.*z.^i)/(pochb.*fac));
    i=i+1;
  endwhile;
#  return hypergeo; 
endfunction







