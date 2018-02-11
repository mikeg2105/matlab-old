//function to update species for multi species diffusion
function [newconcm]=newconcm(nspecies, concm, n1, n2, n3,t0,t,h,dif,sourcesm,sinksm,inconsts)

  //cycle over each element of the array
  //update concentration
  nconcm=zeros(n1,n2,n3,nspecies);
  for isp=1:nspecies
 	for i2=1:n1
	      for i2=1:n2
	      			for i3=1:n3 
 							nconcm(i1,i2,i3,isp)=mconcupdate(nspecies, concm, isp,i1,i2,i3,n1, n2, n3,t0,t,h,dif,sourcesm,sinksm,inconsts);	      						
	      			end
	      end
	end
	end
	newconcm=nconcm;

endfunction

