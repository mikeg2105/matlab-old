//Calculate laplacian in 3d
//n1xn2xn3 conc array
//size n1xn2xn3
//
//Will always be a 3x3x3 piece of the complete 
//array at this point there is no boundary condition check
function [lap3d]=lap3d(conc,h)

   t1=conc(3,2,2)-2*conc(2,2,2)+conc(1,2,2);
   t2=conc(2,3,2)-2*conc(2,2,2)+conc(2,1,2);
   t3=conc(2,2,3)-2*conc(2,2,2)+conc(2,2,1);
   lap3d=(t1+t2+t3)/(h*h);
endfunction
