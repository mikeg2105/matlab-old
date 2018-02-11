function [react]=react(concm,n1,n2,n3,nspecies,rconsts, t)

  //simple linear multi species model with no time dependence
  nconcm=concm;
 	//for i=1:nspecies
	for i1=1:n1
	      for i2=1:n2
	      			for i3=1:n3
	      			    if (concm(i1,i2,i3,1)>0.000001) 
	      			      if(concm(i1,i2,i3,2)>0.000001)
	      			        nconcm(i1,i2,i3,3)=concm(i1,i2,i3,3)+0.5*concm(i1,i2,i3,1)+0.75*concm(i1,i2,i3,2);
	      			        nconcm(i1,i2,i3,1)=0.5*concm(i1,i2,i3,1);
	      			        nconcm(i1,i2,i3,2)=0.25*concm(i1,i2,i3,2);
	      			      end
	      			    end
	      			end
	      end
	end
	//end
	react=nconcm
endfunction

