wavetype=1; %stationary
nsteps=30;
maxamplitude=10;
wavenumber(1)=1*2*pi;
wavenumber(2)=1*2*pi;
wavefreq=5;

wavenumber2(1)=2.3*2*pi;
wavenumber2(2)=1.3*2*pi;
wavefreq2=5.4;

delta(1)=0.01;
delta(2)=0.01;
nmax(1)=100;
nmax(2)=100;

%Wave packet
npackets=5;
pwavfreq=2;
pwavnum=7;

x=1:1:nmax(1);
y=1:1:nmax(2);
ghandle=surf(x,y,zeros(nmax(1), nmax(2)));

%clf;
for i=1:nsteps

  %clf;
  drawnow;
  %realtime(i);
  %plot3d1(x, y, wave2d(i, wavetype, maxamplitude, wavenumber, wavefreq, delta,nmax),88,-34,'X&Y@Z', [-1 1 1]);
  set(ghandle, 'Z', wave2d(i, wavetype, maxamplitude, wavenumber, wavefreq, delta,nmax));
  pause(1);
  


end
