function [dxuxx,dyuxx,dzuxx,...
          dxuxy,dyuxy,dzuxy,...
          dxuxz,dyuxz,dzuxz,...
          dxuyy,dyuyy,dzuyy,...
          dxuyz,dyuyz,dzuyz,...
          dxuzz,dyuzz,dzuzz]=centralderiv(...
          nx,ny,nz,...
          dx,dy,dz,...
          uxx,uxy,uxz,uyy,uyz,uzz)
%[dxuxx,dyuxx,dzuxx,...
%          dxuxy,dyuxy,dzuxy,...
%          dxuxz,dyuxz,dzuxz,...
%          dxuyy,dyuyy,dzuyy,...
%          dxuyz,dyuyz,dzuyz,...
%          dxuzz,dyuzz,dzuzz]=centralderiv(...
%          nx,ny,nz,...
%          dx,dy,dz,...
%          uxx,uxy,uxz,uyy,uyz,uzz
%==============================================================================
%
%  [ROUTINE NAME] Centralderiv
%  [AUTHOR] Joan Masso, NCSA & UIB
% 
%  [PURPOSE] Compute the derivatives of the metric tensor
%            with a central finite differencing scheme that 
%            assumes a regular grid spacing. The finite
%            differencing is implemented using triplet notation.
%
%            At the boundaries, the derivatives are computed
%            by linear extrapolation of the interior derivatives.
%
%  [ARGUMENTS] 
%     [INPUT]
%        nx,ny,nz   : grid sizes of the 3d cube.
%        dx,dy,dz   : grid spacing: regular grid assumed.
%        uxx,uxy,...: Metric tensor
%     [OUTPUT]
%        dxuxx,.....: All derivatives of the metric tensor.
% 
%  [CALLED BY]  Initial
%
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
       dzuxx=zeros(nx,ny,nz);
       dzuxy=zeros(nx,ny,nz);
       dzuxz=zeros(nx,ny,nz);
       dzuyy=zeros(nx,ny,nz);
       dzuyz=zeros(nx,ny,nz);
       dzuzz=zeros(nx,ny,nz); 


%     X direction
%     Centered differencing in the interior.
      dxuxx(2:nx-1,:,:) = ( uxx(3:nx,:,:) - uxx(1:nx-2,:,:) )./2./dx;
      dxuxy(2:nx-1,:,:) = ( uxy(3:nx,:,:) - uxy(1:nx-2,:,:) )./2./dx;
      dxuxz(2:nx-1,:,:) = ( uxz(3:nx,:,:) - uxz(1:nx-2,:,:) )./2./dx;
      dxuyy(2:nx-1,:,:) = ( uyy(3:nx,:,:) - uyy(1:nx-2,:,:) )./2./dx;
      dxuyz(2:nx-1,:,:) = ( uyz(3:nx,:,:) - uyz(1:nx-2,:,:) )./2./dx;
      dxuzz(2:nx-1,:,:) = ( uzz(3:nx,:,:) - uzz(1:nx-2,:,:) )./2./dx;

%     Linear extrapolation on a regular grid is trivial... at both ends.
      dxuxx(1,:,:) = 2.*dxuxx(2,:,:) - dxuxx(3,:,:);
      dxuxy(1,:,:) = 2.*dxuxy(2,:,:) - dxuxy(3,:,:);
      dxuxz(1,:,:) = 2.*dxuxz(2,:,:) - dxuxz(3,:,:);
      dxuyy(1,:,:) = 2.*dxuyy(2,:,:) - dxuyy(3,:,:);
      dxuyz(1,:,:) = 2.*dxuyz(2,:,:) - dxuyz(3,:,:);
      dxuzz(1,:,:) = 2.*dxuzz(2,:,:) - dxuzz(3,:,:);             
      dxuxx(nx,:,:) = 2.*dxuxx(nx-1,:,:) - dxuxx(nx-2,:,:);
      dxuxy(nx,:,:) = 2.*dxuxy(nx-1,:,:) - dxuxy(nx-2,:,:);
      dxuxz(nx,:,:) = 2.*dxuxz(nx-1,:,:) - dxuxz(nx-2,:,:);
      dxuyy(nx,:,:) = 2.*dxuyy(nx-1,:,:) - dxuyy(nx-2,:,:);
      dxuyz(nx,:,:) = 2.*dxuyz(nx-1,:,:) - dxuyz(nx-2,:,:);
      dxuzz(nx,:,:) = 2.*dxuzz(nx-1,:,:) - dxuzz(nx-2,:,:);             

%     Y direction
      dyuxx(:,2:ny-1,:) = ( uxx(:,3:ny,:) - uxx(:,1:ny-2,:) )./2./dy;
      dyuxy(:,2:ny-1,:) = ( uxy(:,3:ny,:) - uxy(:,1:ny-2,:) )./2./dy;
      dyuxz(:,2:ny-1,:) = ( uxz(:,3:ny,:) - uxz(:,1:ny-2,:) )./2./dy;
      dyuyy(:,2:ny-1,:) = ( uyy(:,3:ny,:) - uyy(:,1:ny-2,:) )./2./dy;
      dyuyz(:,2:ny-1,:) = ( uyz(:,3:ny,:) - uyz(:,1:ny-2,:) )./2./dy;
      dyuzz(:,2:ny-1,:) = ( uzz(:,3:ny,:) - uzz(:,1:ny-2,:) )./2./dy;
      dyuxx(:,1,:) = 2.*dyuxx(:,2,:) - dyuxx(:,3,:);
      dyuxy(:,1,:) = 2.*dyuxy(:,2,:) - dyuxy(:,3,:);
      dyuxz(:,1,:) = 2.*dyuxz(:,2,:) - dyuxz(:,3,:);
      dyuyy(:,1,:) = 2.*dyuyy(:,2,:) - dyuyy(:,3,:);
      dyuyz(:,1,:) = 2.*dyuyz(:,2,:) - dyuyz(:,3,:);
      dyuzz(:,1,:) = 2.*dyuzz(:,2,:) - dyuzz(:,3,:);       
      dyuxx(:,ny,:) = 2.*dyuxx(:,ny-1,:) - dyuxx(:,ny-2,:);
      dyuxy(:,ny,:) = 2.*dyuxy(:,ny-1,:) - dyuxy(:,ny-2,:);
      dyuxz(:,ny,:) = 2.*dyuxz(:,ny-1,:) - dyuxz(:,ny-2,:);
      dyuyy(:,ny,:) = 2.*dyuyy(:,ny-1,:) - dyuyy(:,ny-2,:);
      dyuyz(:,ny,:) = 2.*dyuyz(:,ny-1,:) - dyuyz(:,ny-2,:);
      dyuzz(:,ny,:) = 2.*dyuzz(:,ny-1,:) - dyuzz(:,ny-2,:);       

%     Z direction
      dzuxx(:,:,2:nz-1) = ( uxx(:,:,3:nz) - uxx(:,:,1:nz-2) )./2./dz;
      dzuxy(:,:,2:nz-1) = ( uxy(:,:,3:nz) - uxy(:,:,1:nz-2) )./2./dz;
      dzuxz(:,:,2:nz-1) = ( uxz(:,:,3:nz) - uxz(:,:,1:nz-2) )./2./dz;
      dzuyy(:,:,2:nz-1) = ( uyy(:,:,3:nz) - uyy(:,:,1:nz-2) )./2./dz;
      dzuyz(:,:,2:nz-1) = ( uyz(:,:,3:nz) - uyz(:,:,1:nz-2) )./2./dz;
      dzuzz(:,:,2:nz-1) = ( uzz(:,:,3:nz) - uzz(:,:,1:nz-2) )./2./dz;
      dzuxx(:,:,1) = 2.*dzuxx(:,:,2) - dzuxx(:,:,3);
      dzuxy(:,:,1) = 2.*dzuxy(:,:,2) - dzuxy(:,:,3);
      dzuxz(:,:,1) = 2.*dzuxz(:,:,2) - dzuxz(:,:,3);
      dzuyy(:,:,1) = 2.*dzuyy(:,:,2) - dzuyy(:,:,3);
      dzuyz(:,:,1) = 2.*dzuyz(:,:,2) - dzuyz(:,:,3);
      dzuzz(:,:,1) = 2.*dzuzz(:,:,2) - dzuzz(:,:,3);       
      dzuxx(:,:,nz) = 2.*dzuxx(:,:,nz-1) - dzuxx(:,:,nz-2);
      dzuxy(:,:,nz) = 2.*dzuxy(:,:,nz-1) - dzuxy(:,:,nz-2);
      dzuxz(:,:,nz) = 2.*dzuxz(:,:,nz-1) - dzuxz(:,:,nz-2);
      dzuyy(:,:,nz) = 2.*dzuyy(:,:,nz-1) - dzuyy(:,:,nz-2);
      dzuyz(:,:,nz) = 2.*dzuyz(:,:,nz-1) - dzuyz(:,:,nz-2);
      dzuzz(:,:,nz) = 2.*dzuzz(:,:,nz-1) - dzuzz(:,:,nz-2);       


%endfunction


