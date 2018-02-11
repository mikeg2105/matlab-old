function [diffusem]=diffusem(nsteps, nsubsteps, dt, dif,in, concs, sources, sinks,inconsts)

  //diffusion system initial values
  //d=in(1)
  //d passed as a vector 1 diffusion constant for each species
  n1=in(1);
  n2=in(2);
  n3=in(3);
  h=in(4);
  nspecies=in(5);
  
  t0=0;
  
  //concs, sources and sinks are lists of 3d matrices
  //the list contains nspecies entries
  
  t=t0;
  ddt=dt/nsubsteps;
  
  
	for kk=1:nsubsteps
	      t=t0+ddt;
	  			newc=newconcm(nspecies, concs, n1, n2, n3,t0,t,h,dif,sources,sinks,inconsts);
	  			t0=t;
	end
	

	
  diffusem=newc;
 
endfunction

