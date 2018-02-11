jobname='tbg2';
niters=4;
resarray=cell(1,niters);


nx=6;
ny=6;
nz=6;
%Load aeach data set in turn create cell array
%Do animation
for currentiter=1:niters
    outname=sprintf('results/%s_%d.mat',jobname, currentiter);
    load(outname);
end

