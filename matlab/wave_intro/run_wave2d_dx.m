%Executed from scilab using format and system boxes 
%with the command:
%  /usr/bin/scilex -nw -nb -f run_wave2d_dx.sce

wavetype=1; %stationary
nsteps=5;
maxamplitude=10;
wavenumber(1)=1*2*pi;
wavenumber(2)=2*2*pi;
wavefreq=5;
delta(1)=0.01;
delta(2)=0.01;
nmax(1)=100;
nmax(2)=100;
tstep=1;
%exec("wave2d.sce");
infile='wave2ddx_1.in';
outfile='wave2ddx_1.out';

%wavetype=0;
%nsteps=0;
%wavenumber=zeros(2);
%delta=zeros(2);
%nmax=zeros(2);

%Read input
input=load(infile);
%fd=fopen(infile,'rt');
wavetype=input(1);
nsteps=input(2);
maxamplitude=input(3);
wavenumber(1)=input(4);
wavenumber(2)=input(5);
wavefreq=input(6);
delta(1)=input(7);
delta(2)=input(8);
nmax(1)=input(9);
nmax(2)=input(10);
deltat=input(11);
tstep=input(12);
%fclose(fd);

%Wave packet
npackets=5;
pwavfreq=2;
pwavnum=7;

%clf;
x=1:1:nmax(1);
y=1:1:nmax(2);

fd=fopen(outfile,'w');

for i=tstep:tstep+nsteps
z=wave2d(i*deltat, wavetype, maxamplitude, wavenumber, wavefreq, delta,nmax);
 
%Write data to output

 fprintf(fd, '%d\n',i);
 for j1=1:nmax(1)
  for j2=1:nmax(2)
      fprintf(fd, '%f',z(j1,j2));
  end
  fprintf(fd, '\n');
 end

end %end of cycling over steps
fclose(fd);
exit;

