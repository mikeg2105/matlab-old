function [wavelett]=wavelett(x, n, ndash, deltat, s, omega0)

  rsum=0;
  
  for i=1:n
    wv=conv(x(i),i,ndash,deltat,s,omega0);
   rsum=rsum+wv;
  end
  
  
  
  wavelett=rsum;
%endfunction