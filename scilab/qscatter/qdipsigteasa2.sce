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
nproc=8;

outfile='job'+env+'.out';
matfile='results'+env+'.mat'

//partial wave analysis of scattering

//varying angle for a small separation

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
    epsilon=5.9;//meV H-Kr interaction
  sigma=3.57;//Angstrom
  
  nsites=2;
  dipangle=%pi*25/180;
  dipangle=2*%pi*sgetid/nproc;
  
  dipsep=0.0001;
  sitesig=sigma*ones(nsites,1);
  siteepsi=epsilon*ones(nsites,1);
  
  
  
  for nec=1:ne
    e=nec*0.0005;
    k=sqrt(2*m*e)/hb;
    totsum=0;
  //sigma=0;
  
  u1=zeros(nr,lupper+1,2);
  u2=zeros(nr,lupper+1,2);
  u3=zeros(nr,lupper+1,2);
  for j=1:nr,
    
    u1=0;
    //inner loop summation over l
    rad=3.1+j*delta;
    sumdelta=0;
    for ik=1:2
       for il=0:lupper,   
        if j == 1 then
          u1(j,il+1,ik)=.1;
          u2(j,il+1,ik)=delta^(il+1);
        else
          u2(j,il+1,ik)=u3(j-1,il+1,ik);
          u1(j,il+1,ik)=u2(j-1,il+1,ik);
        end;
        
        if ik==1 then
          r=sqrt(rad^2+dipsep^2+2*rad*dipsep*cos(dipangle));
          epsilon=siteepsi(ik,1);//meV H-Kr interaction
          sigma=sitesig(ik,1);//Angstrom
        else
          r=sqrt(rad^2+dipsep^2-2*rad*dipsep*cos(dipangle));
          epsilon=siteepsi(ik,1);//meV H-Kr interaction
          sigma=sitesig(ik,1);//Angstrom
        end
        u3(j,il+1,ik)=numerov(u1(j,il+1,ik),u2(j,il+1,ik),il,r,delta,e,sigma,epsilon);
        //res=tdl(u1(j,i+1),u2(j,i+1),j*delta,(j+1)*delta,i,k);
        //cosecdelta2=((1/(res^2))+1);
        //sumdelta=sumdelta+(2*i+1)*(1/cosecdelta2); 
       end  //end summation over l, il
    end //end summation over spherical potentials
    //sumouter(j)=((4*%pi)/(k^2))*sumdelta;
    //totsum=totsum+sumouter(j);
  end  //end summation over j ... radial distance
  
 
     for i=0:lupper
      repart=0;
      impart=0;
      for ik=1:nsites
        res=tdl(u2(nr-2,i+1,ik),u2(nr-1,i+1,ik),(nr-1)*delta,(nr)*delta,i,k);
        deltal=atan(res);
        repart=repart+(cos(deltal)*sin(deltal));
        impart=impart+sin(deltal);
      end
      sumdelta=sumdelta+(2*i+1)*(repart^2+impart^2); 

    end
    sumouter(nec)=((4*%pi)/((nsites*k)^2))*sumdelta;
    
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
