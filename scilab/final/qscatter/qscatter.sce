//qscatter
exec('v.sce');
exec('f.sce');
exec('u.sce');
exec('tdl.sce');
exec('sigma.sce');
exec('numerov.sce');


//partial wave analysis of scattering

deltah=0.01;
nsteps=200;
global m
global hb
m=938*10^9;
hb=6.59*10^(-13);

//2m/hb^2=6.12meV^-1(sigma)^-2

sig=zeros(nsteps);

for i=1:nsteps
 e=i*0.05; 
 k=sqrt(2*m*e)/hb;
 sig(i)=sigma(k,e);
end
