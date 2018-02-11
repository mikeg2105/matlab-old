
// Display mode
//mode(0);

// Display warning for floating point exception
//ieee(1);

//Steven McHale
//Tsunami Model
//Shallow-Water Wave Equation
//Crank-Nicholson Discretization

//clear;
//clf;
//clc;

// Constants
g = 9.81;
u0 = 0;
v0 = 0;
b = 0;
h0 = 5030;
mu0=4*%pi/(10000000);
agamma=5/3;

// Define the x domain
//ni = 151;
ni = 51;
xmax = 100000;
dx = xmax/(ni-1);
x = 0:dx:xmax;

// Define the y domain
//nj = 151;

nj = 51;
ymax = 100000;
dy = ymax/(nj-1);
y = 0:dy:ymax;

// Define the wavespeed
wavespeed = u0+sqrt(g*(h0-b));

// Define time-domain
dt = (0.68*dx)/wavespeed;
//tmax = 1500;
tmax=375;
//tmax=50;
//t = [0:dt:tdomain];
t = 1:dt:tmax;
courant = (wavespeed*dt)/dx;

// Build empty u, v, b matrices
u = zeros(max(size(x)),max(size(y)),2);
v = zeros(max(size(x)),max(size(y)),2);
p = ones(max(size(x)),max(size(y)),2);
b = zeros(max(size(x)),max(size(y)),2);
bx = ones(max(size(x)),max(size(y)),2);
by = zeros(max(size(x)),max(size(y)),2);

// Define h
h = zeros(max(size(x)),max(size(y)),2);
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

//if running using the white rose grid easa application portal 
//we set the directory to ''
//and extract the data 
//directory='out/'
directory='out/'
jobname='t1';
outfile=directory+'job'+jobname+'.out';
formfile=directory+'jobform'+jobname+'.out';
dxgenfile=directory+'job'+jobname+'.general';
dxformgenfile=directory+'job'+jobname+'_form.general';
fdform=mopen(formfile,'w');
  mfprintf(fdform, '%d %d %d\n',max(size(t))-1, ni, nj);
mclose(fdform);


//generate dx general file for this data set
//file=out/job.out
//grid 51 x 51
//format = ascii
//interleaving = field
//majority = row
//header = lines 1

//series =  24 , 1, 1, separator=lines 1
//field = field0, field1
//structure = 2-vector, scalar
//type = float, float
//dependency = positions, positions
//positions = regular,regular, 0, 1,0,1

//end
dxgenfile=directory+'job'+jobname+'.general';

fdform=mopen(dxgenfile,'w');
  mfprintf(fdform, 'file=%s\n', 'out/job'+jobname+'.out');
  mfprintf(fdform,'grid %d X %d\n',ni,nj);
  mfprintf(fdform,'format = ascii \n interleaving = field \n majority = row \n header = lines 1 \n');
  mfprintf(fdform, 'series =  %d  , 1, 1, separator=lines 1\n',max(size(t))-1);
  mfprintf(fdform, 'field = v, rho,p,b \n structure = 2-vector, scalar,scalar,2-vector \n type = float, float, float, float  \n dependency = positions, positions,positions, positions  \n positions = regular,regular, 0, 1,0,1 \n end \n ');
mclose(fdform);


//file=out/jobform.out
//grid = 1
//format = ascii
//interleaving = record
//majority = row
//field = nsteps, nx, ny
//structure = scalar, scalar, scalar
//type = int, int, int
//dependency = positions, positions, positions
//positions = regular, 0, 1

//end

dxformgenfile=directory+'job'+jobname+'_form.general';
fdform=mopen(dxformgenfile,'w');
  mfprintf(fdform, 'file=%s\n', 'out/jobform'+jobname+'.out');
  mfprintf(fdform,'grid=1\n');
  mfprintf(fdform,'format = ascii \n interleaving = record \n majority = row \n');
  mfprintf(fdform, 'field = nsteps, ,nx, ny \n structure = scalar, scalar, scalar \n type = int, int, int  \n dependency = positions, positions,positions  \n positions = regular, 0, 1 \n end \n ');
mclose(fdform);  






fd=mopen(outfile,'w');
// Employ Lax

for na = 1:max(size(t))-1
  n=1;
  na
  for i = 2:ni-1
    for j = 2:nj-1
    
       rhobar=0.25*((h(i+1,j,n)+h(i-1,j,n)+h(i,j+1,n)+h(i,j-1,n)));
       pbar=0.25*((p(i+1,j,n)+p(i-1,j,n)+p(i,j+1,n)+p(i,j-1,n)));
       bxbar=0.25*((bx(i+1,j,n)+bx(i-1,j,n)+bx(i,j+1,n)+bx(i,j-1,n)));
       bybar=0.25*((by(i+1,j,n)+by(i-1,j,n)+by(i,j+1,n)+by(i,j-1,n)));
 
      u(i,j,n+1) = (u(i+1,j,n)+u(i-1,j,n)+u(i,j+1,n)+u(i,j-1,n))/4-(0.5*(dt/dx))*u(i,j,n)*((u(i+1,j,n))-(u(i-1,j,n)))-((0.5*(dt/dy))*v(i,j,n))*(v(i,j+1,n)-v(i,j-1,n))-(1/rhobar)*((dt/(2.0*dx))*(p(i+1,j,n)-p(i-1,j,n)))+(1/(2*mu0*rhobar))*(by(i,j,n)*((dt/dy)*(bx(i,j+1,n)-bx(i,j-1,n)))-(dt/dx)*(by(i+1,j,n))-by(i+1,j));
    
    
    
      v(i,j,n+1) = (v(i+1,j,n)+v(i-1,j,n)+v(i,j+1,n)+v(i,j-1,n))/4-(0.5*(dt/dy))*v(i,j,n)*((v(i,j+1,n))/2-(v(i,j+1,n))/2)-((0.5*(dt/dx))*u(i,j,n))*(u(i+1,j,n)-u(i-1,j,n))+(1/rhobar)*((dt/(2*dy))*(p(i,j+1,n)-p(i,j-1,n)))+(1/(2*mu0*rhobar))*(bx(i,j,n)*((dt/dx)*(by(i+1,j,n)-by(i-1,j,n)))-(dt/dy)*(bx(i,j+1,n))-bx(i,j-1,n));
    
       
    
    
    
      h(i,j,n+1) = (h(i+1,j,n)+h(i-1,j,n)+h(i,j+1,n)+h(i,j-1,n))/4-((0.5*(dt/dx))*u(i,j,n))*(h(i+1,j,n)-b(i+1,j)-(h(i-1,j,n)-b(i-1,j)))-((0.5*(dt/dy))*v(i,j,n))*(h(i,j+1,n)-b(i,j+1)-(h(i,j-1,n)-b(i,j-1)))-((0.5*(dt/dx))*(h(i,j,n)-b(i,j)))*(u(i+1,j,n)-u(i-1,j,n))-((0.5*(dt/dy))*(h(i,j,n)-b(i,j)))*(v(i,j+1,n)-v(i,j-1,n));
      
      dp1=u(i,j,n)*((dt/(2*dx))*(p(i+1,j,n)-p(i-1,j,n)));
      dp2=v(i,j,n)*((dt/(2*dy))*(p(i,j+1,n)-p(i,j-1,n)));
      dp3=(dt/(2*dx))*(u(i+1,j,n)-u(i-1,j,n));
      dp4=(dt/(2*dy))*(v(i,j+1,n)-v(i,j-1,n));
      p(i,j,n+1)=pbar-dp1-dp2-agamma*p(i,j,n)*(dp3+dp4);
      
      bx(i,j,n+1)=bxbar+(dt/(2*dy))*(by(i,j,n)*(u(i,j+1,n)-u(i,j-1,n))+u(i,j,n)*(by(i,j+1,n)-by(i,j-1,n))-bx(i,j,n)*(v(i,j+1,n)-v(i,j-1,n))+v(i,j,n)*(bx(i,j+1,n)-bx(i,j-1,n)));
      by(i,j,n+1)=bybar+(dt/(2*dx))*(bx(i,j,n)*(v(i+1,j,n)-v(i-1,j,n))+v(i,j,n)*(bx(i+1,j,n)-bx(i-1,j,n))-by(i,j,n)*(u(i+1,j,n)-v(i-1,j,n))+u(i,j,n)*(by(i+1,j,n)-by(i-1,j,n)));
     
      
      
      
    
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
 
  p(1,:,n+1) = 2.5*p(2,:,n+1)-2*p(3,:,n+1)+0.5*p(4,:,n+1);
  p(max(size(x)),:,n+1) = 2.5*p(ni-1,:,n+1)-2*p(ni-2,:,n+1)+0.5*p(ni-3,:,n+1);
  p(:,1,n+1) = 2.5*p(:,2,n+1)-2*p(:,3,n+1)+0.5*p(:,4,n+1);
  p(:,max(size(y)),n+1) = 2.5*p(:,nj-1,n+1)-2*p(:,nj-2,n+1)+0.5*p(:,nj-3,n+1);
  
  bx(1,:,n+1) = 2.5*bx(2,:,n+1)-2*bx(3,:,n+1)+0.5*bx(4,:,n+1);
  bx(max(size(x)),:,n+1) = 2.5*bx(ni-1,:,n+1)-2*bx(ni-2,:,n+1)+0.5*bx(ni-3,:,n+1);
  bx(:,1,n+1) = 2.5*bx(:,2,n+1)-2*bx(:,3,n+1)+0.5*bx(:,4,n+1);
  bx(:,max(size(y)),n+1) = 2.5*bx(:,nj-1,n+1)-2*bx(:,nj-2,n+1)+0.5*bx(:,nj-3,n+1);
  
  by(1,:,n+1) = 2.5*by(2,:,n+1)-2*by(3,:,n+1)+0.5*by(4,:,n+1);
  by(max(size(x)),:,n+1) = 2.5*by(ni-1,:,n+1)-2*by(ni-2,:,n+1)+0.5*by(ni-3,:,n+1);
  by(:,1,n+1) = 2.5*by(:,2,n+1)-2*by(:,3,n+1)+0.5*by(:,4,n+1);
  by(:,max(size(y)),n+1) = 2.5*by(:,nj-1,n+1)-2*by(:,nj-2,n+1)+0.5*by(:,nj-3,n+1);
  
  u(:,:,n)=u(:,:,n+1);
  v(:,:,n)=v(:,:,n+1);
  h(:,:,n)=h(:,:,n+1);
  p(:,:,n)=p(:,:,n+1);
  bx(:,:,n)=bx(:,:,n+1);
  by(:,:,n)=by(:,:,n+1);
  
  //Write data to output
 mfprintf(fd, '%d %d %d\n',n, ni, nj);
 for j1=1:ni
  for j2=1:nj
      mfprintf(fd, '%f %f %f %f %f %f\n',u(j1,j2,n),v(j1,j2,n),h(j1,j2,n)-5000,p(j1,j2,n),bx(j1,j2,n),by(j1,j2,n));
      //mfprintf(fd, '%f\n',h(j1,j2,n)-5000);
  end
  
 end
//mfprintf(fd, '\n');  

end;
mclose(fd);


