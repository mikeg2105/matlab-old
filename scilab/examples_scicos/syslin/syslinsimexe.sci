getf("syslinsim.sci");  
// Example
Sys=(1-2*%s)/(1+%s+%s^2);
tf=20;dt=.01;
ui=0;
T=[ 2   4  7  9  ];
U=[ 2  -2  2  0  ];
[t,u,y]=syslinsim(Sys,tf,dt,ui,T,U);
// Display result
xset("window",1)
xbasc()
plot2d(t,u,2)
plot2d(t,y,5)
