//script to generate magnetic field data for Earths magnetic field
//modelled on a single loop solenoid at the core of the earth 


exec('lorentz.sce');
exec('bfield.sce');
exec('bfieldsimpson.sce');


rearth=6378.0*(10^3);




//permeability of free space
mu0=4.0*%pi*(10^(-7));

b=zeros(3,1);

//bfield in z direction
b(3,1)=0.1;
ns=200;


//calculate effective current for earths bfield
//lensol=2556*10^3; //length of effective solenoid
                  //used in computation of final field
lensol=1;                 
zt=lensol/2;
zb=-zt;
                 

//http://hyperphysics.phy-astr.gsu.edu/hbase/magnetic/magearth.html#c1
//magnetic field strongest at earths surface i z direction
//north and south magnetic poles
bz=0.6*(10^(-4));

//effective radius of solenoid
//1/3 radius of earths outer core
//http://en.wikipedia.org/wiki/Earth#Composition_and_structure

//solenoid field calculation
//http://www.netdenizen.com/emagnet/solenoids/thinsolenoid.htm

//zsol=5100*10^3;  //radius of earth - len solenoid
//reffsol=1278*(10^3)/3;
zsol=rearth-lensol;
//reffsol=10*4000*(10^3)/3;
reffsol=4000*(10^3);
nturns=1;

itot=1.5*10^9;





ar=zeros(ns,3);
 
//nx=42;  
//ny=42  
//nz=42;

nx=22;  
ny=22;  
nz=22;

deltax=6371*10^3;
deltay=deltax;
deltaz=deltax;
inx=-deltax*nx/2;
iny=inx;
inz=iny;

b=zeros(3,nx,ny,nz);
//deltab=%pi/2048;
deltab=%pi/256;

//if running using the white rose grid easa application portal 
//we set the directory to ''
//and extract the data 
//directory='out/'
//directory='out/'
//dxdirectory='dx/'
directory='';
dxdirectory='';
jobname='plotbfieldtest';
outfile=directory+'job'+jobname+'.out';
formfile=directory+'jobform'+jobname+'.out';
dxgenfile=directory+'job'+jobname+'.general';
dxformgenfile=directory+'job'+jobname+'_form.general';
fdform=mopen(formfile,'w');
  mfprintf(fdform, '%d %d %d\n',nx, ny, nz);
mclose(fdform);
fd=mopen(outfile,'w');




mfprintf(fd,'Earth bfield model\n');
mfprintf(fd,'jobname %s\n',jobname);
mfprintf(fd,'size %d %d %d \n',nx,ny,nz);
mfprintf(fd,'Height effective solenoid(m) %f\n',zsol);
mfprintf(fd,'Radius effective solenoid(m) %f\n',reffsol);
mfprintf(fd,'deltab %f\n',deltab);
mfprintf(fd,'n turns %d\n',nturns);

for i1=1:nx
  disp(i1);
  for i2=1:ny
    for i3=1:nz
      x=inx+i1*deltax;
      y=iny+i2*deltay;
      z=inz+i3*deltaz;
 
      r(1,1)=x;
      r(2,1)=y;
      r(3,1)=z;
      bf=bfieldsimpson(reffsol,zt,zb,nturns,itot,r,deltab);

      mfprintf(fd, '%f %f %f %f %f %f\n',r(1,1)/rearth,r(2,1)/rearth,r(3,1)/rearth,10^6*bf(1,1),10^6*bf(2,1),10^6*bf(3,1));
      b(:,i1,i2,i3)=bf;
    end
  end
end
mclose(fd);

//generate dx general file for this data set
//file=out/job.out
//grid 51 x 51
//format = ascii
//interleaving = field
//majority = row
//header = lines 1

//series =  24 , 1, 1, separator=lines 1
//field = field0, field1
//structure = 2-vector, scalar
//type = float, float
//dependency = positions, positions
//positions = regular,regular, 0, 1,0,1

//end
dxgenfile=dxdirectory+'job'+jobname+'.general';

fdform=mopen(dxgenfile,'w');
  //mfprintf(fdform, 'file=%s\n', 'out/job'+jobname+'.out');
  mfprintf(fdform, 'file=%s\n', 'job'+jobname+'.out');
  mfprintf(fdform,'grid= %d x %d x %d\n',nx,ny,nz);
  mfprintf(fdform,'format = ascii \n interleaving = field \n header = lines 7 \n');
  //mfprintf(fdform, 'series =  1 , 1, 1, separator=lines 1\n');
  mfprintf(fdform, 'field = locations,bfield \n structure = 3-vector, 3-vector \n type = float, float  \n dependency = positions, positions  \n end \n ');
mclose(fdform);


//file=out/jobform.out
//grid = 1
//format = ascii
//interleaving = record
//majority = row
//field = nsteps, nx, ny
//structure = scalar, scalar, scalar
//type = int, int, int
//dependency = positions, positions, positions
//positions = regular, 0, 1

//end

dxformgenfile=dxdirectory+'job'+jobname+'_form.general';
fdform=mopen(dxformgenfile,'w');
  //mfprintf(fdform, 'file=%s\n', 'out/jobform'+jobname+'.out');
  mfprintf(fdform, 'file=%s\n', 'jobform'+jobname+'.out');
  mfprintf(fdform,'grid=1\n');
  mfprintf(fdform,'format = ascii \n interleaving = record \n majority = row \n');
  mfprintf(fdform, 'field = nr ,ntheta, nphi \n structure = scalar, scalar, scalar \n type = int, int, int  \n dependency = positions, positions,positions  \n positions = regular, 0, 1 \n end \n ');
mclose(fdform);  

//exit;

