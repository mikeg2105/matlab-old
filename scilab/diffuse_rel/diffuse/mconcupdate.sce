function [mconcupdate]=mconcupdate(nspecies, concm, isp,i1,i2,i3,n1, n2, n3,t0,t,h,difv,sourcesm,sinksm,inconsts)
 
    concs=concm(1:n1 , 1:n2, 1:n3,isp)
    sources=sourcesm( 1:n1,1:n2,1:n3,isp);
    sinks=sinksm(1:n1,1:n2,1:n3,isp);
    //concs=zeros(n1,n2,n3);
    //sources=zeros(n1,n2,n3);
    //sinks=zeros(n1,n2,n3);
    //concm=ones(nspecies,n1,n2,n3);
    dif=difv(isp,1);
  
 
	      			   newc=concm(i1,i2,i3,isp);
	      			   if newc>=0
	      			     //get submatrix
	      						  //concsub=zeros(3,3,3)
	      						  //concs
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

