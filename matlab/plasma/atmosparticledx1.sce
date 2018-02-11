//script to generate magnetic field data for Earths magnetic field
//modelled on a single loop solenoid at the core of the earth 


exec('lorentz.sce');
exec('bfield.sce');
exec('bfieldtrapezium.sce');
exec('bfieldsimpson.sce');
exec('maxwell.sce');

imethod=3;// 1=rectangular,2=trapezium,3=simpson
rearth=6378.0*(10^3);
nparts=100;
mpart=1.6*(10^(-27));
temp=700;
kb=1.38*10^(-23);
q=1.6*10^(-19);
m=mpart;


vm=sqrt(3*temp*kb/mpart);

for i=1:nparts
  partheight=100*(10^3)+50*rand();
  parttheta=0+2*%pi*rand()/90;
  partphi=%pi*5/180;

  rp(i,1)=(partheight+rearth)*cos(parttheta)*sin(partphi);
  rp(i,2)=(partheight+rearth)*sin(parttheta)*sin(partphi);
  rp(i,3)=(partheight+rearth)*cos(partphi);
  
  vp(i,2)=1.0*(10^6); 
  randres=rand()/100;
  md=maxwell(mpart,temp,vm+randres)
  
  while randres<md
    randres=rand()/100;
    md=maxwell(mpart,temp,vm+randres);
    //maxwell distribution
  end

  vp(i,1)=(vm+randres)*cos(parttheta)*sin(partphi);
  vp(i,2)=(vm+randres)*sin(parttheta)*sin(partphi);
  vp(i,3)=(vm+randres)*cos(partphi);
    
  //end
  
end



//v(1,1)=1.0*(10^6);
v(2,1)=1.0*(10^6);


//permeability of free space
mu0=4.0*%pi*(10^(-7));

b=zeros(3,1);
e=zeros(3,1);

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
reffsol=4000*(10^3)/3;
nturns=1;

rfactor=((lensol+zsol)/((lensol+zsol)^2 + reffsol^2))-(zsol/(zsol^2+reffsol^2));
itot=2*lensol*bz*2/(mu0*nturns*rfactor);
itot=1.5*10^9;

iperturn=itot/(2*%pi*reffsol*nturns);// used in the computation of the bfield with
                               //the biot savart law




ar=zeros(ns,3);
 
nx=42;  
ny=42  
nz=42;
deltax=2*6371*10^3;
deltay=deltax;
deltaz=deltax;
inx=-deltax*nx/2;
iny=inx;
inz=iny;
dt=1;

b=zeros(3,1);


//if running using the white rose grid easa application portal 
//we set the directory to ''
//and extract the data 
//directory='out/'
directory='out/'
dxdirectory='dx/'
jobname='mkgapt1simpson';
outfile=directory+'job'+jobname+'.out';
formfile=directory+'jobform'+jobname+'.out';
dxgenfile=directory+'job'+jobname+'.general';
dxformgenfile=directory+'job'+jobname+'_form.general';
fdform=mopen(formfile,'w');
  mfprintf(fdform, '%d %d %d\n',nx, ny, nz);
mclose(fdform);
fd=mopen(outfile,'w');

deltab=%pi/1024;

mfprintf(fd,'Earth bfield model\n');
mfprintf(fd,'jobname %s\n',jobname);
mfprintf(fd,'size %d %d %d \n',nx,ny,nz);
mfprintf(fd,'Height effective solenoid(m) %f\n',zsol);
mfprintf(fd,'Radius effective solenoid(m) %f\n',reffsol);
mfprintf(fd,'deltab %f\n',deltab);
mfprintf(fd,'n turns %d\n',nturns);


 










for it=1:1:ns

 for i=1:nparts
    r=rp(i,:)';
    v=vp(i,:)';
     //  r(1,1)=x;
     // r(2,1)=y;
     // r(3,1)=z;
      if imethod==1 then
      	bf=bfield(reffsol,zt,zb,nturns,itot,r,deltab);
      elseif imethod==2 then
      	bf=bfieldtrapezium(reffsol,zt,zb,nturns,itot,r,deltab);
      elseif imethod==3 then
      	bf=bfieldsimpson(reffsol,zt,zb,nturns,itot,r,deltab);
      end
      //mfprintf(fd, '%f %f %f %f %f %f\n',r(1,1)/rearth,r(2,1)/rearth,r(3,1)/rearth,10^6*bf(1,1),10^6*bf(2,1),10^6*bf(3,1));
      //b(:,i1,i2,i3)=bf;

 
 
      dv=lorentzf(q,m,v,e,b);
      newv=v+dv*dt;
      newr=r+v*dt;
      
      
      //ar(:,1)=r(1:3,1);
      //ar(:,2)=newr(1:3,1);
      //a.user_data=ar;
      v=newv;
      r=newr;

      //realtime(it)
      //xset('wwpc');
      
      //plot2d(r(1),r(2));
      
      ar(it,:)=r(1:3,1)';
      mfprintf(fd, '%f %f %f %f %f %f\n',r(1,1)/rearth,r(2,1)/rearth,r(3,1)/rearth,v(1,1),v(2,1),v(3,1));
      rp(i,:)=r';
      vp(i,:)=v';

      //xsegs(ar(1:2,1),ar(1:2,2));
      //param3d(ar(1,:),ar(2,:),ar(3,:),35,45,'X@Y@Z',[2,4]);
      //xset('wshow');
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
dxgenfile=dxdirectory+jobname+'.general';

fdform=mopen(dxgenfile,'w');
  mfprintf(fdform, 'file=%s\n', 'out/job'+jobname+'.out');
  mfprintf(fdform,'points= %d\n',nparts);
  mfprintf(fdform,'series= %d\n',ns);
  mfprintf(fdform,'format = ascii \n interleaving = field \n header = lines 7 \n');
  //mfprintf(fdform, 'series =  1 , 1, 1, separator=lines 1\n');
  mfprintf(fdform, 'field = locations,v \n structure = 3-vector, 3-vector \n type = float, float  \n dependency = positions, positions  \n end \n ');
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

dxformgenfile=dxdirectory+'jobparts'+jobname+'_form.general';
fdform=mopen(dxformgenfile,'w');
  mfprintf(fdform, 'file=%s\n', 'out/jobform'+jobname+'.out');
  mfprintf(fdform,'grid=1\n');
  mfprintf(fdform,'format = ascii \n interleaving = record \n majority = row \n');
  mfprintf(fdform, 'field = nr ,ntheta \n structure = scalar, scalar \n type = int, int \n dependency = positions, positions \n positions = regular, 0, 1 \n end \n ');
mclose(fdform);  

exit;

