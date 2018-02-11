function b=readmag(filepath)

//fd=mopen('out/jobmkgt9.out','r');

fd=mopen(filepath,'r');
//mymat=rand(1,6);
nx=39;
ny=39;
nz=39;
 nod=mfscanf(fd,'%s\n');
 nod=mfscanf(fd,'%s\n');
 nod=mfscanf(fd,'%s %d %d %d\n');
//nx=mfscanf(fd,'%s %d');
//ny=mfscanf(fd,' %d');
//nz=mfscanf(fd,' %d\n');
nod=mfscanf(fd,'%s %f\n');
nod=mfscanf(fd,'%s %f\n');
nod=mfscanf(fd,'%s %f\n');
nod=mfscanf(fd,'%s %d\n');
nod=mfscanf(fd,'%s %f\n');
nod=mfscanf(fd,'%s %f\n');
nod=mfscanf(fd,'%s %f\n');
nod=mfscanf(fd,'%s %d\n');
nod=mfscanf(fd,'%s %f\n');
nod=mfscanf(fd,'%s %f\n');
nod=mfscanf(fd,'%s %d\n');
nod=mfscanf(fd,'%s %f\n');
nod=mfscanf(fd,'%s %d\n');
nod=mfscanf(fd,'%s %f\n');


b=zeros(3,nx,ny,nz);


for i=1:nx
  for j=1:ny
    for k=1:nz
      mymat=mfscanf(fd,'%f %f %f %f %f %f\n');
      b(1,i,j,k)=mymat(1,4);
      b(2,i,j,k)=mymat(1,5);
      b(3,i,j,k)=mymat(1,6);   
    end
  end
end

mclose(fd);

endfunction
