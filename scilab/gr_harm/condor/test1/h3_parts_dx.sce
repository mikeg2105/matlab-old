function [] = h3_parts_dx( iterations,nx,ny,nz,dx,dy,dz,par1,par2,vp,m,nparts,jobname )
//h3( iterations,nx,ny,nz,dx,dy,dz,par1,par2 )
//         nx,ny,nz  : grid sizes of the 3d cube.
//         dx,dy,dz  : grid spacings
//         iterations: the number of iterations to evolve
//         par1,par2 : Parameters for the initial data
//         par1 amplitude
//         par2 shape -2<shape<2
//     Main code: it does the evolution by calling the routines
//     to set the initial data at iteration 0 (H3expresso restriction)
//     and then calling the method (H3expresso only implements Macormack) 
//     and the boundaries at every time step. H3expresso does not
//     have I/O so no output routine is called. Instead, some minimal
//     information is given at every iteration.
//  [INCLUDES]  metric.h  declares all the grid and metric arrays.
//
//  [VARIABLES] The whole grid and metric structure is allocated here. 
//     See the documentation of the header file metric.h. 
//
//  [CALLED BY]  h3_drv.m
//  [CALLS  TO]  initial.m
//               information_info_header.m
//               method.m
//               boundaries.m


//Current iteration, time and time step
//      integer currentiter       
//      real time,dt 

      time= 0.;

//     We will use a fixed dt during the evolution. This dt
//     should be less than the maximum courant time step of dx/sqrt(3)
//     Note that we assume that the metric factor on the courant does
//     not play any role... this is true for the linearized waves.
      dt = 0.5*dx;
[x,y,z,r,psi,alp,cux,cuy,cuz,rg,uxx,uxy,uxz,uyy,uyz,uzz,gxx,gxy,gxz,gyy,gyz,gzz,qxx,qxy,qxz,qyy,qyz,qzz,dxuxx,dxuxy,dxuxz,dxuyy,dxuyz,dxuzz,dyuxx,dyuxy,dyuxz,dyuyy,dyuyz,dyuzz,dzuxx,dzuxy,dzuxz,dzuyy,dzuyz,dzuzz]=initial_parts(nx,ny,nz,dx,dy,dz,par1,par2,time,dt);

formfile=sprintf('%s.form',jobname);





fdform=mopen(formfile,'w');
  mfprintf(fdform, '%d %d %d %d\n',iterations, nx, ny,nz);
mclose(fdform);

outname(1)=sprintf('%s_gxx.dat',jobname);
//fdgxx=mopen(outname,'w');
outname(2)=sprintf('%s_gxy.dat',jobname);
//fdgxy=mopen(outname,'w');
outname(3)=sprintf('%s_gxz.dat',jobname);
//fdgxz=mopen(outname,'w');
outname(4)=sprintf('%s_gyy.dat',jobname);
//fdgyy=mopen(outname,'w');
outname(5)=sprintf('%s_gyz.dat',jobname);
//fdgyz=mopen(outname,'w');
outname(6)=sprintf('%s_gzz.dat',jobname);
//fdgzz=mopen(outname,'w');
outname(7)=sprintf('%s_qxx.dat',jobname);
//fdqxx=mopen(outname,'w');
outname(8)=sprintf('%s_qxy.dat',jobname);
//fdqxy=mopen(outname,'w');
outname(9)=sprintf('%s_qxz.dat',jobname);
//fdqxz=mopen(outname,'w');
outname(10)=sprintf('%s_qyy.dat',jobname);
//fdqyy=mopen(outname,'w');
outname(11)=sprintf('%s_qyz.dat',jobname);
//fdqyz=mopen(outname,'w');
outname(12)=sprintf('%s_qzz.dat',jobname);
//fdqzz=mopen(outname,'w');



omega=4*%pi/(dt*iterations);
rad=(nx+ny)/8;
currentiter=iterations;

for ifile=1:12
fd=mopen(outname(ifile),'w');
mfprintf(fd,'%d\n',currentiter);



for i=1:nx
    for j=1:ny
        for k=1:nz
        
                if ifile==1 then
                     mfprintf(fd,'%f ',gxx(i,j,k));
                elseif ifile==2 then
                     mfprintf(fd,'%f ',gxy(i,j,k));
                elseif ifile==3 then     
                     mfprintf(fd,'%f ',gxz(i,j,k));
                elseif ifile==4 then     
                     mfprintf(fd,'%f ',gyy(i,j,k));
                elseif ifile==5 then     
                     mfprintf(fd,'%f ',gyz(i,j,k));
                elseif ifile==6 then     
                     mfprintf(fd,'%f ',gzz(i,j,k));
                elseif ifile==7 then     
                     mfprintf(fd,'%f ',qxx(i,j,k));
                elseif ifile==8 then     
                     mfprintf(fd,'%f ',qxy(i,j,k));
                elseif ifile==9 then    
                     mfprintf(fd,'%f ',qxz(i,j,k));
                elseif ifile==10 then
                     mfprintf(fd,'%f ',qyy(i,j,k));
                elseif ifile==11 then     
                     mfprintf(fd,'%f ',qyz(i,j,k));
                elseif ifile==12 then     
                     mfprintf(fd,'%f ',qzz(i,j,k));
                end
        end
        mfprintf(fd,'\n');
 
        
    end
end
mclose(fd);
end //looping over outputfiles

outnamem=sprintf('%s_initial.mat',jobname);
save(outnamem);
for currentiter=1:iterations

//        The evolved level will be at the new time
         time = time+dt;
         vx=vp*cos(omega*time);
         vy=vp*sin(omega*time);
         vz=0;
         ppx=rad*cos(omega*time);
         ppy=rad*sin(omega*time);
         ppz=nz/2;
         
         [txx, txy, txz, tyy, tyz, tzz]=enmomt_parts(nx,ny,nz,dx,dy,dz,nparts, x, y, z,ppx, ppy, ppz, vx, vy, vz, m)
//        H3expresso: only 1 method (Macormack)
         [alp,cux,cuy,cuz,...
             uxx,uxy,uxz,uyy,uyz,uzz,...
             qxx,qxy,qxz,qyy,qyz,qzz,...
             dxuxx,dxuxy,dxuxz,dxuyy,dxuyz,dxuzz,...
             dyuxx,dyuxy,dyuxz,dyuyy,dyuyz,dyuzz,...
             dzuxx,dzuxy,dzuxz,dzuyy,dzuyz,dzuzz]...
             =method_parts(nx,ny,nz,dt,dx,dy,dz,x,y,z,r,...
             txx, txy, txz, tyy, tyz, tzz,...
             psi,alp,cux,cuy,cuz,rg,uxx,uxy,uxz,uyy,uyz,uzz,...
             gxx,gxy,gxz,gyy,gyz,gzz,...
             qxx,qxy,qxz,qyy,qyz,qzz,...
             dxuxx,dxuxy,dxuxz,dxuyy,dxuyz,dxuzz,...
             dyuxx,dyuxy,dyuxz,dyuyy,dyuyz,dyuzz,...
             dzuxx,dzuxy,dzuxz,dzuyy,dzuyz,dzuzz);

//        Boundary conditions
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
         
         //write some data to ouput
         outnamem=sprintf('%s_%d.mat',jobname, currentiter);
         
         save(outnamem);
 for ifile=1:12
fd=mopen(outname(ifile),'a');
mfprintf(fd,'%d\n',currentiter);



for i=1:nx
    for j=1:ny
        for k=1:nz
        
                if ifile==1 then
                     mfprintf(fd,'%f ',gxx(i,j,k));
                elseif ifile==2 then
                     mfprintf(fd,'%f ',gxy(i,j,k));
                elseif ifile==3 then     
                     mfprintf(fd,'%f ',gxz(i,j,k));
                elseif ifile==4 then     
                     mfprintf(fd,'%f ',gyy(i,j,k));
                elseif ifile==5 then     
                     mfprintf(fd,'%f ',gyz(i,j,k));
                elseif ifile==6 then     
                     mfprintf(fd,'%f ',gzz(i,j,k));
                elseif ifile==7 then     
                     mfprintf(fd,'%f ',qxx(i,j,k));
                elseif ifile==8 then     
                     mfprintf(fd,'%f ',qxy(i,j,k));
                elseif ifile==9 then    
                     mfprintf(fd,'%f ',qxz(i,j,k));
                elseif ifile==10 then
                     mfprintf(fd,'%f ',qyy(i,j,k));
                elseif ifile==11 then     
                     mfprintf(fd,'%f ',qyz(i,j,k));
                elseif ifile==12 then     
                     mfprintf(fd,'%f ',qzz(i,j,k));
                end
        end
        mfprintf(fd,'\n');
 
        
    end
end
mclose(fd);
end //looping over outputfiles
end


endfunction


     
