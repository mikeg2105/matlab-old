//   23 Sep 2005 "rrprocess.sci"  
//   Author: R. Nikoukhah (INRIA)                                             
//   This program is free software; you can redistribute it and/or modify      
//   it under the terms of the GNU General Public License as published by      
//   the Free Software Foundation; either version 2 of the License, or     
//   (at your option) any later version.                                   
//                                                             
//   This program is distributed in the hope that it will be useful,    
//   but WITHOUT ANY WARRANTY; without even the implied warranty of         
//   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the      
//   GNU General Public License for more details.
//        
//   This program is based on the C code "ecgsyn.c" copyrighted in
//   2003 by Patrick McSharry & Gari Clifford and the scientific article:   
//   IEEE Transactions On Biomedical Engineering, 50(3),289-294, March 2003.
//   The original and realted codes are freely availble from Physionet -    
//   http://www.physionet.org/ - please report any bugs to the authors above. 

function rr=rrprocess(flo,fhi,flostd,fhistd,fhfratio,hrmean,hrstd,sf,n)
   w1 = 2.0*PI*flo;
   w2 = 2.0*PI*fhi;
   c1 = 2.0*PI*flostd;
   c2 = 2.0*PI*fhistd;
   sig2 = 1.0;
   sig1 = lfhfratio;
   rrmean = 60.0/hrmean;
   rrstd = 60.0*hrstd/(hrmean*hrmean);

   df = sf/n;
   i=1:n;w = (i-1)*2.0*PI*df;
   dw1 = w-w1;dw2 = w-w2;
   Hw = sig1*exp(-dw1.*dw1/(2.0*c1*c1))/sqrt(2*PI*c1*c1)..
            + sig2*exp(-dw2.*dw2/(2.0*c2*c2))/sqrt(2*PI*c2*c2); 

   i=1:n/2
     Sw(i) = (sf/2.0)*sqrt(Hw(i));  
   i=n/2+1:n
     Sw(i) = (sf/2.0)*sqrt(Hw(n-i+1));
   

   // randomise the phases
   ph0=2*rand(1:n/2-1,"normal");
   ph=ph0;
   ph(1)=0;
   i=1:n/2-1
    ph(i+1) = ph0(i);
   
   ph(n/2+1)= 0;
   i=1:n/2-1
    ph(n-i+1) = - ph0(i); 

   // make complex spectrum */
   SwC=Sw.*(cos(ph)+%i*sin(ph));

   // calculate inverse fft 
   SwC=ifft(SwC);

   // extract real part 
   rr=real(SwC)/n;

   xstd = stdev(rr);
   ratio = rrstd/xstd; 

   rr=rr*ratio
   rr=rr+rrmean
endfunction


PI=%pi
N = 256;                //  Number of heart beats              
sfecg = 256;           //   ECG sampling frequency             
sf = 256;              //   Internal sampling frequency        
Anoise = 0.0;          //   Amplitude of additive uniform noise
hrmean = 120.0;        //    Heart rate mean                    
hrstd = 30.0;          //    Heart rate std                     
 flo = 0.1;            //   Low frequency          
 fhi = 0.25;           //   High frequency         
flostd = 0.01;        //    Low frequency std       
fhistd = 0.01;        //    High frequency std      
lfhfratio = 0.5;      //    LF/HF ratio             

Necg = 0;             //   Number of ECG outputs         
mstate = 3;           //   System state space dimension  
xinitial = 1.0;       //   Initial x co-ordinate value      
yinitial = 0.0;       //   Initial y co-ordinate value      
zinitial = 0.04;     //    Initial z co-ordinate value      
seed = 1;     

 q = int(sf/sfecg);
   qd = sf/sfecg;
   if q ~= qd then
     printf("Internal sampling frequency must be an integer multiple of the \n"); 
     printf("ECG sampling frequency!\n"); 
     printf("Your current choices are:\n");
     printf("ECG sampling frequency: %d Hertz\n",sfecg);
     printf("Internal sampling frequency: %d Hertz\n",sf);
     return
end

   // P            Q            R           S           T        */
   ti(1)=-60.0; ti(2)=-15.0; ti(3)=0.0;  ti(4)=15.0; ti(5)=90.0;
   ai(1)=1.2;   ai(2)=-5.0;  ai(3)=30.0; ai(4)=-7.5; ai(5)=0.75;
   bi(1)=0.25;  bi(2)=0.1;   bi(3)=0.1;  bi(4)=0.1;  bi(5)=0.4;

   // convert angles from degrees to radians 
   ti=ti*%pi/180;

   // adjust extrema parameters for mean heart rate 
   hrfact = sqrt(hrmean/60.0);
   hrfact2 = sqrt(hrfact);
   bi=bi*hrfact;
   ti(1)=ti(1)*hrfact2;  ti(2)=ti(2)*hrfact; ti(4)=ti(4)*hrfact; 


   // calculate time scales 
   h = 1.0/sf;
   tstep = 1.0/sfecg;

   printf(["ECGSYN: A program for generating a realistic synthetic ECG\n" 
    "Copyright (c) 2003 by Patrick McSharry & Gari Clifford. All rights reserved.\n"
    "See IEEE Transactions On Biomedical Engineering, 50(3), 289-294, March 2003.\n"
    "Contact P. McSharry (patrick@mcsharry.net) or G. Clifford (gari@mit.edu)\n"]); 

   printf("Approximate number of heart beats: %d\n",N);
   printf("ECG sampling frequency: %d Hertz\n",sfecg);
   printf("Internal sampling frequency: %d Hertz\n",sf);
   printf("Amplitude of additive uniformly distributed noise: %g mV\n",Anoise);
   printf("Heart rate mean: %g beats per minute\n",hrmean);
   printf("Heart rate std: %g beats per minute\n",hrstd);
   printf("Low frequency: %g Hertz\n",flo);
   printf("High frequency std: %g Hertz\n",fhistd);
   printf("Low frequency std: %g Hertz\n",flostd);
   printf("High frequency: %g Hertz\n",fhi);
   printf("LF/HF ratio: %g\n",lfhfratio);

   // initialise seed 
   rseed = -seed;  


   // select the derivs to use 
   //derivs = derivspqrst;

   // calculate length of RR time series 
   rrmean = (60/hrmean);
   Nrr=2^( ceil(log(N*rrmean*sf)/log(2.0)));
   printf("Using %d = 2^%d samples for calculating RR intervals\n",..
           Nrr,ceil(log(N*rrmean*sf)/log(2.0))); 


   // create rrprocess with required spectrum 
   rr=rrprocess(flo, fhi, flostd, fhistd, lfhfratio, hrmean, hrstd, sf, Nrr); 
   // create piecewise constant rr 
   rrpc = [];
   tecg = 0.0;
   TECG=[]; //
   RR=[]; //
   i = 1;
   j = 1;
   while(i <= Nrr)
      tecg = tecg +rr(j);
      TECG=[TECG,tecg]; //
      j = int(tecg/h);
      k=i:j; rrpc(k) = rr(i);
      RR=[RR,rr(i)]; //
      i = j+1;
   end
   Nt = j;



