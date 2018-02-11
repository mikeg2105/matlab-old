//Executed from scilab using format and system boxes 
//with the command:
//  /usr/bin/scilex -nw -nb -f run_wave2d_dx.sce



jobname='job1';

//Read input

wavetype=?wtype?; //travelling
nsteps=100;
maxamplitude=?wamp?;
wavenumber(1)=?wnum1?;
wavenumber(2)=?wnum2?;
wavefreq=?wfreq?;
delta(1)=0.01;
delta(2)=0.01;
nmax(1)=100;
nmax(2)=100;
deltat=0.05;
tstep=1;


//Wave packet
npackets=5;
pwavfreq=2;
pwavnum=7;
chdir( jobname);
exec("wave2d.sce");


outfile=jobname+'.out';
formfile=jobname+'.form';



//clf;
x=1:1:nmax(1);
y=1:1:nmax(2);

fdform=mopen(formfile,'w');
  mfprintf(fdform, '%d %d %d\n',nsteps, nmax(1), nmax(2));
mclose(fdform);

fd=mopen(outfile,'w');

for i=tstep:tstep+nsteps
z=wave2d(i*deltat, wavetype, maxamplitude, wavenumber, wavefreq, delta,nmax);
 
//Write data to output

 mfprintf(fd, '%d %d %d\n',i, nmax(1), nmax(2));
 for j1=1:nmax(1)
  for j2=1:nmax(2)
      mfprintf(fd, '%f',z(j1,j2));
  end
  mfprintf(fd, '\n');
 end

end //end of cycling over steps
mclose(fd);
exit;

