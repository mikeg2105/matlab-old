



//This requires
//diffuse.m

//nonlinearity term for multi-species diffusion
function [compfunc]=compfunc(concm,specid,nspecies,inconsts, t)

  //simple linear multi species model with no time dependence
  total=0
  for i=1:nspecies
    temptot=total+(inconsts(specid,i)*concm(i));
	  total=temptot
	end
	
	compfunc=total
endfunction



//-->x=ode(x0,t0,t,list(sdotx,p,yold))
function [cmdott]=cmdott(t,c,lap3d,dif,sink,source,specid,nspecies,concm, inconsts)
	cmdott=dif*lap3d-sink+source+compfunc(concm,specid,nspecies,inconsts, t);
endfunction

function [mconcupdate]=mconcupdate(nspecies, concm, isp,i1,i2,i3,n1, n2, n3,t0,t,h,difv,sourcesm,sinksm,inconsts)
 
    concs=concm(: , :, :,isp);
    sources=sourcesm( :,:,:,isp);
    sinks=sinksm(:,:,:,isp);
    dif=difv(isp);
  

	      			   newc=concm(i1,i2,i3,isp);
	      			   if newc>=0
	      			     //get submatrix
	      						  //concsub=zeros(3,3,3)
	      						  concsub=getconcsub(concs,i1,i2,i3,n1,n2,n3);
	      						  //got sub matrix
	      						  //calculate laplacian
	      						  lap=lap3d(concsub,h)
	      						  sink=sinks(i1,i2,i3)
	      						  source=sources(i1,i2,i3)
	      						
	      						  localconcm=zeros(nspecies);
	      						
	      						  for sp1=1:nspecies
	      						      //conctemp=concm(:,:,:,sp1);
	      							     localconcm(sp1)=concm(i1,i2,i3,sp1);
	      						 end
	      						
	      						  //use laplacian to update
	      						  newc=ode(concs(i1,i2,i3),t0,t,list(cmdott,lap,dif,sink,source,isp,nspecies,localconcm,inconsts))
	      						  //conc(i1,i2,i3)=newconcm(sp)

      						    if newc<0
	      						    newc=0;
	      						  end
	      						
	      						end

	mconcupdate=newc;

endfunction


function [newtempmulticonc]=newtempmulticonc(nsubsteps, nspecies, concm, n1, n2, n3,t0,t,h,dif,sourcesm,sinksm,inconsts)

  //cycle over each element of the array
  //update concentration
 
  nconcm=zeros(n1,n2,n3,nspecies);
  ddt=dt/nsubsteps;
  
	for kk=1:nsubsteps
	t=t0+ddt;
	for isp=1:nspecies
	for i1=1:n1
	      for i2=1:n2
	      			for i3=1:n3
	      			   //nconcm(isp,i1,i2,i3)=mconcupdate(concs, i1,i2,i3,n1,n2,n3,t0,t,h,dif,sources,sinks);
	      			   nconcm(i1,i2,i3,isp)=mconcupdate(nspecies, concm, isp,i1,i2,i3,n1, n2, n3,t0,t,h,dif,sourcesm,sinksm,inconsts);
	      			end
	      end
	end
	end
	concs=nconcm;
	t0=t
	end

	newtempmulticonc=nconcm;

endfunction




//function to update species for multi species diffusion
function [newconcm]=newconcm(nspecies, concm, n1, n2, n3,t0,t,h,dif,sourcesm,sinksm,inconsts)

  //cycle over each element of the array
  //update concentration
  nconcm=zeros(nspecies,n1,n2,n3);
  for isp=1:nspecies
 	for i2=1:n1
	      for i2=1:n2
	      			for i3=1:n3 
 							nconcm(isp,i1,i2,i3)=mconcupdate(nspecies, concm, isp,i1,i2,i3,n1, n2, n3,t0,t,h,dif,sourcesm,sinksm,inconsts);	      						
	      			end
	      end
	end
	end
	newconcm=nconcm;

endfunction





function [diffusem]=diffusem(nsteps, nsubsteps, dt, dif,in, concs, sources, sinks,inconsts)

  //diffusion system initial values
  //d=in(1)
  //d passed as a vector 1 diffusion constant for each species
  n1=in(1)
  n2=in(2)
  n3=in(3)
  h=in(4)
  nspecies=in(5)
  t0=0
  
  //concs, sources and sinks are lists of 3d matrices
  //the list contains nspecies entries
  
  t=t0
  ddt=dt/nsubsteps
  
  
	for kk=1:nsubsteps
	      t=t0+ddt
	  			newc=newconc(nspecies, concs, n1, n2, n3,t0,t,h,dif,sources,sinks,inconsts);
	  			t0=t
	end
	

	
  diffusem=newc
 
endfunction


function [mymultidiffuse]=mymultidiffuse(nsteps, nsubsteps, dt, dif, in, concs, sources, sinks,inconsts)

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
      concn=newtempmulticonc(nsubsteps, nspecies, concs, n1,n2,n3,t0,t,h,dif, sources, sinks,inconsts);
      printf('conc=%f\n',concn(2,2,1));
	  	 t0=t;
	  	 t=t0+dt;
      concs=concn;
      //printf()
  		  //save the matrix for this step
      //sfilename=sprintf('diffuse_%d.dat', ii);
      //sx3dfilename=sprintf('diffuse_%d.x3d', ii);
      
      //save each species in a separate file
      //savemconcs('diffusem',ii,n1,n2,n3,nspecies, concs);
           
      updatemfilelist(ii,'diffuse',n1,n2,n3,nspecies,concn,h);
 end               

  mymultidiffuse=newconc
 
endfunction





