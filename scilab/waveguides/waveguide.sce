function [ez]=ez(m,n,k,rho,phi,z)

  amn=1;
  bmn=1;
  gammamn=1;
  
  ez=besselj(m,gammamn*rho).*exp(%i*m*phi).*(amn*sin(k*z)+bmn*cos(k*z));

endfunction
