function fx=myfunc1(q,x)

   //FUN(X,Q)=-15.915494*Q/(2-X)**2
  fx = -15.915494*q/((2-x)^2);

endfunction;


function fx=myfunc2(x)

  h=1;
  fx = 0.5*sin(2*(x-(%pi/4)))+h*sin(x);
  //dfx= cos(2*(x-(%pi/4)))+h*cos(x);

endfunction;

function dfx=mydiffunc2(x)

  h=1;
  //fx = 0.5*sin(2*(x-(%pi/4)))+const.h*sin(x);
  dfx= cos(2*(x-(%pi/4)))+h*cos(x);

endfunction;

function rb=b(r)
    const=1.0;
    rb=const;
endfunction

function rbtheta=btheta(r)
    const=1.0;
    rbtheta=const;
endfunction

function rdbtheta=dbtheta(r)
    const=0.0;
    rdbtheta=const;
endfunction

function rbz=bz(r)
    const=1.0;
    rbz=const;
endfunction

function RF=F(r,m,k)
    RF=(m*btheta(r)/r)+(k*bz(r));
endfunction

function RG=G(r,m,k)
    RG=(m*bz(r)/r)+(k*btheta(r));
endfunction

function RC=C(r,m,k,rho,om,p)
    rgamma=1.666666667;
    RC=((-2*(btheta(r))^2*rho^2*om^4)/(r^2))+(2*m*btheta(r)*F(r,m,k,)/r^3)*((rgamma*p+(b(r))^2)*rho*om^2-rgamma*p*(F(r,m,k))^2);
endfunction

function RD=D(r,m,k,rho,om,p)
    rgamma=1.666666667;
    RD=(rho*om^2)^2-(k^2+(m/r)^2)*(rgamma*p+b(r)^2)*(rho*om^2)+(k^2+(m/r)^2)*(rgamma*p)*(F(r,m,k))^2;
endfunction

function RN=N(r,m,k,rho,om,p)
    rgamma=1.666666667;
    RN=(rho*om^2-F(r,m,k)^2)*((rgamma*p+b(r)^2)*(rho*om^2)-(rgamma*p*F(r,m,k)^2));
endfunction

function RE=E(r,m,k,rho,om,p)
    rgamma=1.666666667;
    RE=((4*btheta(r)^2*F(r,m,k)^4)/(r^4))*((rgamma*p+(b(r))^2)*rho*om^2-rgamma*p*(F(r,m,k))^2)-(4*btheta(r)^4*rho^2*om^4/(r^4))-(N(r,m,k,rho,om,p)/r)*(  ((rho*om^2-(F(r,m,k))^2/r) +(2*dbtheta(r)/(r^2))+2*(btheta(r))^2/(r^3)  ));
endfunction

function rchidash=chidash(r,m,k,rho,om,p,chi,rpi)
    rgamma=1.666666667;
    rchidash=-(r/N(r,m,k,rho,om,p))*(C(r,m,k,rho,om,p)*chi+D(r,m,k,rho,om,p)*rpi);
endfunction

function rpidash=pidash(r,m,k,rho,om,p,chi,rpi)
    rgamma=1.666666667;
    rpidash=-(r/N(r,m,k,rho,om,p))*(E(r,m,k,rho,om,p)*chi-C(r,m,k,rho,om,p)*rpi);
endfunction

function rpi=fpi(r,m,k,rho,om,p,chi,chidash)
    rgamma=1.666666667;
    rpi=-(chidash*(N(r,m,k,rho,om,p)/(r*D(r,m,k,rho,om,p))))+(2*chi*btheta(r)^2/(r^2))-(2*chi*k*btheta(r)*G(r,m,k)/(r^2*D(r,m,k,rho,om,p)))*((rgamma*p+(b(r))^2)*rho*om^2-rgamma*p*(F(r,m,k))^2);
endfunction



