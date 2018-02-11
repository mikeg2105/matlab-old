
    exec('myfunc.sci');
    //y=ode("rk",y0,t0,t,f)
    
    
    //initial condition at r=0
    //chidashi
    
    //chii
    
    
    //final condition at tub wal r=R (tube radius)
    //chidashf
    
    //chif
         n=20; 
      tchi(1:n)=zeros(n);
      
      tpi(1:n)=zeros(n);

      rw(1:4)=zeros(4);
      dchi(1:4)=zeros(4);
      dpi(1:4)=zeros(4);
      
      
      delta=0.01;
      rtube=4.2e6; //4.2Mm 4.2e6
      params.m=1;
      params.k=0.8e-6;
      params.om=5e-4;   //s^-1rad
      params.p=2.4e4;
      params.irpi=1e-6;   //Uuse initial bc
      params.irchi=1e-6; //use initial bc

      params.rpi=1e-6;   //Uuse initial bc
      params.rchi=1e-6; //use initial bc
      params.b0=1.0e4; 
      params.gamma=1.666666667;
      params.mu0=1.0;
      params.a=rtube;
      params.b=1.1*rtube;
      params.beta=2*params.p/(params.b0^2);
      params.mu1hat=mu1(params);
      tchi(1)=params.rchi;
      tpi(1)=params.rpi;
      
      maxits=100;
      //oma=.00115;
      //omb=.00118;
      oma=0.00001;
      omb=0.2;
      ka=1.0e-10;
      kb=1.0e-6;
      nkval=60;
      params.om=oma;
      deltaom=(omb-oma)/10;
      chiopia= -%inf ;
      chiopib= %inf;
      

      h=(rtube)/n;
      
      
      for ki=1:nkval
          
      params.k=ka+ki*(kb-ka)/nkval;
      
      kval(ki)=params.k;     
      soln=pionchi(params,params.m,params.k);
      fx=10*soln;
      nits(ki)=0;
      tol=0.000001;
      while abs(soln-fx)>=tol
      //while abs(omb-oma)>(%eps*omb)
      //for iom=1:10          
          //params.om=(oma+omb)/2;
          oldom=params.om;
          params.om=params.om+deltaom;
          tchi(1:n)=zeros(n);      
          tpi(1:n)=zeros(n); 
          tchi(1)=params.irchi;
          tpi(1)=params.irpi;
         
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
         nits(ki)=nits(ki)+1;
         fx=params.rpi/params.rchi;
         if fx>soln then
             params.om=oldom;
             deltaom=deltaom/2;
         else
             deltaom=deltaom*2;
         end
         omval(ki)=params.om;
         
         
         // disp(params.om);
         // disp( params.rpi/params.rchi);
         // disp(soln);
         // disp('next');
         
         if nits(ki)>maxits then
            tol=%inf; 
         end
         solnval(ki)=soln;
         fxval(ki)=fx;          
     end   //while loop
        disp(params.om);
        disp(params.k);
        disp(nits(ki));
        disp(soln);
        disp(fx);
        
        disp('next');
        
        save('m_1.mat',nits,omval,kval,solnval,fxval);
     end   // loop over kvalues
     
     