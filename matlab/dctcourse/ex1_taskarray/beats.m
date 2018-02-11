function [wav1]=beats(id, size, totaltime)


wav1=zeros(size,totaltime);
t=1:1:totaltime;
for shift=1:1:size; wav1( shift ,:)=beat_wave(t,1,1,0.05,shift*id/100,0); end;




function [psisum]=beat_wave(t,amp1,amp2, om, fac, ph)

psisum=psidef(t, amp1, om, ph)+psidef(t, amp2, fac*om, ph);


function [psi]=psidef(t, A, omega_0, phi)
 psi=A*cos(2*pi*omega_0*t+2*pi*2*pi*phi/360);
%endfunction