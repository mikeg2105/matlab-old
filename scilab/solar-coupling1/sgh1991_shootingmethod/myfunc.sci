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

function rb=b(params,r)
    rb=sqrt(bz(params,r)^2+btheta(params,r)^2);
endfunction


function rpionchi=pionchi(params,m,k)
    
    bterm=((btheta(params,params.a))^2-  (bthetahat(params,params.a))^2     )/(params.a^2);
    
    besterm=(Fhat(params,params.a,m,k))^2/(k*params.a);
    besterm=besterm*(besseli(m,k*params.a)*dbesselk(m,k*params.b)-besselk(m,k*params.a)*dbesseli(m,k*params.b));
    besterm=besterm/(dbesseli(m,k*params.a)*dbesselk(m,k*params.b)-dbesselk(m,k*params.a)*dbesseli(m,k*params.b));
    
    rpionchi=bterm-besterm;
endfunction





function RF=F(params,r)
    RF=(params.m.*btheta(params,r)./r)+(params.k.*bz(params,r));
endfunction

function RG=G(params,r)
    RG=(params.m.*bz(params,r)/.r)-(params.k.*btheta(params,r));
endfunction




function vomsz=omsz(params,r,m,k,om,p)
    rgamma=1.666666667;
    vomsz=(1/(2*rho(params,r)))*(k^2+(m./r)^2)*(rgamma*p+b(params,r)^2)*(1-sqrt(   (4*rgamma*p*(F(params,r,m,k))^2)/((k^2+(m/r)^2)*(rgamma*p+(b(params,r))^2)^2)     )) ;
endfunction

function vomfz=omfz(params,r,m,k,om,p)
    rgamma=1.666666667;
    vomfz=(1/(2*rho(params,r)))*(k^2+(m./r)^2)*(rgamma*p+b(params,r)^2)*(1+sqrt(   (4*rgamma*p*(F(params,r,m,k))^2)/((k^2+(m/r)^2)*(rgamma*p+(b(params,r))^2)^2)     )) ;
endfunction

function vvc=vc(params,r)
    vvc= sqrt(params.gamma*params.p/rho(params,r));
endfunction
function vvalf=valf(params,r)
    vvalf= (b(params,r)/sqrt(params.mu0*rho(params,r)));
endfunction

function vomalf=omalf(params,r)
    vomalf=sqrt(F(params,r)^2/(params.mu0*rho(params,r)));
endfunction

function vomc=omc(params,r)
    vomc=(vc(params,r)*omalf(params,r))/sqrt(vc(params,r)^2+valf(params,r)^2) ;
endfunction

function vc4=C4(params,r)
    vc4=(vc(params,r)^2+valf(params,r)^2)*(params.om^2-omc(params,r)^2);
endfunction


function RD=D(params,r)
    RD=C4(params,r)*rho(params,r)*(params.om^2-omalf(params,r)^2);
endfunction

function vc2=C2(params,r)
    vc2=(params.om)^4-(params.k^4+(params.m/r)^2)*C4(params,r);
endfunction

function vc1=C1(params,r)
    vc1=((2*btheta(params,r))/(params.mu0*r))*(params.om^4*btheta(params,r)-params.m*F(params,r)*C4(params,r)/r);
endfunction

function vc3=C3(params,r)
    vc3=rho(params,r)*D(params,r)*(params.om^2-omalf(params,r)^2+(2*btheta(params,r)*dbtheta(params,r)/(r*params.mu0*rho(params,r)))-(2*(btheta(params,r)/r)^2/(params.mu0*rho(params,r)))    );
    vc3=vc3+4*params.om^4*(btheta(params,r)/(params.mu0*r))^2;
    vc3=vc3-4*rho(params,r)*C4(params,r)*btheta(params,r)^2*omalf(params,r)^4/(params.mu0*r^2);
endfunction

function rchidash=chidash(params,r,chi,rpi)
    rchidash=(1/D(params,r))*(C1(params,r)*chi-r*C2(params,r)*rpi)
endfunction

function rpidash=pidash(params,r,chi,rpi)
    rpidash=(1/D(params,r))*((C3(params,r)*chi/r)-C1(params,r)*rpi);
endfunction




