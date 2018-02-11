function [conv]=conv(x, n, ndash, deltat, s, omega0)
  	conv=x*conj(shiftedmorlet(ndash,n-1,deltat,s,omega0));

%endfunction