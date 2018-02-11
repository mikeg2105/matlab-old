
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
b = 1;
h0 = 5030;
damp=0.0;
force=0.0;
forcefreq=0.0;
k=1;

// Define the x domain
ni = 51;
xmax = 1.0;
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
dt = (0.68*dx)/wavespeed;
tmax = 2;
//t = [0:dt:tdomain];
t = 1:dt:tmax;
nt=max(size(t));
courant = (wavespeed*dt)/dx;

// Build empty u, v, b matrices
u = zeros(max(size(x)),max(size(y)),max(size(t)));
v = zeros(max(size(x)),max(size(y)),max(size(t)));
tv = zeros(max(size(x)),max(size(y)));

  for i = 2:ni-1
    for j = 2:nj-1
    
    
      u(i,j,1) = b*sin(i*dx*%pi)*sin(j*dx*%pi);
      v(i,j,1) = b*cos(i*dx*%pi)*cos(j*dx*%pi);    
 
    
    end;
  end;


// Employ Lax
for n = 1:max(size(t))-1
   dt=0.05; 
   t=n*dt;

    
  for i = 2:ni-1
    for j = 2:nj-1  
      tv(i,j) = (1.0-damp)*v(i,j,n)-(dt/2)*dx*k*(4*u(i,j,n)-u(i+1,j,n)-u(i-1,j,n)-u(i,j+1)-u(i,j-1,n))+force*dt*sin(forcefreq*t*%pi);
    end;
  end;


  for i = 2:ni-1
    for j = 2:nj-1  
      u(i,j,n+1) = u(i,j,n)+dt*tv(i,j);
    end;
  end;
  
  
   for i = 2:ni-1
    for j = 2:nj-1  
      v(i,j,n+1) = v(i,j,n)+(dt)*dx*k*(4*u(i,j,n+1)-u(i+1,j,n+1)-u(i-1,j)-u(i,j+1,n+1)-u(i,j-1,n+1))+force*dt*sin(forcefreq*t*%pi);
    end;
  end;
  // Define Boundary Conditions
  //u(1,:,n+1) = 2.5*u(2,:,n+1)-2*u(3,:,n+1)+0.5*u(4,:,n+1);
  //u(max(size(x)),:,n+1) = 2.5*u(ni-1,:,n+1)-2*u(ni-2,:,n+1)+0.5*u(ni-3,:,n+1);
  //u(:,1,n+1) = 2.5*u(:,2,n+1)-2*u(:,3,n+1)+0.5*u(:,4,n+1);
  //u(:,max(size(y)),n+1) = 2.5*u(:,nj-1,n+1)-2*u(:,nj-2,n+1)+0.5*u(:,nj-3,n+1);



end;
