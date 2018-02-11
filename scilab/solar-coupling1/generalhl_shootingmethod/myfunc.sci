function res=myfuncchi(params,tchi,tpi,rrt)
       
      //params.m=;
      //params.k=;
      //params.om=;
      //params.p=;
      //params.rpi=;   //Uuse initial bc
      //params.rchi=; //use initial bc
      res=chidash(params,rrt,tchi,tpi)

endfunction


function res=myfuncpi(params,tchi,tpi,rrt)
         res=pidash(params,rrt,tchi,tpi);
endfunction

function fx=myfunc(x)

  h=1;
  fx = 0.5*sin(2*(x-(%pi/4)))+h*sin(x);
  //dfx= cos(2*(x-(%pi/4)))+h*cos(x);

endfunction;

function dfx=mydiffunc(x)

  h=1;
  //fx = 0.5*sin(2*(x-(%pi/4)))+const.h*sin(x);
  dfx= cos(2*(x-(%pi/4)))+h*cos(x);

endfunction;

function dbesi=dbesseli(alpha,x)
    dbesi=besseli(alpha+1,x)+(alpha/2)*besseli(alpha,x);
endfunction

function dbesk=dbesselk(alpha,x)
    dbesk=(alpha/2)*besselk(alpha,x)-besselk(alpha+1,x);
endfunction

function rb=b(params,r)
    const=1.0;
    rb=const;
endfunction

function rrho=rho(params,r)
    const=1.0;
    rrho=const;
endfunction

function rbzhat=bzhat(r)
    const=1.0e4;
    rbzhat=const;
endfunction

function rmu1=mu1(params)
    mu1sq=(((1+params.beta)*(params.b0/bzhat(params.a))^2)-1)/(params.a^2);
    rmu1=sqrt(mu1sq);
endfunction




function rbthetahat=bthetahat(params,r)
    const=1.0e5;
    rbthetahat=bzhat(r)*(params.mu1hat*(params.a)^2)/r;
endfunction

function RFhat=Fhat(params,r,m,k)
    RFhat=(m.*bthetahat(params,r)./r)+(k.*bzhat(r));
endfunction




function rbtheta=btheta(params,r)
    const=1.0e5;//*exp(-(r./params.a).^2);
    rbtheta=const;
endfunction

function rdbtheta=dbtheta(params,r)
    const=0.0;//-2*r*1.0*exp(-(r./params.a).^2)/((params.a)^2);
    rdbtheta=const;
endfunction

function rbz=bz(params,r)
    const=1.0e4;//*exp(-(r./params.a).^2);
    rbz=const;
endfunction


function rpionchi=pionchi(params,m,k)
    
    bterm=((btheta(params,params.a))^2-  (bthetahat(params,params.a))^2     )/(params.a^2);
    
    besterm=(Fhat(params,params.a,m,k))^2/(k*params.a);
    besterm=besterm*(besseli(m,k*params.a)*dbesselk(m,k*params.b)-besselk(m,k*params.a)*dbesseli(m,k*params.b));
    besterm=besterm/(dbesseli(m,k*params.a)*dbesselk(m,k*params.b)-dbesselk(m,k*params.a)*dbesseli(m,k*params.b));
    
    rpionchi=bterm-besterm;
endfunction





function RF=F(params,r,m,k)
    RF=(m.*btheta(params,r)./r)+(k.*bz(params,r));
endfunction

function RG=G(params,r,m,k)
    RG=(m.*bz(params,r)/.r)-(k.*btheta(params,r));
endfunction

function RC=C(params,r,m,k,om,p)
    rgamma=1.666666667;
    RC=((-2*(btheta(params,r))^2*(rho(params,r))^2*om^4)/(r^2))+(2*m*btheta(params,r)*F(params,r,m,k)/r^3)*((rgamma*p+(b(params,r))^2)*rho(params,r)*om^2-rgamma*p*(F(params,r,m,k))^2);
endfunction


function vomsz=omsz(params,r,m,k,om,p)
    rgamma=1.666666667;
    vomsz=(1/(2*rho(params,r)))*(k^2+(m./r)^2)*(rgamma*p+b(params,r)^2)*(1-sqrt(   (4*rgamma*p*(F(params,r,m,k))^2)/((k^2+(m/r)^2)*(rgamma*p+(b(params,r))^2)^2)     )) ;
endfunction

function vomfz=omfz(params,r,m,k,om,p)
    rgamma=1.666666667;
    vomfz=(1/(2*rho(params,r)))*(k^2+(m./r)^2)*(rgamma*p+b(params,r)^2)*(1+sqrt(   (4*rgamma*p*(F(params,r,m,k))^2)/((k^2+(m/r)^2)*(rgamma*p+(b(params,r))^2)^2)     )) ;
endfunction

function RD=D(params,r,m,k,om,p)
    rgamma=1.666666667;
    RD=(rho(params,r)*om^2)^2-(k^2+(m/r)^2)*(rgamma*p+b(params,r)^2)*(rho(params,r)*om^2)+(k^2+(m/r)^2)*(rgamma*p)*(F(params,r,m,k))^2;
endfunction

function RN=N(params,r,m,k,om,p)
    rgamma=1.666666667;
    RN=(rho(params,r).*om.^2-F(params,r,m,k).^2)*((rgamma*p+b(params,r).^2).*(rho(params,r)*om.^2)-(rgamma.*p.*F(params,r,m,k).^2));
endfunction

function RE=E(params,r,m,k,om,p)
    rgamma=1.666666667;
    RE=((4*btheta(params,r)^2*F(params,r,m,k)^2)/(r^4))*((rgamma*p+(b(params,r))^2)*rho(params,r)*om^2-rgamma*p*(F(params,r,m,k))^2)-(4*btheta(params,r)^4*(rho(params,r))^2*om^4/(r^4))-(N(params,r,m,k,om,p)/r)*(  (((rho(params,r)*om^2-(F(params,r,m,k))^2)/r) +(2*btheta(params,r)*dbtheta(params,r)/(r^2))-2*(btheta(params,r))^2/(r^3)  ));
endfunction

function rchidash=chidash(params,r,chi,rpi)
    rgamma=1.666666667;
    rchidash=-(r/N(params,r,params.m,params.k,params.om,params.p))*(C(params,r,params.m,params.k,params.om,params.p)*chi+D(params,r,params.m,params.k,params.om,params.p)*rpi)
endfunction

function rpidash=pidash(params,r,chi,rpi)
    rgamma=1.666666667;
    rpidash=-(r/N(params,r,params.m,params.k,params.om,params.p))*(E(params,r,params.m,params.k,params.om,params.p)*chi-C(params,r,params.m,params.k,params.om,params.p)*rpi);
endfunction

function rpi=fpi(params,r,m,k,om,p,chi)
    rgamma=1.666666667;
    rpi=-(chidash(params,r,m,k,om,p,chi)*(N(params,r,m,k,om,p)/(r*D(params,r,m,k,om,p))))+(2*chi*btheta(params,r)^2/(r^2))-(2*chi*k*btheta(params,r)*G(params,r,m,k)/(r^2*D(params,r,m,k,om,p)))*((rgamma*p+(b(params,r))^2)*rho(params,r)*om^2-rgamma*p*(F(params,r,m,k))^2);
endfunction



