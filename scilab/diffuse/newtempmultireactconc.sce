
function [newtempmultireactconc]=newtempmultireactconc(nsubsteps, nspecies, concm, n1, n2, n3,t0,t,h,dif,sourcesm,sinksm,inconsts)

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
	      			   //nconcm(isp,i1,i2,i3)=mconcupdate(concs, i1,i2,i3,n1,n2,n3,t0,t,h,dif,sources,sinks);
	      			   nconcm(i1,i2,i3,isp)=mconcupdate(nspecies, concm, isp,i1,i2,i3,n1, n2, n3,t0,t,h,dif,sourcesm,sinksm,inconsts);
	      			   
	      			   if isp=3
	      			    if (nconcm(i1,i2,i3,1)>0.000001) 
	      			        if(nconcm(i1,i2,i3,2)>0.000001)
	      			          nconcm(i1,i2,i3,3)=nconcm(i1,i2,i3,3)+0.5*nconcm(i1,i2,i3,1)+0.75*nconcm(i1,i2,i3,2);
	      			          nconcm(i1,i2,i3,1)=0.5*nconcm(i1,i2,i3,1);
	      			          nconcm(i1,i2,i3,2)=0.25*nconcm(i1,i2,i3,2);
	      			        end
	      			    end
	      			   end
	      			   
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

