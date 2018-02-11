//These "parameters" will be set by calling readinput and passed to 
//     the main H3 code:
//        nx,ny,nz  : grid sizes of the 3d cube.
//        dx,dy,dz  : grid spacings
//        iterations: the number of iterations to evolve
//        par1,par2 : Parameters for the initial data.  //

//[iterations,nx,ny,nz,dx,dy,dz,par1,par2]=readinput();

exec('resources/h3_dx.sce');
exec('resources/initial.sce');
exec('resources/analywave.sce');
exec('resources/spheretocart.sce');
exec('resources/invert.sce');
exec('resources/centralderiv.sce');
exec('resources/curelation.sce');
exec('resources/method.sce');
exec('resources/sources.sce');
exec('resources/fluxes.sce');
exec('resources/boundaries.sce');
exec('resources/onebound.sce');

mkdir('results');
chdir('results');



jobname='test1';
iterations=10;
nx=6;
ny=6;
nz=6;
dx=0.02;
dy=0.02;
dz=0.02;
par1=0.0002;  //amplitude
par2=-2;   //shape -2<shape<2
h3_dx(iterations,nx,ny,nz,dx,dy,dz,par1,par2,jobname);
