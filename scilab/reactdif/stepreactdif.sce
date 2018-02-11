function [result]=stepreactdif(jobname,step,nsubsteps, dt, reactdifinputs,a,ksq,umat)


  //set up the constants
  in=reactdifinputs.consts;
  concs=reactdifinputs.initialconcs;
  
  //jobname="1"
  n1=in(1);   //n1
  n2=in(2);    //n2
  n3=in(3);  //n3
  h=in(4);    //h
  nspec=in(5);
  
  difpar=reactdifinputs.difpar;
  reactar=reactdifinputs.reactpar;
  
  for i=1:nspec
     as(i)=a(:,:,:,i);
  end
	

  for i=1:nspec
    da=0;
    for j=1:nspec
      da=da+reactdif(i,j)*as(j);
    end
    da=da-difpar(i)*as(i).*ksq;
    as(i)=as(i)+dt*da;
  end
  
  //update the concentrations
  for i=1:nspec
    result(i)=as(i).*umat;
  end
  

  return result;

endfunction
