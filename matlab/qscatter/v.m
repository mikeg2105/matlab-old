function [v]=v(r,sigma,epsilon)
   %epsilon=5.9;%meV H-Kr interaction
  %sigma=3.57;%Angstrom
  v=10*epsilon*( (sigma/r)^12-2*(sigma/r)^6);
%endfunction
