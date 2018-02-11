
function [newtempmultireactconc]=newtempmultireactconc(nsubsteps, nspecies, concm, n1, n2, n3,t0,t,h,dif,sourcesm,sinksm,inconsts2,inconsts1)

  //cycle over each element of the array
  //update concentration
 rconsts=0;
  nconcm=zeros(n1,n2,n3,nspecies);
  ddt=dt/nsubsteps;
  
	for kk=1:nsubsteps
	t=t0+ddt;
	//t0=t0+ddt;
	for isp=1:nspecies
	for i1=1:n1
	      for i2=1:n2
	      			for i3=1:n3
	      			  pos(1)=i1;
	      			  pos(2)=i2;
	      			  pos(3)=i3;
	          concs=concm(1:n1 , 1:n2, 1:n3,isp)
            sources=sourcesm( 1:n1,1:n2,1:n3,isp);
            sinks=sinksm(1:n1,1:n2,1:n3,isp);			
	      			
	      			 difc=dif(isp,1);
	      			 newc=concm(i1,i2,i3,isp);

	      			   if newc>=0
	      						  concsub=getconcsub(concs,i1,i2,i3,n1,n2,n3);
	      						  lap=lap3d(concsub,h)
	      						  sink=sinks(i1,i2,i3)
	      						  source=sources(i1,i2,i3)	      						
	      						  localconcm=zeros(nspecies);	      						
	      						  for sp1=1:nspecies
	      							     localconcm(sp1)=concm(i1,i2,i3,sp1);
	      						  end
	      						  newc=newc+dt*cmdott(t,0,pos,lap,difc,sink,source,isp,nspecies,localconcm,inconsts);
	      						  
	      						  //newc=ode(concs(i1,i2,i3),t0,t,list(cmdott,pos,lap,difc,sink,source,isp,nspecies,localconcm,inconsts))
      						    if newc<0
	      						    newc=0;
	      						  end	
	      						end	
	      			
	      			nconcm(i1,i2,i3,isp)=newc;
	      			
	      			
	      			
		      			   //nconcm(i1,i2,i3,isp)=mconcupdate(nspecies, concm, isp,i1,i2,i3,n1, n2, n3,t0,t,h,dif,sourcesm,sinksm,inconsts);
	      			   
	      			   //if isp=3
	      			   // if (nconcm(i1,i2,i3,1)>0.000001) 
	      			    //    if(nconcm(i1,i2,i3,2)>0.000001)
	      			    //      nconcm(i1,i2,i3,3)=nconcm(i1,i2,i3,3)+0.5*nconcm(i1,i2,i3,1)+0.75*nconcm(i1,i2,i3,2);
	      			     //     nconcm(i1,i2,i3,1)=0.5*nconcm(i1,i2,i3,1);
	      			     //     nconcm(i1,i2,i3,2)=0.25*nconcm(i1,i2,i3,2);
	      			     //   end
	      			   // end
	      			   //end
	      			   
	      			end
	      end
	end
	end
	concs=nconcm;
	//concs=react(concs,n1,n2,n3,nspecies,rconsts, t);
	t0=t
	end

	newtempmultireactconc=nconcm;
//newtempmulticonc=concm;
endfunction

