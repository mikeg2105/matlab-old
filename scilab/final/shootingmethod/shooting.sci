function sol=myshooting(a,delta,funx,dfunx)
    
    y=ode("rk",y0,t0,t,f)
//delta=0.0001;
x=a+sqrt(delta);
//fx = 0.5*sin(2*(x-(%pi/4)))+h*sin(x);
fx=funx(x);
while (abs(fx))>=delta

  a=x;
  
  //fx = 0.5*sin(2*(x-(%pi/4)))+h*sin(x);
  fx=funx(x);
  dfx=dfunx(x);
  //dfx= cos(2*(x-(%pi/4)))+h*cos(x);
  x=a-(fx/dfx);
end;
sol=x;

endfunction;
