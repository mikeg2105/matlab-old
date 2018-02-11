jobname='test1_11';
exec("h3_dx.sce");
exec("initial.sce");
exec("analywave.sce");
exec("spheretocart.sce");
exec("invert.sce");
exec("centralderiv.sce");
exec("curelation.sce");
exec("method.sce");
exec("sources.sce");
exec("fluxes.sce");
exec("boundaries.sce");
exec("onebound.sce");
iterations=20.000000;
nx=6.000000;
ny=6.000000;
nz=6.000000;
dx=0.020000;
dy=0.020000;
dz=0.020000;
par1=0.001200;
par2=-2.000000;
h3_dx(iterations,nx,ny,nz,dx,dy,dz,par1,par2,jobname);
exit;
