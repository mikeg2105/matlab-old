%These "parameters" will be set by calling readinput and passed to 
%     the main H3 code:
%        nx,ny,nz  : grid sizes of the 3d cube.
%        dx,dy,dz  : grid spacings
%        iterations: the number of iterations to evolve
%        par1,par2 : Parameters for the initial data.  %

%[iterations,nx,ny,nz,dx,dy,dz,par1,par2]=readinput();
jobname='test2';
iterations=10;
nx=20;
ny=20;
nz=20;
dx=0.02;
dy=0.02;
dz=0.02;
par1=0.0002;  %amplitude
par2=-2;   %shape -2<shape<2
h3_writedat(iterations,nx,ny,nz,dx,dy,dz,par1,par2,jobname);

