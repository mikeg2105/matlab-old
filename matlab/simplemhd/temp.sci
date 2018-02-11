
// Display mode
mode(0);

// Display warning for floating point exception
ieee(1);

//Steven McHale
//Tsunami Model
//Shallow-Water Wave Equation
//Crank-Nicholson Discretization

clear;
//clf;
clc;

// Constants
g = 9.81;
u0 = 0;
v0 = 0;
b = 0;
h0 = 5030;

// Define the x domain
ni = 51;
xmax = 100000;
dx = xmax/(ni-1);
x = 0:dx:xmax;

// Define the y domain
nj = 51;
ymax = 100000;
dy = ymax/(nj-1);
y = 0:dy:ymax;

// Define the wavespeed
wavespeed = u0+sqrt(g*(h0-b));

// Define time-domain
dt = (0.68*dx)/wavespeed;
tmax=150;
t = 1:dt:tmax;

//if running using the white rose grid easa application portal 
//we set the directory to ''
//and extract the data 
//directory='out/'
directory='out/'
jobname='t1';
outfile=directory+'job'+jobname+'.out';
formfile=directory+'jobform'+jobname+'.out';
dxgenfile=directory+'job'+jobname+'.general';
dxformgenfile=directory+'jobform'+jobname+'.general';
fdform=mopen(formfile,'w');
  mfprintf(fdform, '%d %d %d\n',max(size(t))-1, ni, nj);
mclose(fdform);
fd=mopen(outfile,'w');


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
dxgenfile=directory+'job'+jobname+'.general';

fdform=mopen(dxgenfile,'w');
  mfprintf(fdform, 'file=%s\n', 'out/job'+jobname+'.out');
  mfprintf(fdform,'grid %d X %d\n',ni,nj);
  mfprintf(fdform,'format = ascii \n interleaving = field \n majority = row \n header = lines 1 \n');
  mfprintf(fdform, 'series =  %d  , 1, 1, separator=lines 1\n',max(size(t))-1);
  mfprintf(fdform, 'field = field0, field1 \n structure = 2-vector, scalar \n type = float, float  \n dependency = positions, positions  \n positions = regular,regular, 0, 1,0,1 \n end \n ');
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

dxformgenfile=directory+'jobform'+jobname+'.general';
fdform=mopen(dxformgenfile,'w');
  mfprintf(fdform, 'file=%s\n', 'out/jobform'+jobname+'.out');
  mfprintf(fdform,'grid=1\n');
  mfprintf(fdform,'format = ascii \n interleaving = record \n majority = row \n');
  mfprintf(fdform, 'field = nsteps, ,nx, ny \n structure = scalar, scalar, scalar \n type = int, int, int  \n dependency = positions, positions,positions  \n positions = regular, 0, 1 \n end \n ');
mclose(fdform);  
