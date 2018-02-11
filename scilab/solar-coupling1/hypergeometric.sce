//hypergeometric
//return a 2d matrix of wave amplitudes
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
    i=i+1;
    hypergeo=hypergeo+((pocha*z^i)/(pochb*fac));
  end;
// return hypergeo; 
endfunction

function [solmhdconv]=solmhdconv(z,k,z0,a,m,c2,N)
  
  solmhdconv=(c2*exp((-k)*(z+z0))*hypergeometric(-a,m+2,2*k*z+2*k*z0));
  
endfunction

function [solmhdconv]=solmhdconv(z,k,z0,a,m,c2,N)
  
  solmhdconv=(c2*exp((-k)*(z+z0))*hypergeometric(-a,m+2,2*k*z+2*k*z0));
  
endfunction

function [omega]=omega(gammap,gammac,csp,l,beta,v,B,pp,g)

rsun=669*1000000.0;
mu=4*%pi/10000000.0
m=1.0/(gammap-1);
k=(l*(l+1))^0.5/rsun;


zzero=((1+m)*csp*csp)/(gammap*g);

bigk=k*zzero;

beta=gammac*(2*mu*pp-b^2)/(2*b^2);

omega1=v*sqrt((2*bigk)/csp)*sqrt(gammap/(2*(m+1)));

omega2=(gammac*(2*bigk)^(m+1))/(2*gamma(m+2)*(2*beta+gammac));

omega3=1+omega1+omega2;

  
  omega= (omega3*(g*k)^0.5);
  
endfunction



