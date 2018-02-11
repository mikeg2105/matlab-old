//total cross section
function [sigma]=sigma()
  lupper=10;
  sumdelta=0;
  delta=0.1;
  
  for i=0:lupper
   res=tandeltal(r,r+delta,i)
   cosecdelta2=((1/(res^2))+1);
   sumdelta=(2*i+1)*(1/cosecdelta2); 
  end
  sigma=((4*%pi)/(k^2))*()
 

 
endfunction

