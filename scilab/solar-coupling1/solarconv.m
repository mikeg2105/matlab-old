#perturbed MHD equations for convective zone
N=100;  #order
k=2.62/1000000.0;
rsun=696000000.0;  #m
c2=1;
mu=4*pi/10000000.0;
b=9000000/(10000); #tesla 1gauss=1-^-4T
g=274.0; #m/s^2
V=50;  #m/s characteristic velocity  http:#adsabs.harvard.edu/full/1962ApJ...135..474L
omegav=2.0*pi*2.5/1000;  #2.5mHz
omegad=omegav-(k*V);  #doppler shifted frequency
czero=6000.76;  #m/s isothermal atmosphere at temperature minimum

#data from http:#www.sns.ias.edu/~jnb/SNdata/Export/BS2005/bs05_agsop.dat
rho0=2/1000; #kg/m^3 density of photosphere
pp=86.82; #N/m^2
p0=6.661*100000000;  #N/m^2
dp0dz=(0.77*100000000)/(0.001*rsun);
drho0dz=(0.553)/(10.0*0.001*rsun);
gammac=5/3;
gammap=5/3;
csdashsq=(dp0dz*gammap/rho0)-(drho0dz*gammap*p0/(rho0^2));
m=((gammap*g)/(csdashsq))-1;
z0=(czero^2)/(csdashsq);
a=((m+1)/gammap)*(omegad^2/(2*g*k));
beta=gammac*(2*mu*pp-b*b)/(2*b*b);
csp=sqrt(gammap*pp/rho0);

x=1:200;
for l=1:200
  for lv=1:200
   V=10*(lv-100)/100;
#delta(i)=solmhdconv1(z(i),k,z0,a,m,c2,N);
om2(l,lv)=momega(gammap,gammac,csp,l,beta,V,b,pp,g);
  endfor
endfor



