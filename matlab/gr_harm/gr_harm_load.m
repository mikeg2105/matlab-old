jobname='gr_harm_mat1_15';
niters=8;
resarray=cell(1,niters);
nx=40;
ny=40;
nz=40;
%Load aeach data set in turn create cell array
%Do animation
for currentiter=1:niters
    outname=sprintf('results/%s_%d.mat',jobname, currentiter);
    load(outname);
    resarray{currentiter}=gxy;
end

