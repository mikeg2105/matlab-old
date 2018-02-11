//qscatter
exec('v.sce');
exec('f.sce');
exec('u.sce');
exec('tdl.sce');
exec('sigma.sce');
exec('numerov.sce');


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
  nr=10;
  ne=50;
  ntheta=5;
  nphi=5;
  
  sumouter=zeros(ne);
  totsum=0;
  //sigma=0;
  
  deltatheta=2*%pi/ntheta;
  deltaphi=%pi/nphi;
  u1=zeros(nr,lupper+1,2);
  u2=zeros(nr,lupper+1,2);
  u3=zeros(nr,lupper+1,2);
  //outer loop integration over r
  
  for nec=1:ne
    e=nec*0.0025
    k=sqrt(2*m*e)/hb;
    totsum=0;
  //sigma=0;
  
  //dipangle=%pi*25/180;
  dipsep=0.0001;
  for itheta=1:ntheta
  for iphi=1:nphi
  theta=itheta*deltatheta;
  ctheta=cos(theta);
  if ctheta==-1 then
    ctheta=ctheta+0.0001;
  elseif ctheta==1 then
    ctheta=ctheta-0.0001;
  end
  
  phi=iphi*deltaphi;
  sumdelta=0;
  
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
        dipangle=acos(cos(theta)*sin(phi));
        if ik==1 then
          r=sqrt(rad^2+dipsep^2+2*rad*dipsep*cos(dipangle));
          epsilon=5.9;//meV H-Kr interaction
          sigma=3.57;//Angstrom
        else
          r=sqrt(rad^2+dipsep^2-2*rad*dipsep*cos(dipangle));
          epsilon=5.9;//meV H-Kr interaction
          sigma=3.57;//Angstrom
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
  
  //calculate real and imaginary amplitudes
  ampr=0;
  ampi=0;
  for il=0:lupper,   

    for ik=1:2
 
       temptandl=tdl(u2(nr-2,il+1,ik),u2(nr-1,il+1,ik),(nr-1)*delta,(nr)*delta,il,k);
       deltal=atan(temptandl);
       ampr=ampr+(2*il+1)*legendre(il,0,ctheta)*(cos(deltal)*sin(deltal));
       ampi=ampi+(2*il+1)*legendre(il,0,ctheta)*(sin(deltal)^2);

      //cosecdelta2=((1/(res^2))+1);
      //sumdelta=sumdelta+(2*i+1)*(1/cosecdelta2); 
    end
  end
  //sumdelta=sumdelta+(ampr^2+ampi^2-2*ampr*ampi)*deltatheta*sin(theta)*deltaphi;
  //sumdelta=sumdelta+(ampr^2+ampi^2)*deltatheta*sin(theta)*deltaphi;
  sumdelta=sumdelta+(ampr^2+ampi^2)*deltatheta*deltaphi;
  end //calculation for each theta
  end //calculation for each phi
    sumouter(nec)=sumdelta;
    //totsum=totsum+sumouter(nec);
    
  end  //end of calculation for each energy
  
  plot(sumouter);
