//General utility functions for diffusion modelling
//function to create an n1xn2xn3 array



function gendxgen(directory,jobname,nsteps, n1,n2,n3)

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
  mfprintf(fd,"field = nsteps, nx, ny, nz\n");
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
