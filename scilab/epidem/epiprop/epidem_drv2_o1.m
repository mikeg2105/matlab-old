

//nrows by ncolumns


//set up a matrix of i
//set up a matrix of s
//set up a matrix of r
function [createmat]=createmat(nr, nc, const, seed)

	rand('uniform')
	
	for i=1:nr
		for j=1:nc
			mat(i,j)=const+seed*rand()
	  end
	end
  createmat=mat
 
endfunction

//load mat props
function [loadmatprops]=loadmatprops(fd)

	//fd=mopen(filename, 'r')
	//nr=mfscanf(fd, '%f\n')
	//nc=mfscanf(fd, '%f\n')
	mat(1,1:3)=mfscanf(fd, '%f %f %f\n')

  loadmatprops=mat
 
endfunction

//load matrix
function [loadmat]=loadmat(fd, nr, nc)

	//fd=mopen(filename, 'r')
	//nr=mfscanf(fd, '%f\n')
	//nc=mfscanf(fd, '%f\n')
	
	for i=1:nr
		for j=1:nc-1
	 		mat(i,j)=mfscanf(fd, '%f ')
	 	end
	 	mat(i,nc)=mfscanf(fd, '%f \n')
	end
  loadmat=mat
 
endfunction


//load parameters
//returns a matrix of parameters
function [parammat]=loadparam(fd)

	 mat(1,1:4)=mfscanf(fd, '%f %f %f %f\n')
   //mat(1,1)=beta
   //mat(1,2)=b
   //mat(1,3)=d
   //mat(1,4)=g
   
   parammat=mat
endfunction



//save param
function [parammat]=saveparam(fd, beta, b, d,g)
   mat(1,1)=beta
   mat(1,2)=b
   mat(1,3)=d
   mat(1,4)=g
  	mfprintf(fd, '%f %f %f %f\n',mat)  
   parammat=mat
endfunction


//save matrix
function [smat]=savemat(fd,is,nr,nc, mat)


  mfprintf(fd, '%f %f %f\n', is, nr, nc)
	for i=1:nr
		for j=1:nc-1
	 		mfprintf(fd, '%f ', mat(i,j))
	 	end
	 	  mfprintf(fd, '%f \n', mat(i,nc))
	end
   
  smat=mat
endfunction

function [nfilename]=saveconfig(filename, nr, nc, s, i, r, beta,b,d,g,is)

   fd=mopen(filename, 'w')

   saveparam(fd, beta,b,d,g)
   //savemat(fd,nr,nc,s)
   savemat(fd,is,nr,nc,i)
   //savemat(fd,nr,nc,r)

   mclose(fd)
    nfilename=filename
endfunction

function [nfilename]=appendconfigi(filename, nr, nc, s, i, r, beta,b,d,g,is)

   fd=mopen(filename, 'a')

   saveparam(fd, beta,b,d,g)
   //savemat(fd,nr,nc,s)
   savemat(fd,is,nr,nc,i)
   //savemat(fd,nr,nc,r)

   mclose(fd)
    nfilename=filename
endfunction

function [nfilename]=appendconfigs(filename, nr, nc, s, i, r, beta,b,d,g,is)

   fd=mopen(filename, 'a')

   saveparam(fd, beta,b,d,g)
   //savemat(fd,nr,nc,s)
   savemat(fd,is,nr,nc,s)
   //savemat(fd,nr,nc,r)

   mclose(fd)
    nfilename=filename
endfunction


function [nfilename]=appendconfigr(filename, nr, nc, s, i, r, beta,b,d,g,is)

   fd=mopen(filename, 'a')

   saveparam(fd, beta,b,d,g)
   //savemat(fd,nr,nc,s)
   savemat(fd,is,nr,nc,r)
   //savemat(fd,nr,nc,r)

   mclose(fd)
    nfilename=filename
endfunction

function [nfilename]=appendconfigt(filename, nr, nc, s, i, r, beta,b,d,g,is)

   fd=mopen(filename, 'a')
   t=i+s+r
   saveparam(fd, beta,b,d,g)
   //savemat(fd,nr,nc,s)
   savemat(fd,is,nr,nc,t)
   //savemat(fd,nr,nc,r)

   mclose(fd)
    nfilename=filename
endfunction
//function to calculate the average of the nearest neighbour
//elements for a matrix

//calculate the average of nearest neighbour elements
//range=1
//sav=avgelem(smat, nr, nc, range)

function [avgmat]=avgelem(smat, nr, nc, srange)

	if srange<0 then
   srange=0
  end
  
	for i=1:nr
		for j=1:nc
		
				sumt=0
				count=0
				
				for ii=-srange:srange
					for jj=-srange:srange
					
					  if ii<>0 then
					  	if jj<>0 then
					  	
					  	  in=i+ii
					  	  jn=j+jj
					  	  if in <= nr then
					  	  	if in>0 then
					  	  		if jn<=nc then
					  					if jn>0 then
					  						sumt=sumt+smat(in,jn)
					  						count=count+1				  					
					  					end
					  				end
					  	  	end
					  	  end
					
					  	
					  	end
						end
						
						
						
						
					end
				end
		
	
				if count > 0 then
					mat(i,j)=sumt/count
				else
				  mat(i,j)=0
				end
				
	  end
	end
	
	avgmat=mat

endfunction



//solve s
function [msolves]=solves(nr, nc, smat, iav , imat, rmat, beta, b, d, g, t0, t)

  mat=smat
  
  //calculate the average of nearest neighbour elements
  //range=1
	//sav=avgelem(smat, nr, nc, range)

	
	for i=1:nr
		for j=1:nc
				mat(i,j)=ode(smat(i,j),t0,t,list(sdot,b,beta,iav(i,j),imat(i,j),d))
	  end
	end
  msolves=mat
 
endfunction



//solve r
function [msolver]=solver(nr, nc, smat, iav , imat, rmat, beta, b, d, g, t0, t)

  mat=rmat
  
  //calculate the average of nearest neighbour elements
  //range=1
	//sav=avgelem(smat, nr, nc, range)
//-->r=ode(r0,t0,t,list(rdot,g,i,d))
	
	for i=1:nr
		for j=1:nc
				mat(i,j)=ode(rmat(i,j),t0,t,list(rdot,g,imat(i,j),d))
	  end
	end
  msolver=mat
 
endfunction




//solve s
function [msolvei]=solvei(nr, nc, smat, iav , imat, rmat, beta, b, d, g, t0, t)

  mat=imat
  
  //calculate the average of nearest neighbour elements
  //range=1
	//sav=avgelem(smat, nr, nc, range)

	//-->i=ode(i0,t0,t,list(idot,beta,s,sav,g,d))
	for i=1:nr
		for j=1:nc
				mat(i,j)=ode(imat(i,j),t0,t,list(idot,beta,smat(i,j), iav(i,j),g,d))
	  end
	end
  msolvei=mat
 
endfunction


