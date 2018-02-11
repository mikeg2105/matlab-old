//In addition to the amplitude of any periodic signals, we would also like information 
//on the phase. In practice, the Morlet wavelet shown in Figure 2a is defined as the 
//product of a complex exponential wave and a Gaussian envelope
//http://paos.colorado.edu/research/wavelets/wavelet2.html
//http://users.rowan.edu/~polikar/WAVELETS/WTpart1.html

function [wavesm]=wavesm(xv,n,col,deltat,s, omega0)
  
  
  for i=1:n
  	for j=1:col
  	mw(i,j)=wavelett(xv,n,i,j*deltat,i*s, omega0);
   end
  end
  
  wavesm=mw;

endfunction



function [wavelett]=wavelett(x, n, ndash, deltat, s, omega0)

  rsum=0
  
  for i=1:n
  	wv=x(i)*conj(shiftedmortlet(ndash,n-1,deltat,s));
   rsum=rsum+wv;
  end
  
  
  
  wavelett=rsum
endfunction

function [shiftedmortlet]=shiftedmortlet(n, ndash, deltat, s, omega0)

	shiftedmortlet= sqrt(deltat/s)*mortlet((ndash-n)*deltat/s, omega0);

endfunction

function [mortlet]=mortlet(eta, omega0)

	mortlet= %pi^(-0.25)*exp(%i*omega0*eta)*exp(-eta^2/2);

endfunction

function [mwplots]=mwplots(ft, t, x1, x2, omega0)
 
 
 wv=wavesm(ft,21,21,.05,1.1,omega0);
 subplot(2,2,1);
 plot3d1(x1,x2,wv);
 
 wv=wavesm(ft,21,21,.15,1.1,omega0);
 subplot(2,2,2);
 plot3d1(x1,x2,wv);
 
 wv=wavesm(ft,21,21,.25,1.1,omega0);
 subplot(2,2,3);
 plot3d1(x1,x2,wv);
 
 wv=wavesm(ft,21,21,.35,1.1,omega0);
 subplot(2,2,4);
 plot3d1(x1,x2,wv);
 
 mwplots=0

endfunction




function [wavess]=wavess(x,n,deltat,s)
	
	
	for i=1:n
		vwaves(i)=wavelett(x,n,i,deltat,s)
	
	end

   wavess=vwaves
endfunction



	
	


function [psi]=psi(t)
	global A
	global omega_0
	global phi
 psi=A*cos(omega_0*t+phi)
endfunction

function [psi]=psidef(t, A, omega_0, phi)
 psi=A*cos(omega_0*t+phi)
endfunction


function []=set_wave(amp, om, ph)
	global A
	global omega_0
	global phi
 A=amp
 omega_0=om
 phi=ph
endfunction

function [psisum]=sum_wave(t,n,amp, om, ph)

psisum=0
	for k=1:n
 		temp=psisum+psidef(t, amp, om*k, ph)
 		psisum=temp
 end

endfunction

function [psisum]=beat_wave(t,amp1,amp2, om, fac, ph)

psisum=psidef(t, amp1, om, ph)+psidef(t, amp2, fac*om, ph)
	
 

endfunction

function [psisum]=fourier_wave(t,n,amp, om, ph)

psisum=0
	for k=1:n
 		temp=psisum+psidef(t, amp(k), om*k, ph)
 		psisum=temp
 end

endfunction

function [result]=plot_fun(name)
    driver('GIF')
    xinit(name)
    t=0:0.05:5
    plot2d(t, beat_wave(t,1,5,5,0.02,5))    

    result=0
endfunction



