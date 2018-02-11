
nx=40;  
ny=40;  
nz=40;

//nx=22;  
//ny=22;  
//nz=22;

deltax=6371*10^3/2;
deltay=deltax;
deltaz=deltax;
//inx=-deltax*nx;
inx=0;
iny=inx;
inz=iny;

b=zeros(3,nx,ny,nz);
fd=mopen('out/j3/jobformplotbfieldtest_1.out','r');


l=mfscanf(-1,u,'%e %e')  

mclose(u); //close the file

for i=1:7;tempstr=mfscanf(fd, '%s\n');end

for i1=-nx/2:nx/2
  //disp(i1);
  for i2=-ny/2:ny/2
    for i3=-nz/2:nz/2
      x=inx+i1*deltax;
      y=iny+i2*deltay;
      z=inz+i3*deltaz;
 
      r(1,1)=x;
      r(2,1)=y;
      r(3,1)=z;
      //read the file line by line
      //[n,a,b]=mfscanf(u,'%e %e')
      [n,x,y,z,bf1,bf2,bf3]=mfscanf(fd, '%f %f %f %f %f %f\n');
      

      ii1=1+i1+nx/2;
      ii2=1+i2+ny/2;
      ii3=1+i3+nz/2;
      b(1,ii1,ii2,ii3)=bf1;
      b(2,ii1,ii2,ii3)=bf2;
      b(3,ii1,ii2,ii3)=bf3;
    end
  end
end
mclose(fd);

