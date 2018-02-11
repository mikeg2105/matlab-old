//General utility functions for diffusion modelling
//function to create an n1xn2xn3 array




//save xyz values
function saveconcs(filename, n1,n2,n3,steps, concs)

	fd=mopen(filename, 'a')
  mfprintf(fd, '%f %f %f %f\n', steps, n1,n2,n3)
	for i=1:n1
      for j=1:n2 
            for k=1:n3
            
                for is=1:nspec
                  mfprintf(fd, '%f ', concs(i,j,k,is));
                end
                mfprintf(fd,'\n');

            end
       end
	end
	
	mclose(fd)
endfunction

function gendxgen(directory,jobname,nsteps, n1,n2,n3,nspec)

  //write the form file
  filename=sprintf('%s.form',jobname);
  fd=mopen(filename, 'w');
  mfprintf(fd, '%d %d %d %d\n', nsteps, n1,n2,n3);
  mclose(fd);
  //write the general file for the form file
  filename=sprintf('../tmp/%s_form.general',jobname);
  fd=mopen(filename, 'w');
  
  mfprintf(fd,"file=%s/%s.form\n", directory, jobname);
  mfprintf(fd,"grid = 1\n");
  mfprintf(fd,"format = ascii\n");
  mfprintf(fd,"interleaving = record\n");
  mfprintf(fd,"majority = row\n");
  mfprintf(fd,"field = nsteps,nspec, nx, ny, nz\n");
  mfprintf(fd,"structure = scalar, scalar, scalar, scalar\n");
  mfprintf(fd,"type = int, int, int, int\n");
  mfprintf(fd,"dependency = positions, positions, positions, positions\n");
  mfprintf(fd,"positions = regular, 0, 1\n");
  mfprintf(fd,"end\n");
  
   mclose(fd);
  //write the general file for the data
    filename=sprintf('../tmp/%s.general',jobname);
        fd=mopen(filename, 'w');
        mfprintf(fd,"file=%s/%s.dat\n", directory, jobname);
        mfprintf(fd,"grid = %d x %d x %d\n",n1,n2,n3);
        mfprintf(fd,"format = ascii\n");
        mfprintf(fd,"interleaving = record\n");
        mfprintf(fd,"majority = row\n");
        mfprintf(fd,"header = lines 1\n");
        mfprintf(fd,"series= %d , 1, 1, separator= lines 1\n",nsteps);
        mfprintf(fd,"field = field0\n");
        mfprintf(fd,"structure = scalar\n");
        mfprintf(fd,"type = float\n");
        mfprintf(fd,"dependency = positions\n");
        mfprintf(fd,"positions = regular,regular,regular, 0, 1, 0, 1, 0, 1\n");
        mfprintf(fd,"end\n");  
        mclose(fd);



endfunction

function mgendxgen(directory,jobname,nsteps, n1,n2,n3,nspecies)

  for ispec=1:nspecies
  
  //write the form file
  filename=sprintf('%s_%d.form',jobname,ispec);
  fd=mopen(filename, 'w');
  mfprintf(fd, '%d %d %d %d\n', nsteps, n1,n2,n3);
  mclose(fd);
  //write the general file for the form file
  filename=sprintf('../tmp/%s_%d_form.general',jobname,ispec);
  fd=mopen(filename, 'w');
  
  mfprintf(fd,"file=%s/%s_%d.form\n", directory, jobname,ispec);
  mfprintf(fd,"grid = 1\n");
  mfprintf(fd,"format = ascii\n");
  mfprintf(fd,"interleaving = record\n");
  mfprintf(fd,"majority = row\n");
  mfprintf(fd,"field = nsteps, nx, ny, nz\n");
  mfprintf(fd,"structure = scalar, scalar, scalar, scalar\n");
  mfprintf(fd,"type = int, int, int, int\n");
  mfprintf(fd,"dependency = positions, positions, positions, positions\n");
  mfprintf(fd,"positions = regular, 0, 1\n");
  mfprintf(fd,"end\n");
  
   mclose(fd);
  //write the general file for the data
    filename=sprintf('../tmp/%s_%d.general',jobname,ispec);
        fd=mopen(filename, 'w');
        mfprintf(fd,"file=%s/%s_%d.dat\n", directory, jobname,ispec);
        mfprintf(fd,"grid = %d x %d x %d\n",n1,n2,n3);
        mfprintf(fd,"format = ascii\n");
        mfprintf(fd,"interleaving = record\n");
        mfprintf(fd,"majority = row\n");
        mfprintf(fd,"header = lines 1\n");
        mfprintf(fd,"series= %d , 1, 1, separator= lines 1\n",nsteps);
        mfprintf(fd,"field = field0\n");
        mfprintf(fd,"structure = scalar\n");
        mfprintf(fd,"type = float\n");
        mfprintf(fd,"dependency = positions\n");
        mfprintf(fd,"positions = regular,regular,regular, 0, 1, 0, 1, 0, 1\n");
        mfprintf(fd,"end\n");  
        mclose(fd);
      
  end
  //end looping over species



endfunction

//save each species in a separate file
function  savemconcs(srootfilename,step, n1,n2,n3,nspecies, concs)

   for is=1:nspecies
      sfilename=sprintf('%s_%d.dat', srootfilename, is);
      //sconcs=concs(1:n1,1:n2,1:n3,i);
      //printf("%f %f %f\n",sconcs);
      //saveconcs(sfilename,n1,n2,n3, sconcs);
     	fd=mopen(sfilename, 'a')
  mfprintf(fd, '%f %f %f %f\n', step, n1,n2,n3)
	for i=1:n1
      for j=1:n2 
            for k=1:n3
                mfprintf(fd, '%f ', concs(i,j,k,is));
            end
       end
      mfprintf(fd,'\n');
	end
	
	mclose(fd) 
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


