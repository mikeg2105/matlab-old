*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
*
* [FILE]       boundaries.cpp
*
* [VERSION]    H3expresso  (c) 1995 Joan Masso, NCSA & UIB
*
* [PURPOSE]    Routines for the boundary conditions.
*
* [ROUTINES]   Boundaries
*              Onebound
*
* [COMMENTS]   H3expresso has VERY limited boundary control.
*
*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

*==============================================================================
*
*  [ROUTINE NAME] Boundaries
*  [AUTHOR] Joan Masso, NCSA & UIB
*
*  [PURPOSE] Provide boundary conditions to all the metric variables that
*            have been evolved in the interior. H3expresso simplifies the
*            proccess by enforcing the same boundary condition on all
*            quantities thru a call to Onebound for each variable.
*
*  [ARGUMENTS] 
*     [INPUT]
*        nx,ny,nz   : grid sizes of the 3d cube.
*     [INPUT/OUTPUT] All the metric structure. Only the boundaries 
*                       of the evolved quantities are modified.
*  [INCLUDES]  metric.h  declares all the grid and metric arrays.
*
*  [VARIABLES]  ibound: hardwired choice for periodic or flat 
*                            Boundary conditions.
* 
*  [CALLED BY]  H3
*
*  [CALLS TO]   Onebound
*               invert 
*
*  [WARNINGS] The boundaries are NOT applied to the covariant 
*             down metric since it is NOT one of the evolved
*             quantities. Therefore, a final call to invert recomputes
*             all the down metric.
*
*             Note also that the grid vectors and time information
*             are passed but not used. As more sophisticated boundaries
*             are implemented, these quantities are necessary... voila.
*
*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


      subroutine Boundaries(
     &     nx,ny,nz,time,dt,dx,dy,dz,
     &     x,y,z,r,psi,
     &     alp,cux,cuy,cuz,rg,
     &     uxx,uxy,uxz,uyy,uyz,uzz,
     &     gxx,gxy,gxz,gyy,gyz,gzz,
     &     qxx,qxy,qxz,qyy,qyz,qzz,
     &     dxuxx,dxuxy,dxuxz,dxuyy,dxuyz,dxuzz,
     &     dyuxx,dyuxy,dyuxz,dyuyy,dyuyz,dyuzz,
     &     dzuxx,dzuxy,dzuxz,dzuyy,dzuyz,dzuzz
     &     )
      implicit none

      integer nx,ny,nz
      real time,dt,dx,dy,dz

#include "metric.h"

      integer ibound

c     H3expresso: Hard-wired boundary selection: see Onebound
      ibound = 1

      call Onebound(ibound,nx,ny,nz, alp)
      
      call Onebound(ibound,nx,ny,nz, uxx)
      call Onebound(ibound,nx,ny,nz, uxy)
      call Onebound(ibound,nx,ny,nz, uxz)
      call Onebound(ibound,nx,ny,nz, uyy)
      call Onebound(ibound,nx,ny,nz, uyz)
      call Onebound(ibound,nx,ny,nz, uzz)

      call Onebound(ibound,nx,ny,nz, cux)
      call Onebound(ibound,nx,ny,nz, cuy)
      call Onebound(ibound,nx,ny,nz, cuz)
      
      call Onebound(ibound,nx,ny,nz, qxx)
      call Onebound(ibound,nx,ny,nz, qxy)
      call Onebound(ibound,nx,ny,nz, qxz)
      call Onebound(ibound,nx,ny,nz, qyy)
      call Onebound(ibound,nx,ny,nz, qyz)
      call Onebound(ibound,nx,ny,nz, qzz)
      
      call Onebound(ibound,nx,ny,nz, dxuxx)
      call Onebound(ibound,nx,ny,nz, dxuxy)
      call Onebound(ibound,nx,ny,nz, dxuxz)
      call Onebound(ibound,nx,ny,nz, dxuyy)
      call Onebound(ibound,nx,ny,nz, dxuyz)
      call Onebound(ibound,nx,ny,nz, dxuzz)
      
      call Onebound(ibound,nx,ny,nz, dyuxx)
      call Onebound(ibound,nx,ny,nz, dyuxy)
      call Onebound(ibound,nx,ny,nz, dyuxz)
      call Onebound(ibound,nx,ny,nz, dyuyy)
      call Onebound(ibound,nx,ny,nz, dyuyz)
      call Onebound(ibound,nx,ny,nz, dyuzz)
      
      call Onebound(ibound,nx,ny,nz, dzuxx)
      call Onebound(ibound,nx,ny,nz, dzuxy)
      call Onebound(ibound,nx,ny,nz, dzuxz)
      call Onebound(ibound,nx,ny,nz, dzuyy)
      call Onebound(ibound,nx,ny,nz, dzuyz)
      call Onebound(ibound,nx,ny,nz, dzuzz)

c     Compute covariant metric
      call invert(nx,ny,nz,1,
     &     uxx,uxy,uxz,uyy,uyz,uzz,
     &     rg,gxx,gxy,gxz,gyy,gyz,gzz)
      
      return
      end
*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
      


*==============================================================================
*
*  [ROUTINE NAME] Onebound
*  [AUTHOR] Joan Masso, NCSA & UIB
*
*  [PURPOSE] Simple boundary conditions on one variable
*
*  [ARGUMENTS] 
*     [INPUT]
*        ibound     : FLag controlling the boundary applied
*                        1 = Periodic 
*                        2 = flat: copying the neighbouring plane.
*        nx,ny,nz   : grid sizes of the 3d cube.
*     [INPUT/OUTPUT] 
*        var        :  The 3d variable whose interior is used to
*                      compute the exterior boundaries.
* 
*  [CALLED BY]  Boundaries
*
*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
      
      subroutine Onebound(ibound,nx,ny,nz,var)
      integer ibound
      integer nx,ny,nz
      real var(nx,ny,nz)
      
c     Periodic Boundaries.......................................
      if (ibound.eq.1) then
         var(1,:,:) = var(nx-1,:,:)
         var(:,1,:) = var(:,ny-1,:)
         var(:,:,1) = var(:,:,nz-1)
         
         var(nx,:,:) = var(2,:,:)
         var(:,ny,:) = var(:,2,:)
         var(:,:,nz) = var(:,:,2)
      endif
c     Flat Boundaries (zero order extrapolation)................
      if (ibound.eq.2) then
         var(1,:,:) = var(2,:,:)
         var(:,1,:) = var(:,2,:)
         var(:,:,1) = var(:,:,2)
         
         var(nx,:,:) = var(nx-1,:,:)
         var(:,ny,:) = var(:,ny-1,:)
         var(:,:,nz) = var(:,:,nz-1)
      endif
           
      return
      end
*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


