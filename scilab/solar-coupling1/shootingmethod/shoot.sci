
    exec('myfunc.sci');
    //y=ode("rk",y0,t0,t,f)
    
    
    //initial condition at r=0
    //chidashi
    
    //chii
    
    
    //final condition at tub wal r=R (tube radius)
    //chidashf
    
    //chif
         n=50; 
      tchi(1:n)=zeros(n);
      
      tpi(1:n)=zeros(n);

      rw(1:4)=zeros(4);
      dchi(1:4)=zeros(4);
      dpi(1:4)=zeros(4);
      
      tol=0.000001;
      delta=0.01;
      rtube=4.2e6; //4.2Mm 4.2e6
      params.m=0;
      params.k=0.8e-6;
      params.om=5e-4;   //s^-1rad
      params.p=2.4e4;
      params.rpi=1e-6;   //Uuse initial bc
      params.rchi=1e-6; //use initial bc
      params.b0=1.0e4; 
      params.a=rtube;
      params.b=1.1*rtube;
      params.beta=2*params.p/(params.b0^2);
      params.mu1hat=mu1(params);
      tchi(1)=params.rchi;
      tpi(1)=params.rpi;
      
      oma=.00115;
      omb=.00118;
      params.om=oma;
      deltaom=(omb-oma)/10;
      chiopia= -%inf ;
      chiopib= %inf;
      

      h=(rtube)/n;      
      soln=pionchi(params,params.m,params.k);
      fx=10*soln;
      
      while abs(soln-fx)>=tol
      //while abs(omb-oma)>(%eps*omb)
      //for iom=1:10          
          //params.om=(oma+omb)/2;
          oldom=params.om;
          params.om=params.om+deltaom;
          
          for i=2:n
           rt=(i-1)*h;
              for j=1:4
                  rrt=rt+rw(j).*h;
                  dchi(j)=h*myfuncchi(params,tchi(i-1),tpi(i-1),rrt);
                  dpi(j)=h*myfuncpi(params,tchi(i-1),tpi(i-1),rrt);
              end
           tpi(i)=tpi(i-1)+(dpi(1)+dpi(4)+2*(dpi(2)+dpi(3)))/6.0;
           tchi(i)=tchi(i-1)+(dchi(1)+dchi(4)+2*(dchi(2)+dchi(3)))/6.0;
           
           params.rpi=tpi(i);
           params.rchi=tchi(i);
           
           
         end
         
         fx=params.rpi/params.rchi;
         if fx>soln then
             params.om=oldom;
             deltaom=deltaom/2;
         else
             deltaom=deltaom*2;
         end
        
          disp(params.om);
          disp( params.rpi/params.rchi);
          disp(soln);
          disp('next');
          
         //if sign(soln-(params.rpi/params.rchi))==sign(soln-chiopia) then
         //   oma = params.om
         //   chiopia = params.rpi/params.rchi
         //else
         //   omb = params.om
         //   chiopib = params.rpi/params.rchi
         //end;            
     end