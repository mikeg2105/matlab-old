
// Display mode
mode(0);

// Display warning for floating point exception
ieee(1);



clear;
//clf;
clc;

// Constants
g = 9.81;
u0 = 0;
v0 = 0;
b = 2;
h0 = 5030;
damp=0.0;
force=0.1;
forcefreq=0.1;
k=2.5;

// Define the x domain
ni = 1001;
xmax = 10.0;
dx = xmax/(ni-1);
x = 0:dx:xmax;

// Define the y domain
nj = 51;
ymax = 1.0;
dy = ymax/(nj-1);
y = 0:dy:ymax;

// Define the wavespeed
wavespeed = u0+sqrt(k);
wavespeed=0.01;

// Define time-domain
dt = 10*(0.68*dx)/wavespeed;
tmax = 10;
//t = [0:dt:tdomain];
t = 1:dt:tmax;
dt=0.5
dt=0.001
dx=10.0
courant=0.15
wavespeed=courant*dx/dt
//courant = (wavespeed*dt)/dx;
nt=100;
hmax=3;
n1=75;
n2=100;
n3=125;

// Build empty u, v, b matrices
u = rand(ni,1);
v = zeros(ni,1);
tv = zeros(ni,1);
uh = zeros(ni,1);
vh = zeros(ni,1);

//u((ni+1)/2)=b;
  for i = 1:ni

        u(i) = 0.0;
        
        if i>n1 then
            if i<n2 then
               //u(i)=hmax*(i-n1)/(n2-n1);
               u(i)=hmax;
            end
        end
        
        if i>=n2 then
             if i<n3 then
                //u(i)=hmax*(n3-i)/(n3-n2);  
                u(i)=hmax;             
             end
        end
      //vh(i) =0.1;    
      // uh(i)=(u(i-1)+u(i+1))/2;
      // vh(i)=(v(i-1)+v(i+1))/2;
 

  end;
  
curFig             = scf(100001);
clf(curFig,"reset");
//demo_viewCode("membrane.sce");

drawlater();

xselect(); //raise the graphic window


// set a new colormap
//-------------------
cmap= curFig.color_map; //preserve old setting
curFig.color_map = jetcolormap(64);

//plot3d1(x,25,u(:,25),35,45,' ');
plot2d(x,u(:));
s=gce(); //the handle on the surface
//s.color_flag=1 ; //assign facet color according to Z value
title("evolution of a 3d surface","fontsize",3)


vw=0.1;
drawnow();
// Employ Lax
for n = 1:nt
   //dt=0.001; 
   t=n*dt;
   c=-wavespeed*dt/dx;
    
 
 //for ns=1:100;
 
     for i = 2:ni-1
    
      v(i) = u(i)+c*(u(i+1)-u(i-1))/2+c^2*(u(i+1)-2*u(i)+u(i-1))/2;//+force*dt*sin(forcefreq*t*%pi);
      
  
      end;
     for i = 2:ni-1
         u(i)=v(i);
         end;
 // end;
  clf;
  xset('pixmap',1);
//plot2d(x,u(:),rect=[0 -4 1.0 4.0]);
plot2d(x,u(:));
xset('wshow');


end;
