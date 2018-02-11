
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

// Define time-domain
dt = 10*(0.68*dx)/wavespeed;
tmax = 100;
//t = [0:dt:tdomain];
t = 1:dt:tmax;
nt=max(size(t));
courant = (wavespeed*dt)/dx;
nt=100;
// Build empty u, v, b matrices
u = rand(ni,1);
v = zeros(ni,1);
tv = zeros(ni,1);
uh = zeros(ni,1);
vh = zeros(ni,1);

u((ni+1)/2)=b;
  for i = 2:ni-1

        u(i) = -b*sin(i*dx*%pi);
      vh(i) = b*cos(i*dx*%pi);    
       uh(i)=(u(i-1)+u(i+1))/2;
       vh(i)=(v(i-1)+v(i+1))/2;
 

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



drawnow();
// Employ Lax
for n = 1:nt
   dt=0.01; 
   t=n*dt;

    
  for i = 2:ni-1
 
      vh(i) = ((v(i+1)+v(i))/2)+(dt/2)*(damp*v(i)+dx*k*(u(i)));//+force*dt*sin(forcefreq*t*%pi);
            uh(i)=uh(i)+(dt/2)*(v(i+1)+v(i))/2;

  end;

  
      //       tv((ni+1)/2,(nj+1)/2) = tv((ni+1)/2,(nj+1)/2)+force*dt*sin(forcefreq*t*%pi);            

  //for i = 2:ni-1
  //  for j = 2:nj-1  
  //    u(i,j) = u(i,j)+dt*tv(i,j);
  //  end;
  //end;
  
  
   for i = 2:ni-1
      
      v(i) = v(i)-dt*(damp*vh(i)+k*dx*uh(i));//+force*dt*sin(forcefreq*t*%pi);
      u(i)=u(i)+(dt)*(v(i))/2;
  
  end;
  
     for i = 2:ni-1
    
      v(i) = v(i)-(dt)*dx*k*(4*u(i)-u(i+1)-u(i-1)-u(i)-u(i));//+force*dt*sin(forcefreq*t*%pi);
      uh(i)=uh(i)+(dt/2)*(vh(i))/2;
  
  end;

     //v((ni+1)/2,(nj+1)/2) = v((ni+1)/2,(nj+1)/2)+force*dt*sin(forcefreq*t*%pi);               
 
  // Define Boundary Conditions
  //u(1,:,n+1) = 2.5*u(2,:,n+1)-2*u(3,:,n+1)+0.5*u(4,:,n+1);
  //u(max(size(x)),:,n+1) = 2.5*u(ni-1,:,n+1)-2*u(ni-2,:,n+1)+0.5*u(ni-3,:,n+1);
  //u(:,1,n+1) = 2.5*u(:,2,n+1)-2*u(:,3,n+1)+0.5*u(:,4,n+1);
  //u(:,max(size(y)),n+1) = 2.5*u(:,nj-1,n+1)-2*u(:,nj-2,n+1)+0.5*u(:,nj-3,n+1);
// outfile=sprintf('out/outfile_%d.out',n);
//save(outfile,u,v);
 //realtime(i); //wait till date 0.1*i seconds
  //s.data.z = (sin((I(i)/10)*x)'*cos((I(i)/10)*y))';
//  s.data.y = u(:,25);
  //s.data = u(:,25);
  clf;
  xset('pixmap',1);
plot2d(x,u(:),rect=[0 -4 1.0 4.0]);

xset('wshow');


end;
