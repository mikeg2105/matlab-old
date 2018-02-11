//bfield outside a solenoid
//assume solenoid aligned along z axis
function [g]=grav(m,r)
 
  me=;
  G=;
  
  rsq=r(1,1)*r(1,1)+r(2,1)*r(2,1)+r(3,1)*r(3,1);
  
  g=G*me/rsq;
endfunction
