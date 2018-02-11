//qscatter
exec('v.sce');
exec('f.sce');
exec('u.sce');
exec('tdl.sce');
exec('sigma.sce');
exec('numerov.sce');

jobname='wjob';
env=getenv('SGE_TASK_ID');
//env='1';
sgetid=sscanf(env,'%d');

outfile='job'+env+'.out';
matfile='results'+env+'.mat'


//partial wave analysis of scattering

deltah=0.01;
nsteps=200;
global m
global hb
//m=938*10^9;
m=1.672*10^(-27);
//hb=6.59*10^(-13);
hb=1.054*10^(-34);
lupper=10
e=1.6*10^(-19);
 
 delta=0.1*(10^(-10));
 
 delta=0.5;
 m=1;
 hb=1;
 e=1;

//2m/hb^2=6.12meV^-1(sigma)^-2
  lupper=10;
  sumdelta=0;
  nr=100;
  ne=250;
  
  sumouter=zeros(ne);
  totsum=0;
  //sigma=0;
  
  u1=zeros(nr,lupper+1);
  u2=zeros(nr,lupper+1);
  u3=zeros(nr,lupper+1);
  //outer loop integration over r
    epsilon=sgetid+2.9;//meV H-Kr interaction
  sigma=3.57;//Angstrom
  //sigma=sgetid+2.57;//Angstrom
  for nec=1:ne
    e=nec*0.0005;
    k=sqrt(2*m*e)/hb;
    totsum=0;
  //sigma=0;
  
  u1=zeros(nr,lupper+1);
  u2=zeros(nr,lupper+1);
  u3=zeros(nr,lupper+1);
  for j=1:nr,
    
    u1=0;
    //inner loop summation over l
    sumdelta=0;
    for i=0:lupper,   
      if j == 1 then
        u1(j,i+1)=.1;
        u2(j,i+1)=delta^(i+1);
      else
        u2(j,i+1)=u3(j-1,i+1);
        u1(j,i+1)=u2(j-1,i+1);
      end;
      
      u3(j,i+1)=numerov(u1(j,i+1),u2(j,i+1),i,(sigma-0.4)+j*delta,delta,e,sigma,epsilon);
      //res=tdl(u1(j,i+1),u2(j,i+1),j*delta,(j+1)*delta,i,k);
      //cosecdelta2=((1/(res^2))+1);
      //sumdelta=sumdelta+(2*i+1)*(1/cosecdelta2); 
    end
    //sumouter(j)=((4*%pi)/(k^2))*sumdelta;
    //totsum=totsum+sumouter(j);
  end
  
 
     for i=0:lupper,   
 
      
       res=tdl(u2(nr-2,i+1),u2(nr-1,i+1),(nr-1)*delta,(nr)*delta,i,k);
      cosecdelta2=((1/(res^2))+1);
      sumdelta=sumdelta+(2*i+1)*(1/cosecdelta2); 
    end
    sumouter(nec)=((4*%pi)/(k^2))*sumdelta;
    totsum=totsum+sumouter(nec);
    
  end
  
  //plot(sumouter);
  //Write data to output
 
  fd=mopen(outfile,'w');
  for nec=1:ne
      mfprintf(fd, '%f %f\n',nec*0.0005, sumouter(nec));
  end
  mfprintf(fd, '\n');
 


savematfile(matfile,'sumouter');
mclose(fd);
exit;
