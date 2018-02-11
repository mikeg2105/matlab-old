function [solmhdconv1]=solmhdconv1(z,k,z0,a,m,c2,N)
  
  solmhdconv1=(c2*exp((-k)*(z+z0))*hypergeometric(-a,m+2,2*k*z+2*k*z0,N));
#solmhdconv1=(c2*exp((-k)*(z+z0)));
  
endfunction
