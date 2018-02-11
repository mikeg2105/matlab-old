function [alp,cux,cuy,cuz,rg,...
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
             )
%[alp,cux,cuy,cuz,rg,...
%             uxx,uxy,uxz,uyy,uyz,uzz,...
%             gxx,gxy,gxz,gyy,gyz,gzz,...
%             qxx,qxy,qxz,qyy,qyz,qzz,...
%             dxuxx,dxuxy,dxuxz,dxuyy,dxuyz,dxuzz,...
%             dyuxx,dyuxy,dyuxz,dyuyy,dyuyz,dyuzz,...
%             dzuxx,dzuxy,dzuxz,dzuyy,dzuyz,dzuzz...
%             ]=boundaries(...
%             nx,ny,nz,time,dt,dx,dy,dz,...
%             x,y,z,r,psi,...
%             alp,cux,cuy,cuz,rg,...
%             uxx,uxy,uxz,uyy,uyz,uzz,...
%             gxx,gxy,gxz,gyy,gyz,gzz,...
%             qxx,qxy,qxz,qyy,qyz,qzz,...
%             dxuxx,dxuxy,dxuxz,dxuyy,dxuyz,dxuzz,...
%             dyuxx,dyuxy,dyuxz,dyuyy,dyuyz,dyuzz,...
%             dzuxx,dzuxy,dzuxz,dzuyy,dzuyz,dzuzz...
%             )

%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
%
% [FILE]       boundaries.cpp
%
% [VERSION]    H3expresso  (c) 1995 Joan Masso, NCSA & UIB
%
% [PURPOSE]    Routines for the boundary conditions.
%
% [ROUTINES]   Boundaries
%              Onebound
%
% [COMMENTS]   H3expresso has VERY limited boundary control.
%
%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

%==============================================================================
%
%  [ROUTINE NAME] Boundaries
%  [AUTHOR] Joan Masso, NCSA & UIB
%
%  [PURPOSE] Provide boundary conditions to all the metric variables that
%            have been evolved in the interior. H3expresso simplifies the
%            proccess by enforcing the same boundary condition on all
%            quantities thru a call to Onebound for each variable.
%
%  [ARGUMENTS] 
%     [INPUT]
%        nx,ny,nz   : grid sizes of the 3d cube.
%     [INPUT/OUTPUT] All the metric structure. Only the boundaries 
%                       of the evolved quantities are modified.
%  [INCLUDES]  metric.h  declares all the grid and metric arrays.
%
%  [VARIABLES]  ibound: hardwired choice for periodic or flat 
%                            Boundary conditions.
% 
%  [CALLED BY]  H3
%
%  [CALLS TO]   Onebound
%               invert 
%
%  [WARNINGS] The boundaries are NOT applied to the covariant 
%             down metric since it is NOT one of the evolved
%             quantities. Therefore, a final call to invert recomputes
%             all the down metric.
%
%             Note also that the grid vectors and time information
%             are passed but not used. As more sophisticated boundaries
%             are implemented, these quantities are necessary... voila.
%
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

%c     H3expresso: Hard-wired boundary selection: see Onebound
      ibound = 1;

       alp=onebound(ibound,nx,ny,nz, alp);
      
       uxx=onebound(ibound,nx,ny,nz, uxx);
       uxy=onebound(ibound,nx,ny,nz, uxy);
       uxz=onebound(ibound,nx,ny,nz, uxz);
       uyy=onebound(ibound,nx,ny,nz, uyy);
       uyz=onebound(ibound,nx,ny,nz, uyz);
       uzz=onebound(ibound,nx,ny,nz, uzz);

       cux=onebound(ibound,nx,ny,nz, cux);
       cuy=onebound(ibound,nx,ny,nz, cuy);
       cuz=onebound(ibound,nx,ny,nz, cuz);
      
       qxx=onebound(ibound,nx,ny,nz, qxx);
       qxy=onebound(ibound,nx,ny,nz, qxy);
       qxz=onebound(ibound,nx,ny,nz, qxz);
       qyy=onebound(ibound,nx,ny,nz, qyy);
       qyz=onebound(ibound,nx,ny,nz, qyz);
       qzz=onebound(ibound,nx,ny,nz, qzz);
      
       dxuxx=onebound(ibound,nx,ny,nz, dxuxx);
       dxuxy=onebound(ibound,nx,ny,nz, dxuxy);
       dxuxz=onebound(ibound,nx,ny,nz, dxuxz);
       dxuyy=onebound(ibound,nx,ny,nz, dxuyy);
       dxuyz=onebound(ibound,nx,ny,nz, dxuyz);  
       dxuzz=onebound(ibound,nx,ny,nz, dxuzz);
      
       dyuxx=onebound(ibound,nx,ny,nz, dyuxx);
       dyuxy=onebound(ibound,nx,ny,nz, dyuxy);
       dyuxz=onebound(ibound,nx,ny,nz, dyuxz);
       dyuyy=onebound(ibound,nx,ny,nz, dyuyy);
       dyuyz=onebound(ibound,nx,ny,nz, dyuyz);
       dyuzz=onebound(ibound,nx,ny,nz, dyuzz);
      
       dzuxx=onebound(ibound,nx,ny,nz, dzuxx);
       dzuxy=onebound(ibound,nx,ny,nz, dzuxy);
       dzuxz=onebound(ibound,nx,ny,nz, dzuxz);
       dzuyy=onebound(ibound,nx,ny,nz, dzuyy);
       dzuyz=onebound(ibound,nx,ny,nz, dzuyz);
       dzuzz=onebound(ibound,nx,ny,nz, dzuzz);

%c     Compute covariant metric
       [gxx,gxy,gxz,gyy,gyz,gzz]=invert(nx,ny,nz,1,uxx,uxy,uxz,uyy,uyz,uzz);


%endfunction


