jobname='test1_1';
exec('resources/h3_parts_dx.sce');
exec('resources/initial_parts.sce');
exec('resources/enmomt_parts.sce');
exec('resources/analywave.sce');
exec('resources/spheretocart.sce');
exec('resources/invert.sce');
exec('resources/centralderiv.sce');
exec('resources/curelation.sce');
exec('resources/method_parts.sce');
exec('resources/sources_parts.sce');
exec('resources/fluxes.sce');
exec('resources/boundaries.sce');
exec('resources/onebound.sce');


mkdir('results');
chdir('results');

iterations=10.000000;
nx=20.000000;
ny=20.000000;
nz=20.000000;
dx=0.10000;
dy=0.10000;
dz=0.10000;
par1=0.000200;
par2=-2.000000;
mass=5;
vp=0.3;
nparts=1;
stacksize(64000000);
h3_parts_dx(iterations,nx,ny,nz,dx,dy,dz,par1,par2,vp,mass,nparts,jobname);
exit;
