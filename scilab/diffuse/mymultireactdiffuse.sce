function [mymultireactdiffuse]=mymultireactdiffuse(jobname,nsteps, nsubsteps, dt, dif, in, concs, sources, sinks,inconsts)

  //diffusion system initial values
  
  n1=in(1);
  n2=in(2);
  n3=in(3);
  h=in(4);
  nspecies=in(5);
  t0=0; 
  t=t0;
  
  ddt=dt/nsubsteps
  printf('sub steps: %d \n', nsubsteps);
  //smat=zeros(4,nsteps)

	for ii=1:nsteps
	    printf('step= %d \n', ii);	
	     printf('conc1=%f\n',concs(5,5,1,1));
      printf('conc2=%f\n',concs(15,15,1,2));
      concn=newtempmultireactconc(nsubsteps, nspecies, concs, n1,n2,n3,t0,t,h,dif, sources, sinks,inconsts);
      //printf('conc1=%f\n',concn(5,5,1,1));
      //printf('conc2=%f\n',concn(15,15,1,2));
	  	 t0=t;
	  	 t=t0+dt;
      concs=concn;
      //printf()
  		  //save the matrix for this step
      //sfilename=sprintf('%s', jobname);
      //sx3dfilename=sprintf('diffuse_%d.x3d', ii);
      
      //save each species in a separate file
      savemconcs(jobname,ii,n1,n2,n3,nspecies, concs);
           
      //updatemfilelist(ii,'diffuse',n1,n2,n3,nspecies,concn,h);
 end               

  mymultireactdiffuse=concs;
 
endfunction






