//Executed from scilab using format and system boxes 
//with the command:
//  /usr/bin/scilex -nw -nb -f run_wave2d_dx.sce

//wavetype=1; //stationary
//nsteps=5;
//maxamplitude=10;
//wavenumber(1)=1*2*%pi;
//wavenumber(2)=2*2*%pi;
//wavefreq=5;
//delta(1)=0.01;
//delta(2)=0.01;
//nmax(1)=100;
//nmax(2)=100;
//tstep=1;
exec("wave2d.sce");
infile='wave2ddx_1.in';
outfile='wave2ddx_1.out';

//Read input
fd=mopen(infile,'r');
wavetype=mfscanf(fd,'%d');
nsteps=mfscanf(fd,'%d');
maxamplitude=mfscanf(fd,'%f');
wavenumber(1)=mfscanf(fd,'%f');
wavenumber(2)=mfscanf(fd,'%f');
wavefreq=mfscanf(fd,'%f');
delta(1)=mfscanf(fd,'%f');
delta(2)=mfscanf(fd,'%f');
nmax(1)=mfscanf(fd,'%f');
nmax(2)=mfscanf(fd,'%f');
deltat=mfscanf(fd,'%f');
tstep=mfscanf(fd,'%d');
mclose(fd);

//Wave packet
npackets=5;
pwavfreq=2;
pwavnum=7;

//clf;
x=1:1:nmax(1);
y=1:1:nmax(2);

fd=mopen(outfile,'w');

for i=tstep:tstep+nsteps
z=wave2d(i*deltat, wavetype, maxamplitude, wavenumber, wavefreq, delta,nmax);
 
//Write data to output

 mfprintf(fd, '%d\n',i);
 for j1=1:nmax(1)
  for j2=1:nmax(2)
      mfprintf(fd, '%f',z(j1,j2));
  end
  mfprintf(fd, '\n');
 end

end //end of cycling over steps
mclose(fd);
exit;

