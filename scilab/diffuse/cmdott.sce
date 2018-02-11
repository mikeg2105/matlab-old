//-->x=ode(x0,t0,t,list(sdotx,p,yold))
function [cmdott]=cmdott(t,c,lap3d,dif,sink,source,specid,nspecies,concm, inconsts)
	cmdott=dif*lap3d-sink+source+compfunc(concm,specid,nspecies,inconsts, t);
endfunction

