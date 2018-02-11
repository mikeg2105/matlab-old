function [] = h3( iterations,nx,ny,nz,dx,dy,dz,par1,par2,jobname )
%h3( iterations,nx,ny,nz,dx,dy,dz,par1,par2 )
%         nx,ny,nz  : grid sizes of the 3d cube.
%         dx,dy,dz  : grid spacings
%         iterations: the number of iterations to evolve
%         par1,par2 : Parameters for the initial data
%         par1 amplitude
%         par2 shape -2<shape<2
%     Main code: it does the evolution by calling the routines
%     to set the initial data at iteration 0 (H3expresso restriction)
%     and then calling the method (H3expresso only implements Macormack) 
%     and the boundaries at every time step. H3expresso does not
%     have I/O so no output routine is called. Instead, some minimal
%     information is given at every iteration.
%  [INCLUDES]  metric.h  declares all the grid and metric arrays.
%
%  [VARIABLES] The whole grid and metric structure is allocated here. 
%     See the documentation of the header file metric.h. 
%
%  [CALLED BY]  h3_drv.m
%  [CALLS  TO]  initial.m
%               information_info_header.m
%               method.m
%               boundaries.m


%Current iteration, time and time step
%      integer currentiter       
%      real time,dt 

      time= 0.;

%     We will use a fixed dt during the evolution. This dt
%     should be less than the maximum courant time step of dx/sqrt(3)
%     Note that we assume that the metric factor on the courant does
%     not play any role... this is true for the linearized waves.
      dt = 0.5*dx;
[x,y,z,r,psi,alp,cux,cuy,cuz,rg,uxx,uxy,uxz,uyy,uyz,uzz,gxx,gxy,gxz,gyy,gyz,gzz,qxx,qxy,qxz,qyy,qyz,qzz,dxuxx,dxuxy,dxuxz,dxuyy,dxuyz,dxuzz,dyuxx,dyuxy,dyuxz,dyuyy,dyuyz,dyuzz,dzuxx,dzuxy,dzuxz,dzuyy,dzuyz,dzuzz]=initial(nx,ny,nz,dx,dy,dz,par1,par2,time,dt);

formfile=sprintf('out/%s.form',jobname);





fdform=fopen(formfile,'w');
  fprintf(fdform, '%d %d %d %d\n',iterations, nx, ny,nz);
fclose(fdform);

outname=sprintf('out/%s_gxx.dat',jobname);
fdgxx=fopen(outname,'w');
outname=sprintf('out/%s_gxy.dat',jobname);
fdgxy=fopen(outname,'w');
outname=sprintf('out/%s_gxz.dat',jobname);
fdgxz=fopen(outname,'w');
outname=sprintf('out/%s_gyy.dat',jobname);
fdgyy=fopen(outname,'w');
outname=sprintf('out/%s_gyz.dat',jobname);
fdgyz=fopen(outname,'w');
outname=sprintf('out/%s_gzz.dat',jobname);
fdgzz=fopen(outname,'w');
outname=sprintf('out/%s_qxx.dat',jobname);
fdqxx=fopen(outname,'w');
outname=sprintf('out/%s_qxy.dat',jobname);
fdqxy=fopen(outname,'w');
outname=sprintf('out/%s_qxz.dat',jobname);
fdqxz=fopen(outname,'w');
outname=sprintf('out/%s_qyy.dat',jobname);
fdqyy=fopen(outname,'w');
outname=sprintf('out/%s_qyz.dat',jobname);
fdqyz=fopen(outname,'w');
outname=sprintf('out/%s_qzz.dat',jobname);
fdqzz=fopen(outname,'w');
currentiter=iterations;
fprintf(fdgxx,'%d\n',currentiter);
fprintf(fdgxy,'%d\n',currentiter);
fprintf(fdgxz,'%d\n',currentiter);
fprintf(fdgyy,'%d\n',currentiter);
fprintf(fdgyz,'%d\n',currentiter);
fprintf(fdgzz,'%d\n',currentiter);
fprintf(fdqxx,'%d\n',currentiter);
fprintf(fdqxy,'%d\n',currentiter);
fprintf(fdqxz,'%d\n',currentiter);
fprintf(fdqyy,'%d\n',currentiter);
fprintf(fdqyz,'%d\n',currentiter);
fprintf(fdqzz,'%d\n',currentiter);   


for i=1:nx
    for j=1:ny
        for k=1:nz
                     fprintf(fdgxx,'%f ',gxx(i,j,k));
                     fprintf(fdgxy,'%f ',gxy(i,j,k));
                     fprintf(fdgxz,'%f ',gxz(i,j,k));
                     fprintf(fdgyy,'%f ',gyy(i,j,k));
                     fprintf(fdgyz,'%f ',gyz(i,j,k));
                     fprintf(fdgzz,'%f ',gzz(i,j,k));
                     fprintf(fdqxx,'%f ',qxx(i,j,k));
                     fprintf(fdqxy,'%f ',qxy(i,j,k));
                     fprintf(fdqxz,'%f ',qxz(i,j,k));
                     fprintf(fdqyy,'%f ',qyy(i,j,k));
                     fprintf(fdqyz,'%f ',qyz(i,j,k));
                     fprintf(fdqzz,'%f ',qzz(i,j,k));
        end
        fprintf(fdgxx,'\n');
        fprintf(fdgxy,'\n');
        fprintf(fdgxz,'\n');
        fprintf(fdgyy,'\n');
        fprintf(fdgyz,'\n');
        fprintf(fdgzz,'\n');
        fprintf(fdqxx,'\n');
        fprintf(fdqxy,'\n');
        fprintf(fdqxz,'\n');
        fprintf(fdqyy,'\n');
        fprintf(fdqyz,'\n');
        fprintf(fdqzz,'\n');        
        
    end
end

outname=sprintf('out/%s_initial.mat',jobname);
save(outname);
for currentiter=1:iterations

%        The evolved level will be at the new time
         time = time+dt;
         
%        H3expresso: only 1 method (Macormack)
         [alp,cux,cuy,cuz,...
             uxx,uxy,uxz,uyy,uyz,uzz,...
             qxx,qxy,qxz,qyy,qyz,qzz,...
             dxuxx,dxuxy,dxuxz,dxuyy,dxuyz,dxuzz,...
             dyuxx,dyuxy,dyuxz,dyuyy,dyuyz,dyuzz,...
             dzuxx,dzuxy,dzuxz,dzuyy,dzuyz,dzuzz]...
             =method(nx,ny,nz,dt,dx,dy,dz,x,y,z,r,...
             psi,alp,cux,cuy,cuz,rg,uxx,uxy,uxz,uyy,uyz,uzz,...
             gxx,gxy,gxz,gyy,gyz,gzz,...
             qxx,qxy,qxz,qyy,qyz,qzz,...
             dxuxx,dxuxy,dxuxz,dxuyy,dxuyz,dxuzz,...
             dyuxx,dyuxy,dyuxz,dyuyy,dyuyz,dyuzz,...
             dzuxx,dzuxy,dzuxz,dzuyy,dzuyz,dzuzz);

%        Boundary conditions
         [alp,cux,cuy,cuz,rg,...
             uxx,uxy,uxz,uyy,uyz,uzz,...
             gxx,gxy,gxz,gyy,gyz,gzz,...
             qxx,qxy,qxz,qyy,qyz,qzz,...
             dxuxx,dxuxy,dxuxz,dxuyy,dxuyz,dxuzz,...
             dyuxx,dyuxy,dyuxz,dyuyy,dyuyz,dyuzz,...
             dzuxx,dzuxy,dzuxz,dzuyy,dzuyz,dzuzz...
             ]=boundaries(...
             nx,ny,nz,time,dt,dx,dy,dz,...
             x,y,z,r,psi,...
             alp,cux,cuy,cuz,rg,...
             uxx,uxy,uxz,uyy,uyz,uzz,...
             gxx,gxy,gxz,gyy,gyz,gzz,...
             qxx,qxy,qxz,qyy,qyz,qzz,...
             dxuxx,dxuxy,dxuxz,dxuyy,dxuyz,dxuzz,...
             dyuxx,dyuxy,dyuxz,dyuyy,dyuyz,dyuzz,...
             dzuxx,dzuxy,dzuxz,dzuyy,dzuyz,dzuzz...
             );        
         
         %write some data to ouput
         outname=sprintf('out/%s_%d.mat',jobname, currentiter);
         
         save(outname);
        fprintf(fdgxx,'%d\n',currentiter);
        fprintf(fdgxy,'%d\n',currentiter);
        fprintf(fdgxz,'%d\n',currentiter);
        fprintf(fdgyy,'%d\n',currentiter);
        fprintf(fdgyz,'%d\n',currentiter);
        fprintf(fdgzz,'%d\n',currentiter);
        fprintf(fdqxx,'%d\n',currentiter);
        fprintf(fdqxy,'%d\n',currentiter);
        fprintf(fdqxz,'%d\n',currentiter);
        fprintf(fdqyy,'%d\n',currentiter);
        fprintf(fdqyz,'%d\n',currentiter);
        fprintf(fdqzz,'%d\n',currentiter); 
        
         for i=1:nx
            for j=1:ny
                for k=1:nz
                    
                     fprintf(fdgxx,'%f ',gxx(i,j,k));
                     fprintf(fdgxy,'%f ',gxy(i,j,k));
                     fprintf(fdgxz,'%f ',gxz(i,j,k));
                     fprintf(fdgyy,'%f ',gyy(i,j,k));
                     fprintf(fdgyz,'%f ',gyz(i,j,k));
                     fprintf(fdgzz,'%f ',gzz(i,j,k));
                     fprintf(fdqxx,'%f ',qxx(i,j,k));
                     fprintf(fdqxy,'%f ',qxy(i,j,k));
                     fprintf(fdqxz,'%f ',qxz(i,j,k));
                     fprintf(fdqyy,'%f ',qyy(i,j,k));
                     fprintf(fdqyz,'%f ',qyz(i,j,k));
                     fprintf(fdqzz,'%f ',qzz(i,j,k));
        end
        fprintf(fdgxx,'\n');
        fprintf(fdgxy,'\n');
        fprintf(fdgxz,'\n');
        fprintf(fdgyy,'\n');
        fprintf(fdgyz,'\n');
        fprintf(fdgzz,'\n');
        fprintf(fdqxx,'\n');
        fprintf(fdqxy,'\n');
        fprintf(fdqxz,'\n');
        fprintf(fdqyy,'\n');
        fprintf(fdqyz,'\n');
        fprintf(fdqzz,'\n');    
            end
        end
end
fclose(fdgxx);
fclose(fdgxy);
fclose(fdgxz);
fclose(fdgyy);
fclose(fdgyz);
fclose(fdgzz);
fclose(fdqxx);
fclose(fdqxy);
fclose(fdqxz);
fclose(fdqyy);
fclose(fdqyz);
fclose(fdqzz);

     
