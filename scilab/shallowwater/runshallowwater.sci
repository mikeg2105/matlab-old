
// Display mode
mode(0);

// Display warning for floating point exception
ieee(1);

//Steven McHale
//Tsunami Model
//Shallow-Water Wave Equation
//Crank-Nicholson Discretization

clear;
//clf;
clc;

// Constants
g = 9.81;
u0 = 0;
v0 = 0;
b = 0;
h0 = 5030;

// Define the x domain
ni = 51;
xmax = 100000;
dx = xmax/(ni-1);
x = 0:dx:xmax;

// Define the y domain
nj = 51;
ymax = 100000;
dy = ymax/(nj-1);
y = 0:dy:ymax;

// Define the wavespeed
wavespeed = u0+sqrt(g*(h0-b));

// Define time-domain
dt = (0.68*dx)/wavespeed;
tmax = 1500;
//t = [0:dt:tdomain];
t = 1:dt:tmax;
courant = (wavespeed*dt)/dx;

// Build empty u, v, b matrices
u = zeros(max(size(x)),max(size(y)),max(size(t)));
v = zeros(max(size(x)),max(size(y)),max(size(t)));
b = zeros(max(size(x)),max(size(y)));

// Define h
h = zeros(max(size(x)),max(size(y)),max(size(t)));
h(:,:,1) = 5000;
h((45000/100000)*(max(size(x))-1)+1:floor((55000/100000)*(max(size(x))-1)+1),(45000/100000)*(max(size(y))-1)+1:floor((55000/100000)*(max(size(y))-1)+1),1) = 5030;

//Define b
for i = 1:max(size(x))
  if x(i)>20001 then
    b(:,i) = 0;
  elseif x(i)<20000 then
    b(:,i) = (5000/20000)*(20000-x(i));
  end;
end;

// Employ Lax
for n = 1:max(size(t))-1
  for i = 2:ni-1
    for j = 2:nj-1
    
    
      u(i,j,n+1) = (u(i+1,j,n)+u(i-1,j,n)+u(i,j+1,n)+u(i,j-1,n))/4-(0.5*(dt/dx))*((u(i+1,j,n)^2)/2-(u(i-1,j,n)^2)/2)-((0.5*(dt/dy))*v(i,j,n))*(u(i,j+1,n)-u(i,j-1,n))-((0.5*g)*(dt/dx))*(h(i+1,j,n)-h(i-1,j,n));
    
    
    
      v(i,j,n+1) = (v(i+1,j,n)+v(i-1,j,n)+v(i,j+1,n)+v(i,j-1,n))/4-(0.5*(dt/dy))*((v(i,j+1,n)^2)/2-(v(i,j+1,n)^2)/2)-((0.5*(dt/dx))*u(i,j,n))*(v(i+1,j,n)-v(i-1,j,n))-((0.5*g)*(dt/dy))*(h(i,j+1,n)-h(i,j-1,n));
    
    
    
    
    
      h(i,j,n+1) = (h(i+1,j,n)+h(i-1,j,n)+h(i,j+1,n)+h(i,j-1,n))/4-((0.5*(dt/dx))*u(i,j,n))*(h(i+1,j,n)-b(i+1,j)-(h(i-1,j,n)-b(i-1,j)))-((0.5*(dt/dy))*v(i,j,n))*(h(i,j+1,n)-b(i,j+1)-(h(i,j-1,n)-b(i,j-1)))-((0.5*(dt/dx))*(h(i,j,n)-b(i,j)))*(u(i+1,j,n)-u(i-1,j,n))-((0.5*(dt/dy))*(h(i,j,n)-b(i,j)))*(v(i,j+1,n)-v(i,j-1,n));
    
    end;
  end;

  // Define Boundary Conditions
  u(1,:,n+1) = 2.5*u(2,:,n+1)-2*u(3,:,n+1)+0.5*u(4,:,n+1);
  u(max(size(x)),:,n+1) = 2.5*u(ni-1,:,n+1)-2*u(ni-2,:,n+1)+0.5*u(ni-3,:,n+1);
  u(:,1,n+1) = 2.5*u(:,2,n+1)-2*u(:,3,n+1)+0.5*u(:,4,n+1);
  u(:,max(size(y)),n+1) = 2.5*u(:,nj-1,n+1)-2*u(:,nj-2,n+1)+0.5*u(:,nj-3,n+1);

  v(1,:,n+1) = 2.5*v(2,:,n+1)-2*v(3,:,n+1)+0.5*v(4,:,n+1);
  v(max(size(x)),:,n+1) = 2.5*v(ni-1,:,n+1)-2*v(ni-2,:,n+1)+0.5*v(ni-3,:,n+1);
  v(:,1,n+1) = 2.5*v(:,2,n+1)-2*v(:,3,n+1)+0.5*v(:,4,n+1);
  v(:,max(size(y)),n+1) = 2.5*v(:,nj-1,n+1)-2*v(:,nj-2,n+1)+0.5*v(:,nj-3,n+1);

  h(1,:,n+1) = 2.5*h(2,:,n+1)-2*h(3,:,n+1)+0.5*h(4,:,n+1);
  h(max(size(x)),:,n+1) = 2.5*h(ni-1,:,n+1)-2*h(ni-2,:,n+1)+0.5*h(ni-3,:,n+1);
  h(:,1,n+1) = 2.5*h(:,2,n+1)-2*h(:,3,n+1)+0.5*h(:,4,n+1);
  h(:,max(size(y)),n+1) = 2.5*h(:,nj-1,n+1)-2*h(:,nj-2,n+1)+0.5*h(:,nj-3,n+1);

end;
