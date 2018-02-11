%In addition to the amplitude of any periodic signals, we would also like information 
%on the phase. In practice, the Morlet wavelet shown in Figure 2a is defined as the 
%product of a complex exponential wave and a Gaussian envelope
%http:%paos.colorado.edu/research/wavelets/wavelet2.html
%http:%users.rowan.edu/~polikar/WAVELETS/WTpart1.html

function [wavesm]=wavesm(xv,n,col,deltat,s, omega0)
  
  
  for ic=1:n
  	for jc=1:col
  	mw(ic,jc)=wavelett(xv,n,ic,deltat,jc*s, omega0);
   end
  end
  
  wavesm=mw;

%endfunction














function [wavess]=wavess(x,n,deltat,s)
	
	
	for i=1:n
		vwaves(i)=wavelett(x,n,i,deltat,s)
	
	end

   wavess=vwaves
%endfunction



	
	


function [psi]=psi(t)
	global A
	global omega_0
	global phi
 psi=A*cos(omega_0*t+phi)
%endfunction

function [psi]=psidef(t, A, omega_0, phi)
 psi=A*cos(omega_0*t+phi)
%endfunction


function []=set_wave(amp, om, ph)
	global A
	global omega_0
	global phi
 A=amp
 omega_0=om
 phi=ph
%endfunction

function [psisum]=sum_wave(t,n,amp, om, ph)

psisum=0
	for k=1:n
 		temp=psisum+psidef(t, amp, om*k, ph)
 		psisum=temp
 end

%endfunction

function [psisum]=beat_wave(t,amp1,amp2, om, fac, ph)

psisum=psidef(t, amp1, om, ph)+psidef(t, amp2, fac*om, ph)
	
 

%endfunction

function [psisum]=fourier_wave(t,n,amp, om, ph)

psisum=0
	for k=1:n
 		temp=psisum+psidef(t, amp(k), om*k, ph)
 		psisum=temp
 end

%endfunction





