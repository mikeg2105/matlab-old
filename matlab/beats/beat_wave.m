function [psisum]=beat_wave(t,amp1,amp2, om, fac, ph)

psisum=psidef(t, amp1, om, ph)+psidef(t, amp2, fac*om, ph);


function [psi]=psidef(t, A, omega_0, phi)
 psi=A*cos(2*pi*omega_0*t+2*pi*2*pi*phi/360);
%endfunction