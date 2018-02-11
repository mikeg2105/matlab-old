chdir('/home/mike/proj/math/scilab/quant');

exec('/home/mike/proj/math/scilab/quant/psi.sce');disp('exec done');

phi=0:0.05:%pi;

theta=0:0.05:2*%pi;

npoints=126;
l=1;
m=0;


xval=xmat(npoints, theta, phi);

yval=ymat(npoints, theta, phi);

yres=ypol(npoints,theta,phi,l,m);
plot3d(xval, yval, yres);
