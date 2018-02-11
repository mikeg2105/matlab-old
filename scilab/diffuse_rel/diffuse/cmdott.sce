//-->x=ode(x0,t0,t,list(sdotx,p,yold))
function [cmdott]=cmdott(t,c,pos,lap3d,dif,sink,source,specid,nspecies,concm, inconsts)

 total=0
 // for i=1:nspecies
 //   temptot=total+(inconsts2(specid,i)*(concm(i)*concm(specid)));
//	  total=temptot
//	end
  al0=inconsts(1);
  be0=inconsts(2);
  
  //pal=2*%pi*((pos(1)-4)/8+(pos(2)-4)/8+(pos(3)-4)/8000);
  //pbe=2*%pi*((pos(1)-8)/16+(pos(2)-8)/16+(pos(3)-8)/8000);
   pal=2*%pi*((pos(1)-8)/14+(pos(2)-8)/14);
  pbe=2*%pi*((pos(1)-2)/10+(pos(2)-2)/10);

  al=al0*(cos(pal))^8
  be=be0*(cos(pbe))^8
	if specid==1 then
	   total=-al*sqrt(concm(1)*concm(2))+0.5*be*concm(3);	
 elseif specid==2 then
 	   total=-al*sqrt(concm(1)*concm(2))+0.5*be*concm(3);
 elseif specid==3 then 
  	   total=2*al*sqrt(concm(1)*concm(2))-be*concm(3);
  end
	//compfunc=total


	//cmdott=dif*lap3d-sink+source+compfunc(concm,specid,nspecies,inconsts, t);
	cmdott=dif*lap3d-sink+source+total;
endfunction

