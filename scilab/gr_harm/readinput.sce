function [ iterations,nx,ny,nz,dx,dy,dz,par1,par2 ] = readinput(  )
%readinput returns  iterations,nx,ny,nz,dx,dy,dz,par1,par2
%  
%nx,ny,nz  : grid sizes of the 3d cube.
%*        dx,dy,dz  : grid spacings
%*        iterations: the number of iterations to evolve
%*        par1,par2 : Parameters for the initial data
%         par1 amplitude
%         par2 shape -2<shape<2

    iterations=50;
    nx=80;
    ny=80;
    nz=80;
    dx=0.01;
    dy=0.01;
    dz=0.01;
    par1=15;  %amplitude
    par2=1;   %shape -2<shape<2