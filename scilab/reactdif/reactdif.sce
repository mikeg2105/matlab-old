function [result]=reactdif(jobname,nsubsteps, dt, reactdifinputs)


  //set up the constants
  in=reactdifinputs.consts;
  concs=reactdifinputs.initialconcs;
  
  //jobname="1"
  n1=in(1);   //n1
  n2=in(2);    //n2
  n3=in(3);  //n3
  h=in(4);    //h
  nspec=in(5);
  
  a=zeros(n1,n2,n3,nspec);
  
  //calculate harmonic expansion coefficients from initial concentrations 
  for i=1:nspec
  
     for i3=1:n3
      for i2=1:n2
        invec=concs(:,i2,i3,i);
        a(:,i2,i3,i)=real(dft(invec,1));

      end
    end
   end //loop over species
   
  
   	ksq=zeros(n1,n2,n3);
	for i=1:n1
	  for j=1:n2
	     for k=1:n3
	       ksq(i,j,k)=%pi * %pi * ((i/n1)*(i/n1)+(j/n2)*(j/n2)+(k/n3)*(k/n3)); 
	       umat(i,j,k)=cos(i*%pi)*cos(j*%pi)*cos(k*%pi);
	     end
	  end
	end
   
  for i=0:nsteps
    sirout=stepreactdif(jobname, i, nsubsteps, dt, reactdifinputs,a,ksq,umat);
    
    //save the output
  end
	
   


  result=a;

  return result;

endfunction
