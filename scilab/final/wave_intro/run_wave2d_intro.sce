exec('wave2d.sce');

wavetype=1; //stationary
nsteps=5;
maxamplitude=10;
wavenumber(1)=1*2*%pi;
wavenumber(2)=2*2*%pi;
wavefreq=5;
delta(1)=0.01;
delta(2)=0.01;
nmax(1)=100;
nmax(2)=100;

//Wave packet
npackets=5;
pwavfreq=2;
pwavnum=7;

//clf;
x=1:1:nmax(1);
y=1:1:nmax(2);
z=zeros(nmax(1),nmax(2));
curFig             = scf(100001);
clf(curFig,"reset");

drawlater();

xselect(); //raise the graphic window


// set a new colormap
//-------------------
cmap= curFig.color_map; //preserve old setting
curFig.color_map = jetcolormap(64);
plot3d1(x,y,z,35,45,' ');
s=gce(); //the handle on the surface
s.color_flag=1 ; //assign facet color according to Z value
title("evolution of a 3d surface","fontsize",3)
//plot3d1(x,y,zeros(nmax(1),nmax(2)));
for i=1:nsteps
realtimeinit(0.1);;//set time step (0.1 seconds)  and date reference


drawnow();
  //clf;
  //realtime(i);
  s.data.z=wave2d(i, wavetype, maxamplitude, wavenumber, wavefreq, delta,nmax);
  //plot3d1(x, y, z, 80, 88, 'X@Y@Z', [-1 1 1]);
 // plot3d1(x, y, z);
 // xset('wshow');
 // xset('wwpc');
  //xset("Z", wave2d(i, wavetype, maxamplitude, wavenumber, wavefreq, delta,nmax));
  //plot2d(x, wavepacket1d(i, wavetype, maxamplitude, wavenumber, wavefreq,pwavnum, pwavfreq, npackets, delta,nmax));
  //xpause(1000000);
  


end
