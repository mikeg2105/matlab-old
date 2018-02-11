//General utility functions for diffusion modelling
//function to create an n1xn2xn3 array




//save xyz values
function saveconcs(filename, n1,n2,n3, concs)

	fd=mopen(filename, 'w')
  mfprintf(fd, '%f %f %f\n', n1,n2,n3)
	for i=1:n1
      for j=1:n2 
            for k=1:n3
                mfprintf(fd, '%f ', concs(i,j,k));
            end
            mfprintf(fd,'\n');
      end
	end
	
	mclose(fd)
endfunction

//save each species in a separate file
function  savemconcs(srootfilename,step, n1,n2,n3,nspecies, concs)

   for i=1:nspecies
      sfilename=sprintf('%s_%d_%d.dat', srootfilename, i, step);
      sconcs=concs(i);
      saveconcs(sfilename,n1,n2,n3, sconcs);
      
    end
            
endfunction

//read concentration matrix from file
function [smat]=difreadmat(sfilename)

mprintf('Reading concs\n');

  fd=mopen(sfilename, 'r');
  printf('Reading diffusion data matrix file %s \n', sfilename);
  fn1=mfscanf(fd, '%f');
  fn2=mfscanf(fd, '%f');
  fn3=mfscanf(fd, '%f');
  n1=fn1;
  n2=fn2;
  n3=fn3;
  printf('Reading matrix %d %d %d \n',n1 ,n2 ,n3);
  mval=zeros(n1,n2,n3);
	
	for i=1:n1
	  for j=1:n2
	    for k=1:n3
	    		   fval=mfscanf(fd, '%f');    
	 		   mval(i,j,k)=fval;			   
	    end
	  end
	end
	
	mclose(fd);
	printf('finished reading %s\n', sfilename);
	smat=mval;
endfunction



//read single selected value from file
//p1 and p2 are axes defining plane
//p3 co-ord axes of perpedicular to the layer
function [smat]=difselectlayer(sconc, n1,n2,n3,p1,p2,p3,layer)

	mymsize(1)=n1;
	mymsize(2)=n2;
	mymsize(3)=n3;
	
	//size of output matrix
	no1=mymsize(p1);
	no2=mymsize(p2);
	
	smatout=zeros(no1,no2);
        for i=1:mymsize(p1)
         for j=1:mymsize(p2)
	 
	   outi(p3)=layer;
	   outi(p2)=j;
	   outi(p1)=i;
	   smatout(i,j)=sconc(outi(1),outi(2),outi(3));
	 end
	end
	
	
	smat=smatout;
endfunction

function [selevvec]=difmat2vec(selevmat,np1 ,np2 )

  vout=zeros(np1*np2);
  
  for i=1:np1
    for j=1:np2
      vout(i+j*np1-1)=selevmat(i,j); 
    end
  end
  
  selevvec=vout;
endfunction


function [sevecstr]=difvec2str(selevvec, size);

  soldresult=sprintf('%f', selevvec(1));
  for i=2:size
    sresult=sprintf('%s %f', soldresult, selevvec(i));
    soldresult=sresult;
  end;
  
  sevecstr=sresult;
endfunction

//append filname for a configuration
//to the list of filenames
function appendfilelist(filelistname, filename)

	fd=mopen(filelistname, 'a')
  mfprintf(fd, '%s\n', filename)
	
	
	mclose(fd)
    
endfunction

//maxmin(1) is maximum concentration
//maxmin(2) is minimum concentration
function [getmaxminconc]=getmaxminconc(concs,n1,n2,n3)


maxmin=zeros(2);
maxmin(1)=-99999;
maxmin(2)=99999;
for i1=1:n1
    for i2=1:n2
            for i3=1:n3
              if concs(i1,i2,i3) > maxmin(1)
                        maxmin(1)=concs(i1,i2,i3);
              end
              if concs(i1,i2,i3) < maxmin(2)
                        maxmin(2)=concs(i1,i2,i3);
              end
            end
    end
end

getmaxminconc=maxmin;

endfunction

//For each element return the direction in which the 
//concentration gradient is a maximum
//n.b. a unit vector is not returned
function [grad]=grad(conc, h)
                            
   testgrad=zeros(3);
 
   if(h <>0)
    testgrad(1)=(conc(3,2,2)-conc(2,2,2))/h;
    testgrad(2)=(conc(2,3,2)-conc(2,2,2))/h;
    testgrad(3)=(conc(2,2,3)-conc(2,2,2))/h;
   end
   
   grad=testgrad;
endfunction

//get rotation matrix from direction cosines
//assumes normalised
function [rotmat]=rotmat(gradvec)
  rotmat=zeros(3,3);
  rotmat1=zeros(3,3);
  rotmat2=zeros(3,3);
  rotmat3=zeros(3,3);
  len=sqrt(gradvec(1)*gradvec(1)+gradvec(2)*gradvec(2)+gradvec(3)*gradvec(3));
  if len<=0
     len=1;
  end
  uvec=zeros(3);
  uvec=gradvec/len;
  
  ang=acos(uvec(1));
  rotmat1(1,1)=cos(ang);
  rotmat1(1,2)=-sin(ang);
  rotmat1(1,3)=0;
  rotmat1(2,1)=sin(ang);
  rotmat1(2,2)=cos(ang);
  rotmat1(2,3)=0;
  rotmat1(3,1)=0;
  rotmat1(3,2)=0;
  rotmat1(3,3)=1;

  ang=acos(uvec(2));
  rotmat2(1,1)=1;
  rotmat2(1,2)=0;
  rotmat2(1,3)=0;
  rotmat2(2,1)=0;
  rotmat2(2,2)=cos(ang);
  rotmat2(2,3)=-sin(ang);
  rotmat2(3,1)=0;
  rotmat2(3,2)=sin(ang);
  rotmat2(3,3)=cos(ang); 

   ang=acos(uvec(3));
  rotmat2(1,1)=cos(ang);
  rotmat2(1,2)=0;
  rotmat2(1,3)=-sin(ang);
  rotmat2(2,1)=0;
  rotmat2(2,2)=1;
  rotmat2(2,3)=0;
  rotmat2(3,1)=sin(ang);
  rotmat2(3,2)=0;
  rotmat2(3,3)=cos(ang);
  
  rotmat=rotmat1*rotmat2*rotmat3;
endfunction

//convert gradient vector to an axis and rotation vector
function [rotvec]=rotvec(gradvec)
  rotvec=zeros(4);
  magvec=sqrt(gradvec(1)*gradvec(1)+gradvec(2)*gradvec(2)+gradvec(3)*gradvec(3));
  if(magvec<=0)
    magvec=1;
  end
  normgradvec=gradvec/magvec;
  
  m=rotmat(normgradvec);
  angle = acos ( ( m(1,1) + m(2,2) + m(3,3) - 1)/2);
  den1=sqrt((m(3,2) - m(2,3))^2+(m(1,3) - m(3,1))^2+(m(2,1) - m(1,2))^2);
  den2=sqrt((m(3,2) - m(2,3))^2+(m(1,3) - m(3,1))^2+(m(2,1) - m(1,2))^2);
  den3=sqrt((m(3,2) - m(2,3))^2+(m(1,3) - m(3,1))^2+(m(2,1) - m(1,2))^2);
  if den1<=0 
     den1=1;
  end
  if den2<=0 
     den2=1;
  end
  if den3<=0 
     den3=1;
  end
  x = (m(3,2) - m(2,3))/den1;
  y = (m(1,3) - m(3,1))/den2;
  z = (m(2,1) - m(1,2))/den3;
  angle=acos((m(1,1)+m(2,2)+m(3,3)-1)/2);
  
  rotvec(1)=x;
  rotvec(2)=y;
  rotvec(3)=z;
  rotvec(4)=angle;

  return rotvec;
endfunction






