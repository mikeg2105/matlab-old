wavetype=0; //stationary
nsteps=20;
maxamplitude=15;
wavenumber=1*2*%pi;
wavefreq=12;
delta=0.01;
nmax=100;

//Wave packet
npackets=5;
pwavfreq=2;
pwavnum=7;

clf;
for i=1:nsteps
  x=1:1:nmax;
  clf;
  realtime(i);
  plot2d(x, wave1d(i, wavetype, maxamplitude, wavenumber, wavefreq, delta,nmax));
  
  //plot2d(x, wavepacket1d(i, wavetype, maxamplitude, wavenumber, wavefreq,pwavnum, pwavfreq, npackets, delta,nmax));
  xpause(1000000);
  


end
