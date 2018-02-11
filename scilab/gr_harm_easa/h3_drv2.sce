//These "parameters" will be set by calling readinput and passed to 
//     the main H3 code:
//        nx,ny,nz  : grid sizes of the 3d cube.
//        dx,dy,dz  : grid spacings
//        iterations: the number of iterations to evolve
//        par1,par2 : Parameters for the initial data.  //

//[iterations,nx,ny,nz,dx,dy,dz,par1,par2]=readinput();
clear;
jobname='tbg4';

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



iterations=20;
nx=50;
ny=50;
nz=50;
dx=0.02;
dy=0.02;
dz=0.02;
par1=0.015;  //amplitude
par2=-1;   //shape -2<shape<2
h3(iterations,nx,ny,nz,dx,dy,dz,par1,par2,jobname);


chdir('..');

//clear;
//jobname='tbg1';
//niters=99;
//nx=80;
//ny=80;
//nz=80;
//read each filei turn
//produce separate filecontaining timeslices foreach variable

resarray=cell(1,iterations);
//Load aeach data set in turn create cell array
//Do animation
for currentiter=1:iterations
    inname=sprintf('results/%s_%d.mat',jobname, currentiter);
    load(inname);
    resarray{currentiter}=gxx;
end
outname=sprintf('results/%s_gxx.mat',jobname);
save(outname, 'resarray');


for currentiter=1:iterations
    inname=sprintf('results/%s_%d.mat',jobname, currentiter);
    load(inname);
    resarray{currentiter}=gxy;
end
outname=sprintf('results/%s_gxy.mat',jobname);
save(outname, 'resarray');

for currentiter=1:iterations
    inname=sprintf('results/%s_%d.mat',jobname, currentiter);
    load(inname);
    resarray{currentiter}=gxz;
end
outname=sprintf('results/%s_gxz.mat',jobname);
save(outname, 'resarray');
for currentiter=1:iterations
    inname=sprintf('results/%s_%d.mat',jobname, currentiter);
    load(inname);
    resarray{currentiter}=gyy;
end
outname=sprintf('results/%s_gyy.mat',jobname);
save(outname, 'resarray');

for currentiter=1:iterations
    inname=sprintf('results/%s_%d.mat',jobname, currentiter);
    load(inname);
    resarray{currentiter}=gyz;
end
outname=sprintf('results/%s_gyz.mat',jobname);
save(outname, 'resarray');

for currentiter=1:iterations
    inname=sprintf('results/%s_%d.mat',jobname, currentiter);
    load(inname);
    resarray{currentiter}=gzz;
end
outname=sprintf('results/%s_gzz.mat',jobname);
save(outname, 'resarray');


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
for currentiter=1:iterations
    inname=sprintf('results/%s_%d.mat',jobname, currentiter);
    load(inname);
    resarray{currentiter}=qxx;
end
outname=sprintf('results/%s_qxx.mat',jobname);
save(outname, 'resarray');


for currentiter=1:iterations
    inname=sprintf('results/%s_%d.mat',jobname, currentiter);
    load(inname);
    resarray{currentiter}=qxy;
end
outname=sprintf('results/%s_qxy.mat',jobname);
save(outname, 'resarray');

for currentiter=1:iterations
    inname=sprintf('results/%s_%d.mat',jobname, currentiter);
    load(inname);
    resarray{currentiter}=qxz;
end
outname=sprintf('results/%s_qxz.mat',jobname);
save(outname, 'resarray');
for currentiter=1:iterations
    inname=sprintf('results/%s_%d.mat',jobname, currentiter);
    load(inname);
    resarray{currentiter}=qyy;
end
outname=sprintf('results/%s_qyy.mat',jobname);
save(outname, 'resarray');

for currentiter=1:iterations
    inname=sprintf('results/%s_%d.mat',jobname, currentiter);
    load(inname);
    resarray{currentiter}=qyz;
end
outname=sprintf('results/%s_qyz.mat',jobname);
save(outname, 'resarray');

for currentiter=1:iterations
    inname=sprintf('results/%s_%d.mat',jobname, currentiter);
    load(inname);
    resarray{currentiter}=qzz;
end
outname=sprintf('results/%s_qzz.mat',jobname);
save(outname, 'resarray');

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
for currentiter=1:iterations
    inname=sprintf('results/%s_%d.mat',jobname, currentiter);
    load(inname);
    resarray{currentiter}=uxx;
end
outname=sprintf('results/%s_uxx.mat',jobname);
save(outname, 'resarray');


for currentiter=1:iterations
    inname=sprintf('results/%s_%d.mat',jobname, currentiter);
    load(inname);
    resarray{currentiter}=uxy;
end
outname=sprintf('results/%s_uxy.mat',jobname);
save(outname, 'resarray');

for currentiter=1:iterations
    inname=sprintf('results/%s_%d.mat',jobname, currentiter);
    load(inname);
    resarray{currentiter}=uxz;
end
outname=sprintf('results/%s_uxz.mat',jobname);
save(outname, 'resarray');
for currentiter=1:iterations
    inname=sprintf('results/%s_%d.mat',jobname, currentiter);
    load(inname);
    resarray{currentiter}=uyy;
end
outname=sprintf('results/%s_uyy.mat',jobname);
save(outname, 'resarray');

for currentiter=1:iterations
    inname=sprintf('results/%s_%d.mat',jobname, currentiter);
    load(inname);
    resarray{currentiter}=uyz;
end
outname=sprintf('results/%s_uyz.mat',jobname);
save(outname, 'resarray');

for currentiter=1:iterations
    inname=sprintf('results/%s_%d.mat',jobname, currentiter);
    load(inname);
    resarray{currentiter}=uzz;
end
outname=sprintf('results/%s_uzz.mat',jobname);
save(outname, 'resarray');

//////////////////////////////////////////////////////////////////////////////////////////////
for currentiter=1:iterations
    inname=sprintf('results/%s_%d.mat',jobname, currentiter);
    load(inname);
    resarray{currentiter}=cux;
end
outname=sprintf('results/%s_cux.mat',jobname);
save(outname, 'resarray');


for currentiter=1:iterations
    inname=sprintf('results/%s_%d.mat',jobname, currentiter);
    load(inname);
    resarray{currentiter}=cuy;
end
outname=sprintf('results/%s_cuy.mat',jobname);
save(outname, 'resarray');

for currentiter=1:iterations
    inname=sprintf('results/%s_%d.mat',jobname, currentiter);
    load(inname);
    resarray{currentiter}=cuz;
end
outname=sprintf('results/%s_cuz.mat',jobname);
save(outname, 'resarray');

for currentiter=1:iterations
    inname=sprintf('results/%s_%d.mat',jobname, currentiter);
    load(inname);
    resarray{currentiter}=alp;
end
outname=sprintf('results/%s_alp.mat',jobname);
save(outname, 'resarray');











