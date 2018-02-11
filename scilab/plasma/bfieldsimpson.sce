//bfield outside a solenoid
//assume solenoid aligned along z axis
function [b]=bfieldsimpson(r,ztp,zbot,n,i,rfp,dtheta)
 
  //n number of turns
  //i per turn
  bt=zeros(3,1);
  btd=zeros(3,3);
  mu0=4.0*%pi*(10^(-7));
  dz=(ztp-zbot)/n;
  ce=zeros(3,1);
  
  //calculate field contribution for each turn
  //z=zbot;
  z=0;
  dz=0.1;
  //dz=0;
  //dr=2*%pi/dtheta;
  dr=r*dtheta;
  ntheta=(2*%pi)/dtheta
  
    for ic=0:(ntheta/2)-1

      for jc=1:3
	     
              if jc==1 then
	      	theta=-%pi+(2*ic)*dtheta
              elseif jc==2 then
		theta=-%pi+(2*ic+1)*dtheta
              elseif jc==3 then
		theta=-%pi+(2*ic+2)*dtheta	
              end
	      //current element location

	      //z=theta;
	      xi=r*cos(theta);
	      yi=r*sin(theta);

	      rcp(1,1)=xi;
	      rcp(2,1)=yi;
	      rcp(3,1)=z;
	     
	      rp(1,1)=rfp(1,1)-r*cos(theta+(dtheta/4));
	      rp(2,1)=rfp(2,1)-r*sin(theta+(dtheta/4));
	      rp(3,1)=rfp(3,1)-z;

	      rcpd(1,1)=r*cos(theta+(dtheta/4));
	      rcpd(2,1)=r*sin(theta+(dtheta/4));
	      rcpd(3,1)=z+dz;  
	     
	      //current element vector
	      //using tangent vector defn. from
	      //http://mathworld.wolfram.com/TangentVector.html
	      //and arc length ds=rdtheta
	      //ce(1,1)=-sin(theta);
	      //ce(2,1)=cos(theta);
	      ce(:,1)=rcpd(:,1)-rcp(:,1);


	      
	      //evaluate cross product of current element and 
	      //field vector
	      cp(1,1)=ce(2,1)*rp(3,1)-ce(3,1)*rp(2,1);
	      cp(2,1)=ce(3,1)*rp(1,1)-ce(1,1)*rp(3,1);
	      cp(3,1)=ce(1,1)*rp(2,1)-ce(2,1)*rp(1,1);
	      
	      rsq=(rp(1,1)*rp(1,1)+rp(2,1)*rp(2,1)+rp(3,1)*rp(3,1))^(3/2);

	      btd(:,jc)=cp(:,1)/rsq;
      end

      bt(:,1)=bt(:,1)+(btd(:,1)+4*btd(:,2)+btd(:,3))/3;
       
    end
    b=mu0*i*dr*bt/(4*%pi);
endfunction
