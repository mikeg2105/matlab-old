//Script to model influence of uniform e and b field
//on charged particle motion


exec('lorentz.sce');
exec('bfield.sce');

m=1.6*(10^(-27));
q=1.6*(10^(-19));
dt=5.0*(10^(-9));
it=1:1:1000;
//plotid=evstr(x_dialog('plotid ?','1'));;
//text=x_dialog('Title?','current');
plotid=1;
text='current';
r=zeros(3,1);
v=zeros(3,1);


partheight=100*(10^3);
parttheta=0;
partphi=%pi*5/180;
rearth=6378.0*(10^3);

r(1,1)=(partheight+rearth)*cos(parttheta)*sin(partphi);
r(2,1)=(partheight+rearth)*sin(parttheta)*sin(partphi);
r(3,1)=(partheight+rearth)*cos(partphi);



//v(1,1)=1.0*(10^6);
v(2,1)=1.0*(10^6);

//i=()*bz*(4*pi);
//i=(z£2+r$^)



mu0=4.0*%pi*(10^(-7));

b=zeros(3,1);
e=zeros(3,1);

//bfield in z direction
b(3,1)=0.1;

//efield in y direction
//e(2,1)=0.2;
//e(3,1)=10*(10^4);
ns=200;


//calculate effective current for earths bfield
mu0=4.0*%pi*(10^(-7));
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
reffsol=4000*(10^3)/3;
nturns=1;

rfactor=((lensol+zsol)/((lensol+zsol)^2 + reffsol^2))-(zsol/(zsol^2+reffsol^2));
itot=2*lensol*bz*2/(mu0*nturns*rfactor);
itot=1.5*10^9;

iperturn=itot/(2*%pi*reffsol*nturns);// used in the computation of the bfield with
                               //the biot savart law



//v(2,1)=evstr(x_dialog('value of velocity ?','1.0*(10^6)'));
//x_dialog(['Method';'enter velocity'],'1')
//m=evstr(x_dialog('enter a  3x1 matrix ',['[0 ';'0 ';'0 ]']))

//labels=["b(1)";"b(2)";"b(3)    "];
//[ok,b(1,1),b(2,1),b(3,1)]=getvalue("define b field values",labels,...
//     list("vec",1,"vec",1,"vec",1),["0.0";"0.0";"0.1"]);





//xset('pixmap',1);

//xselect(); //raise graphic window
//np=10;
//t=0:0.1:np*%pi;
realtimeinit(0.03);
if driver()=='Pos' then
  st=1.5;
else
  st=0.5;
end
ar=zeros(ns,3);
 
nx=42;  
ny=42;  
nz=42;
deltax=6371*10^3;
deltay=deltax;
deltaz=deltax;
inx=-deltax*nx/2;
iny=inx;
inz=iny;

b=zeros(3,nx,nz);


//if running using the white rose grid easa application portal 
//we set the directory to ''
//and extract the data 
//directory='out/'
directory='out/'
dxdirectory='dx/'
jobname='mkgt16';
outfile=directory+'job'+jobname+'.out';
formfile=directory+'jobform'+jobname+'.out';
dxgenfile=directory+'job'+jobname+'.general';
dxformgenfile=directory+'job'+jobname+'_form.general';
fdform=mopen(formfile,'w');
  mfprintf(fdform, '%d %d %d\n',nx, ny, nz);
mclose(fdform);
fd=mopen(outfile,'w');

deltab=%pi/128;

mfprintf(fd,'Earth bfield model\n');
mfprintf(fd,'jobname %s\n',jobname);
mfprintf(fd,'size %d %d %d \n',nx,ny,nz);
mfprintf(fd,'Height effective solenoid(m) %f\n',zsol);
mfprintf(fd,'Radius effective solenoid(m) %f\n',reffsol);
mfprintf(fd,'deltab %f\n',deltab);
mfprintf(fd,'n turns %d\n',nturns);

for i1=1:nx
  //disp(i1);
  //for i2=1:ny
  
    for i3=1:nz
      y=inx+i1*deltax;
      //y=iny+i2*deltay;
      z=inz+i3*deltaz;
      x=0;
      r(1,1)=x;
      r(2,1)=y;
      r(3,1)=z;
      //bf=bfield(reffsol,zt,zb,nturns,itot,r,deltab);
      //bfield(r,ztp,zbot,n,i,rfp,dtheta)
      rs=reffsol;
      ztp=zt;
      zbot=zb;
      n=nturns;
      i=itot;
      rfp=r;
      dtheta=deltab;
      
        //n number of turns
  //i per turn
  bt=zeros(3,1);
  mu0=4.0*%pi*(10^(-7));
  dz=(ztp-zbot)/n;
  ce=zeros(3,1);
  
  //calculate field contribution for each turn
  z=zbot;
  //z=0;
  //dz=0;
  //dr=2*%pi/dtheta;
  dr=rs*dtheta;
  //for ic=0:n
    
    for theta=0:dtheta:(2*%pi)-dtheta
      //current element location
      xi=rs*cos(theta);
      yi=rs*sin(theta);
 
      rcp(1,1)=xi;
      rcp(2,1)=yi;
      rcp(3,1)=z;
     
      rp(1,1)=rfp(1,1)-rcp(1,1);
      rp(2,1)=rfp(2,1)-rcp(2,1);
      rp(3,1)=rfp(3,1)-rcp(3,1);


      rcpd(1,1)=rs*cos(theta+dtheta);
      rcpd(2,1)=rs*sin(theta+dtheta);
      rcpd(3,1)=z;  
      
      //current element vector
      //using tangent vector defn. from
      //http://mathworld.wolfram.com/TangentVector.html
      //and arc length ds=rdtheta
      //ce(1,1)=-sin(theta);
      //ce(2,1)=cos(theta);
      
      ce(1,1)=rcpd(1,1)-rcp(1,1);
      ce(2,1)=rcpd(2,1)-rcp(2,1);
      ce(3,1)=rcpd(3,1)-rcp(3,1);
      
      //evaluate cross product of current element and 
      //field vector
      cp(1,1)=ce(2,1)*rp(3,1)-ce(3,1)*rp(2,1);
      cp(2,1)=ce(3,1)*rp(1,1)-ce(1,1)*rp(3,1);
      cp(3,1)=ce(1,1)*rp(2,1)-ce(2,1)*rp(1,1);
      
      rsq=rp(1,1)*rp(1,1)+rp(2,1)*rp(2,1)+rp(3,1)*rp(3,1);
      
      bt(1,1)=bt(1,1)+mu0*i*dr*(cp(1,1))/(4*%pi*rsq);
      bt(2,1)=bt(2,1)+mu0*i*dr*(cp(2,1))/(4*%pi*rsq);
      bt(3,1)=bt(3,1)+mu0*i*dr*(cp(3,1))/(4*%pi*rsq);
        
    end
    z=z+dz;
//end


  
  
  
  bf=bt;
      
      
      mfprintf(fd, '%f %f %f %f %f %f\n',r(1,1)/rearth,r(2,1)/rearth,r(3,1)/rearth,bf(1,1),bf(2,1),bf(3,1));
      b(:,i1,i3)=bf;
    end
//  end
end
mclose(fd);
bmag=b(1,:,:).*b(1,:,:)+b(2,:,:).*b(2,:,:)+b(3,:,:).*b(3,:,:);
bmag=sqrt(bmag);

iax=1:nx;
iay=1:ny;

bnmag=zeros(nx,ny);
bnmag(:,:)=bmag(1,:,:);
bxm=zeros(nx,ny);
bym=zeros(nx,ny);

bxm(:,:)=b(1,:,:);
bym(:,:)=b(3,:,:);

contour2d(iax,iay,bnmag);
champ(iax,iay,bxm,bym);
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
  mfprintf(fdform, 'file=%s\n', 'out/job'+jobname+'.out');
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
  mfprintf(fdform, 'file=%s\n', 'out/jobform'+jobname+'.out');
  mfprintf(fdform,'grid=1\n');
  mfprintf(fdform,'format = ascii \n interleaving = record \n majority = row \n');
  mfprintf(fdform, 'field = nr ,ntheta, nphi \n structure = scalar, scalar, scalar \n type = int, int, int  \n dependency = positions, positions,positions  \n positions = regular, 0, 1 \n end \n ');
mclose(fdform);  

//exit;

