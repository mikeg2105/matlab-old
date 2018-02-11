clear;
jobname='tbg1';
niters=99;
nx=80;
ny=80;
nz=80;
%read each filei turn
%produce separate filecontaining timeslices foreach variable

resarray=cell(1,niters);
%Load aeach data set in turn create cell array
%Do animation
for currentiter=1:niters
    inname=sprintf('results/%s_%d.mat',jobname, currentiter);
    load(inname);
    resarray{currentiter}=gxx;
end
outname=sprintf('results/%s_gxx.mat',jobname);
save(outname, 'resarray');


for currentiter=1:niters
    inname=sprintf('results/%s_%d.mat',jobname, currentiter);
    load(inname);
    resarray{currentiter}=gxy;
end
outname=sprintf('results/%s_gxy.mat',jobname);
save(outname, 'resarray');

for currentiter=1:niters
    inname=sprintf('results/%s_%d.mat',jobname, currentiter);
    load(inname);
    resarray{currentiter}=gxz;
end
outname=sprintf('results/%s_gxz.mat',jobname);
save(outname, 'resarray');
for currentiter=1:niters
    inname=sprintf('results/%s_%d.mat',jobname, currentiter);
    load(inname);
    resarray{currentiter}=gyy;
end
outname=sprintf('results/%s_gyy.mat',jobname);
save(outname, 'resarray');

for currentiter=1:niters
    inname=sprintf('results/%s_%d.mat',jobname, currentiter);
    load(inname);
    resarray{currentiter}=gyz;
end
outname=sprintf('results/%s_gyz.mat',jobname);
save(outname, 'resarray');

for currentiter=1:niters
    inname=sprintf('results/%s_%d.mat',jobname, currentiter);
    load(inname);
    resarray{currentiter}=gzz;
end
outname=sprintf('results/%s_gzz.mat',jobname);
save(outname, 'resarray');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for currentiter=1:niters
    inname=sprintf('results/%s_%d.mat',jobname, currentiter);
    load(inname);
    resarray{currentiter}=qxx;
end
outname=sprintf('results/%s_qxx.mat',jobname);
save(outname, 'resarray');


for currentiter=1:niters
    inname=sprintf('results/%s_%d.mat',jobname, currentiter);
    load(inname);
    resarray{currentiter}=qxy;
end
outname=sprintf('results/%s_qxy.mat',jobname);
save(outname, 'resarray');

for currentiter=1:niters
    inname=sprintf('results/%s_%d.mat',jobname, currentiter);
    load(inname);
    resarray{currentiter}=qxz;
end
outname=sprintf('results/%s_qxz.mat',jobname);
save(outname, 'resarray');
for currentiter=1:niters
    inname=sprintf('results/%s_%d.mat',jobname, currentiter);
    load(inname);
    resarray{currentiter}=qyy;
end
outname=sprintf('results/%s_qyy.mat',jobname);
save(outname, 'resarray');

for currentiter=1:niters
    inname=sprintf('results/%s_%d.mat',jobname, currentiter);
    load(inname);
    resarray{currentiter}=qyz;
end
outname=sprintf('results/%s_qyz.mat',jobname);
save(outname, 'resarray');

for currentiter=1:niters
    inname=sprintf('results/%s_%d.mat',jobname, currentiter);
    load(inname);
    resarray{currentiter}=qzz;
end
outname=sprintf('results/%s_qzz.mat',jobname);
save(outname, 'resarray');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for currentiter=1:niters
    inname=sprintf('results/%s_%d.mat',jobname, currentiter);
    load(inname);
    resarray{currentiter}=uxx;
end
outname=sprintf('results/%s_uxx.mat',jobname);
save(outname, 'resarray');


for currentiter=1:niters
    inname=sprintf('results/%s_%d.mat',jobname, currentiter);
    load(inname);
    resarray{currentiter}=uxy;
end
outname=sprintf('results/%s_uxy.mat',jobname);
save(outname, 'resarray');

for currentiter=1:niters
    inname=sprintf('results/%s_%d.mat',jobname, currentiter);
    load(inname);
    resarray{currentiter}=uxz;
end
outname=sprintf('results/%s_uxz.mat',jobname);
save(outname, 'resarray');
for currentiter=1:niters
    inname=sprintf('results/%s_%d.mat',jobname, currentiter);
    load(inname);
    resarray{currentiter}=uyy;
end
outname=sprintf('results/%s_uyy.mat',jobname);
save(outname, 'resarray');

for currentiter=1:niters
    inname=sprintf('results/%s_%d.mat',jobname, currentiter);
    load(inname);
    resarray{currentiter}=uyz;
end
outname=sprintf('results/%s_uyz.mat',jobname);
save(outname, 'resarray');

for currentiter=1:niters
    inname=sprintf('results/%s_%d.mat',jobname, currentiter);
    load(inname);
    resarray{currentiter}=uzz;
end
outname=sprintf('results/%s_uzz.mat',jobname);
save(outname, 'resarray');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for currentiter=1:niters
    inname=sprintf('results/%s_%d.mat',jobname, currentiter);
    load(inname);
    resarray{currentiter}=cux;
end
outname=sprintf('results/%s_cux.mat',jobname);
save(outname, 'resarray');


for currentiter=1:niters
    inname=sprintf('results/%s_%d.mat',jobname, currentiter);
    load(inname);
    resarray{currentiter}=cuy;
end
outname=sprintf('results/%s_cuy.mat',jobname);
save(outname, 'resarray');

for currentiter=1:niters
    inname=sprintf('results/%s_%d.mat',jobname, currentiter);
    load(inname);
    resarray{currentiter}=cuz;
end
outname=sprintf('results/%s_cuz.mat',jobname);
save(outname, 'resarray');

for currentiter=1:niters
    inname=sprintf('results/%s_%d.mat',jobname, currentiter);
    load(inname);
    resarray{currentiter}=alp;
end
outname=sprintf('results/%s_alp.mat',jobname);
save(outname, 'resarray');











