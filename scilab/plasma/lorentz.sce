//lorentz force
function [vdott]=lorentzf(q,m,v,e,b)
  
  ac=zeros(3,1);
  
  ac(1,1)=e(1,1)+v(2,1)*b(3,1)-v(3,1)*b(2,1);
  ac(2,1)=e(2,1)+v(3,1)*b(1,1)-v(1,1)*b(3,1);
  ac(3,1)=e(3,1)+v(1,1)*b(2,1)-v(2,1)*b(1,1);
  
  vdott=(q/m)*ac;
endfunction
