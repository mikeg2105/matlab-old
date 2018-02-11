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
lensol=2556*10^3; //length of effective solenoid
                  //used in computation of final field
zt=lensol/2;
zb=-zt;
                 


//magnetic field strongest at earths surface i z direction
//north and south magnetic poles
bz=0.6*(10^(-4));

//effective radius of solenoid
//1/3 radius of earths outer core
//http://en.wikipedia.org/wiki/Earth#Composition_and_structure
zsol=5100*10^3;  //radius of earth - len solenoid
reffsol=1278*(10^3)/3;

itot=(((zsol^2+reffsol^2)^(1.5))*bz*4*%pi)/(mu0*2*%pi*(reffsol^2));

nturns=100;
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
 
nr=5;  
nphi=20;  
ntheta=20;
deltar=1*10^3;
deltatheta=2*%pi/ntheta;
deltaphi=2*%pi/nphi;
phi=%pi/2;
b=zeros(3,5,ntheta);


//if running using the white rose grid easa application portal 
//we set the directory to ''
//and extract the data 
//directory='out/'
directory='out/'
dxdirectory='dx/'
jobname='mkgt1';
outfile=directory+'job'+jobname+'.out';
formfile=directory+'jobform'+jobname+'.out';
dxgenfile=directory+'job'+jobname+'.general';
dxformgenfile=directory+'job'+jobname+'_form.general';
fdform=mopen(formfile,'w');
  mfprintf(fdform, '%d %d %d\n',nr, ntheta, nphi);
mclose(fdform);
fd=mopen(outfile,'w');



for i1=1:nr
  for i2=1:ntheta
    for i3=1:nphi
      theta=i2*deltatheta;
      phi=i3*deltaphi;

      r0=rearth+(i1-1)*5000.0;
      r(1,1)=r0*cos(theta)*sin(phi);
      r(2,1)=r0*sin(theta)*sin(phi);
      r(3,1)=r0*cos(phi);
      bf=bfield(reffsol,zt,zb,nturns,iperturn,r,%pi/16);
      mfprintf(fd, '%f %f %f %f %f %f\n',r(1,1),r(2,1),r(3,1),10^10*bf(1,1),10^10*bf(2,1),10^10*bf(3,1));
      b(:,i1,i2)=bf;
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
  mfprintf(fdform, 'file=%s\n', 'out/job'+jobname+'.out');
  mfprintf(fdform,'points= %d \n',nr*ntheta*nphi);
  mfprintf(fdform,'format = ascii \n interleaving = record-vector \n header = lines 1 \n');
  //mfprintf(fdform, 'series =  1 , 1, 1, separator=lines 1\n');
  mfprintf(fdform, 'field = locations,field0 \n structure = 3-vector, 3-vector \n type = float, float  \n dependency = positions, positions  \n end \n ');
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

