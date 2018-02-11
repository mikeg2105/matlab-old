



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


