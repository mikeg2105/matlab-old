function [momega]=momega(gammap,gammac,csp,l,beta,v,B,pp,g)

rsun=669*1000000.0;
mu=4*pi/10000000.0
m=1.0/(gammap-1);
k=(l*(l+1))^0.5/rsun;


zzero=((1+m)*csp*csp)/(gammap*g);

bigk=k*zzero;

beta=gammac*(2*mu*pp-b^2)/(2*b^2);

omega1=v*sqrt((2*bigk)/csp)*sqrt(gammap/(2*(m+1)));

omega2=(gammac*(2*bigk)^(m+1))/(2*gamma(m+2)*(2*beta+gammac));

omega3=1+omega1+omega2;

  
  momega=(omega3*(g*k)^0.5);
  
endfunction

