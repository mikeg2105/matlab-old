//bfield outside a solenoid
//assume solenoid aligned along z axis
function [b]=bfield(r,ztp,zbot,n,i,rfp,dtheta)
 
  //n number of turns
  //i per turn
  bt=zeros(3,1);
  mu0=4.0*%pi*(10^(-7));
  dz=(ztp-zbot)/n;
  ce=zeros(3,1);
  
  //calculate field contribution for each turn
  //z=zbot;
  z=0;
  dz=0.1;
  dz=0;
  //dr=2*%pi/dtheta;
  dr=r*dtheta;
  //dr=dtheta;
  //for ic=0:n
    for theta=-%pi:dtheta:%pi-dtheta
    //for theta=0:dtheta:(2*%pi)-dtheta
      //current element location

      //z=theta;
      xi=r*cos(theta);
      yi=r*sin(theta);
      //xi=0;
      //yi=0;
      rcp(1,1)=xi;
      rcp(2,1)=yi;
      rcp(3,1)=z;
     
      rp(1,1)=rfp(1,1)-r*cos(theta+dtheta/2);
      rp(2,1)=rfp(2,1)-r*sin(theta+dtheta/2);
      rp(3,1)=rfp(3,1)-z;


      //rp(1,1)=rfp(1,1);
      //rp(2,1)=rfp(2,1);
      //rp(3,1)=rfp(3,1)-z;

      rcpd(1,1)=r*cos(theta+dtheta);
      rcpd(2,1)=r*sin(theta+dtheta);
      rcpd(3,1)=z+dz;  
 
      //rcpd(1,1)=0;
      //rcpd(2,1)=0;
      //rcpd(3,1)=z+dz;  
 
     
      //current element vector
      //using tangent vector defn. from
      //http://mathworld.wolfram.com/TangentVector.html
      //and arc length ds=rdtheta
      //ce(1,1)=-sin(theta);
      //ce(2,1)=cos(theta);
      
      ce(1,1)=rcpd(1,1)-rcp(1,1);
      ce(2,1)=rcpd(2,1)-rcp(2,1);
      ce(3,1)=rcpd(3,1)-rcp(3,1);
      
      //evaluate cross product of current element and 
      //field vector
      cp(1,1)=ce(2,1)*rp(3,1)-ce(3,1)*rp(2,1);
      cp(2,1)=ce(3,1)*rp(1,1)-ce(1,1)*rp(3,1);
      cp(3,1)=ce(1,1)*rp(2,1)-ce(2,1)*rp(1,1);
      
      //rsq=rp(1,1)*rp(1,1)+rp(2,1)*rp(2,1)+rp(3,1)*rp(3,1);
      rsq=(rp(1,1)*rp(1,1)+rp(2,1)*rp(2,1)+rp(3,1)*rp(3,1))^(3/2);
      bt(1,1)=bt(1,1)+mu0*i*dr*(cp(1,1))/(4*%pi*rsq);
      bt(2,1)=bt(2,1)+mu0*i*dr*(cp(2,1))/(4*%pi*rsq);
      bt(3,1)=bt(3,1)+mu0*i*dr*(cp(3,1))/(4*%pi*rsq);
      //bt(1,1)=bt(1,1)+(cp(1,1));
      //bt(2,1)=bt(2,1)+(cp(2,1));
      //bt(3,1)=bt(3,1)+(cp(3,1));

        
    end
    //z=z+dz;
//end


  
  
  
  b=bt;
endfunction
