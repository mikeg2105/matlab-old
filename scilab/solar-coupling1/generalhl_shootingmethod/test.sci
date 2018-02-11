 exec('myfunc.sci');
    //y=ode("rk",y0,t0,t,f)
    
    
    //initial condition at r=0
    //chidashi
    
    //chii
    
    
    //final condition at tub wal r=R (tube radius)
    //chidashf
    
    //chif
         n=200; 
      tchi(1:n)=zeros(n);
      
      tpi(1:n)=zeros(n);

      rw(1:4)=zeros(4);
      dchi(1:4)=zeros(4);
      dpi(1:4)=zeros(4);
      
      rtube=4.2e6;
      params.m=0;
      params.k=0.8e-6;
      params.om=2e-2;   //s^-1rad
      params.p=2.4e4;
      params.rpi=1e-6;   //Uuse initial bc
      params.rchi=1e-6; //use initial bc
      
      tchi(1)=params.rchi;
      tpi(1)=params.rpi;
      

      h=(rtube)/n;      
      
      for i=1:n
         res(i)=1./N(rar(i),params.m,params.k,params.om,params.p);
      end