function [maxp]=maxwell(massp, temp, vel)
  
  kb=1.38*10^(-23);
  maxp=(4*%pi)*(((massp/(2*%pi*kb*temp))^(1.5)))*(vel^2)*exp((-massp*vel*vel/(2*kb*temp)));
  
endfunction
