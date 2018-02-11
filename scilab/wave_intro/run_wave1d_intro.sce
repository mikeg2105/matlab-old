wavetype=1; //stationary
nsteps=50;
maxamplitude=10;
wavenumber=1*2*%pi;
wavefreq=2;
delta=0.01;
deltat=0.05;
nmax=400;

//Wave packet
npackets=5;
pwavfreq=2;
pwavnum=7;
x=1:1:nmax;
clf;
for i=1:nsteps
  
  //clf;
  //realtime(i);
  y=wave1d(i*deltat, wavetype, maxamplitude, wavenumber, wavefreq, delta,nmax)+wave1d(i*deltat, wavetype, maxamplitude, 3*wavenumber, wavefreq, delta,nmax);
  plot2d(x, y);
  
  //plot2d(x, wavepacket1d(i, wavetype, maxamplitude, wavenumber, wavefreq,pwavnum, pwavfreq, npackets, delta,nmax));
  
  xset('wshow');
  xset('wwpc'); 
  
  //xpause(1000000);
  


end
