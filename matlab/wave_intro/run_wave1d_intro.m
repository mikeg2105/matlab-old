wavetype=0; %stationary
nsteps=20;
maxamplitude=10;
wavenumber=1*2*pi;
wavefreq=5;
delta=0.01;
nmax=100;

%Wave packet
npackets=5;
pwavfreq=2;
pwavnum=7;
x=1:1:nmax;


clf;
for i=1:nsteps
  y=wave1d(i, wavetype, maxamplitude, wavenumber, wavefreq, delta,nmax);
  plot(x, y);
  pause(1);
end
