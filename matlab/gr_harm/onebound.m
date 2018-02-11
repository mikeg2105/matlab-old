function [ var ] = onebound(ibound,nx,ny,nz,var )
%[ var ] = onebound(ibound,nx,ny,nz,var )
%  Simple boundary conditions on one variable
%==============================================================================
%
%  [ROUTINE NAME] Onebound
%  [AUTHOR] Joan Masso, NCSA & UIB
%
%  [PURPOSE] Simple boundary conditions on one variable
%
%  [ARGUMENTS] 
%     [INPUT]
%        ibound     : FLag controlling the boundary applied
%                        1 = Periodic 
%                        2 = flat: copying the neighbouring plane.
%        nx,ny,nz   : grid sizes of the 3d cube.
%     [INPUT/OUTPUT] 
%        var        :  The 3d variable whose interior is used to
%                      compute the exterior boundaries.
% 
%  [CALLED BY]  Boundaries
%
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%     Periodic Boundaries.......................................
      if ibound==1
         var(1,:,:) = var(nx-1,:,:);
         var(:,1,:) = var(:,ny-1,:);
         var(:,:,1) = var(:,:,nz-1);
         
         var(nx,:,:) = var(2,:,:);
         var(:,ny,:) = var(:,2,:);
         var(:,:,nz) = var(:,:,2);
      end
%c     Flat Boundaries (zero order extrapolation)................
      if ibound==2
         var(1,:,:) = var(2,:,:);
         var(:,1,:) = var(:,2,:);
         var(:,:,1) = var(:,:,2);
         
         var(nx,:,:) = var(nx-1,:,:);
         var(:,ny,:) = var(:,ny-1,:);
         var(:,:,nz) = var(:,:,nz-1);
      end


%endfunction