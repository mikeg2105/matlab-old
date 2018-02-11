*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
*
* [FILE]       method.cpp
*
* [VERSION]    H3expresso  (c) 1995 Joan Masso, NCSA & UIB
*
* [PURPOSE]    The evolution routine!
*
* [ROUTINES]   Method
*
* [COMMENTS]   H3expresso only supports Macormack
*
*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$


*==============================================================================
*
*  [ROUTINE NAME] Method
*  [AUTHOR] Joan Masso, NCSA & UIB
* 
*     [PURPOSE] Evolve the metric quantities one time step
*     using a simple finite differencing CFD-like method: Macormack.
*     The finite differences are implemented using triplet notation
*     and assuming a regularly spaced grid of dx,dy,dz.
*
*     Our system of equations is of the form:
*       $\partial_t U  - \partial_d F^d (U) = S(U)$
*     with the vector $U$ being all the 34 metric quantities evolved
*     and the flux vector running over the coords $F = (Fx,Fy,Fz)$. 
*     
*        U =  (  alp,cux,cuy,cuz,
*                uxx,uxy,uxz,uyy,uyz,uzz,
*                qxx,qxy,qxz,qyy,qyz,qzz,
*                dxuxx,dxuxy,dxuxz,dxuyy,dxuyz,dxuzz,
*                dyuxx,dyuxy,dyuxz,dyuyy,dyuyz,dyuzz,
*                dzuxx,dzuxy,dzuxz,dzuyy,dzuyz,dzuzz  )
*
*     Some of these variables do not have sources and others do not 
*     have fluxes. See the Sources and Fluxes routines.
*
*     The Macormack method evolves $U$ with the following algorithm:
*
*     First, take a predictor step with backward finite differences:
*          U^p_{ijk} = U^n_{i,j,k} + dt S(U^n_{i,j,k}) 
*                                  + dt/dx (Fx^n_{i,j,k} - Fx^n_{i-1,j,k})
*                                  + dt/dy (Fy^n_{i,j,k} - Fy^n_{i,j-1,k})
*                                  + dt/dz (Fz^n_{i,j,k} - Fz^n_{i,j,k-1})
*     where $U^n_{ijk}$ is U at time step n and grid point i,j,k.
*     and the $U^p$ denotes a predicted value.
*     NOTE that given our cube, this predicted step can be done, in a
*     given direction (say x), from grid points 2 to nx, as it needs i-1.
*     
*     Then, take a corrector step with forward finite differencing using
*     the predicted values :
*          U^c_{ijk} = U^p_{i,j,k} + dt S(U^p_{i,j,k}) 
*                                  + dt/dx (Fx^p_{i+1,j,k} - Fx^p_{i,j,k})
*                                  + dt/dy (Fy^p_{i,j+1,k} - Fy^p_{i,j,k})
*                                  + dt/dz (Fz^p_{i,j,k+1} - Fz^p_{i,j,k})
*     NOTE that now we can correct only from 2 to nx-1, as we have a 
*     prediction for nx that is necessary for the i+1 but we do not have
*     a predicted value for point 1.
*
*     Finally, the evolved value at the next time step n+1 is the average of 
*     the value at time step n and the correction:
*     
*         U^{n+1}_{ijk} = (U^{n}_{ijk} + U^{c}_{ijk})/2
*
*     For more details, see my thesis:
*           "Numerical Relativity: The Quest for a 3-D Code",
*            University of the Balearic Islands, 1992.
*
*  [ARGUMENTS] 
*     [INPUT]
*        nx,ny,nz  : grid sizes of the 3d cube.
*        dt        : Time Step to evolve.
*        dx,dy,dz  : grid spacings that will be used for the finite diff.
*        Full list of grid and metric arrays. The grid arrays are NOT used
*        but passed to be able to use the metric.h file.
*     [OUTPUT]
*        Full list of metric arrays evolved.
*        
*  [INCLUDES]  metric.h  declares all the passed grid and metric arrays.
*
*  [CALLED BY]  H3
*  [CALLS  TO]  Sources
*               Fluxes
*               invert
*
*  [WARNING] 
*        The boundaries, despite being changed in the predictor step, 
*        have not been corrected and, therefore. boundary conditions
*        need to be applied after this evolution. 
*
*        NOTE that gxx,gxy,... and rg are auxiliar quantities that
*        do not form part of the evolved metric. 
*        
*        Also note that they are not recomputed after the corrector 
*        step as they will be recomputed at the Boundaries routine.
*        But note that invert IS called after the predictor step
*        so we have a predicted value for the "down" metric that
*        is necessary for the equations.
*  
*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

c ****************************************************************
c Macormack with sources
c ****************************************************************
      subroutine Method(
     &           nx,ny,nz,
     &           dt,dx,dy,dz,
     &           x,y,z,r,psi,
     &           alp,cux,cuy,cuz,rg,
     &           uxx,uxy,uxz,uyy,uyz,uzz,
     &           gxx,gxy,gxz,gyy,gyz,gzz,
     &           qxx,qxy,qxz,qyy,qyz,qzz,
     &           dxuxx,dxuxy,dxuxz,dxuyy,dxuyz,dxuzz,
     &           dyuxx,dyuxy,dyuxz,dyuyy,dyuyz,dyuzz,
     &           dzuxx,dzuxy,dzuxz,dzuyy,dzuyz,dzuzz
     &           )
      implicit none
      integer nx,ny,nz
      real dt,dx,dy,dz

c     declare metric vars ...............................................
#include "metric.h"

c     declare old vars...................................................
c     That is, the whole vector U at the time step n.
      real old_alp(nx,ny,nz)
      real old_cux(nx,ny,nz),old_cuy(nx,ny,nz),old_cuz(nx,ny,nz)
      real old_uxx(nx,ny,nz),old_uxy(nx,ny,nz),old_uxz(nx,ny,nz)
     &    ,old_uyy(nx,ny,nz),old_uyz(nx,ny,nz),old_uzz(nx,ny,nz)
      real old_qxx(nx,ny,nz),old_qxy(nx,ny,nz),old_qxz(nx,ny,nz)
     &    ,old_qyy(nx,ny,nz),old_qyz(nx,ny,nz),old_qzz(nx,ny,nz)
      real old_dxuxx(nx,ny,nz),old_dxuxy(nx,ny,nz),old_dxuxz(nx,ny,nz)
     &    ,old_dxuyy(nx,ny,nz),old_dxuyz(nx,ny,nz),old_dxuzz(nx,ny,nz)
      real old_dyuxx(nx,ny,nz),old_dyuxy(nx,ny,nz),old_dyuxz(nx,ny,nz)
     &    ,old_dyuyy(nx,ny,nz),old_dyuyz(nx,ny,nz),old_dyuzz(nx,ny,nz)
      real old_dzuxx(nx,ny,nz),old_dzuxy(nx,ny,nz),old_dzuxz(nx,ny,nz)
     &    ,old_dzuyy(nx,ny,nz),old_dzuyz(nx,ny,nz),old_dzuzz(nx,ny,nz)
c     declare sources ...................................................
c     Only for the quantities that do have sources.
      real s_alp(nx,ny,nz)
      real s_cux(nx,ny,nz),s_cuy(nx,ny,nz),s_cuz(nx,ny,nz)
      real s_uxx(nx,ny,nz),s_uxy(nx,ny,nz),s_uxz(nx,ny,nz)
     &    ,s_uyy(nx,ny,nz),s_uyz(nx,ny,nz),s_uzz(nx,ny,nz)
      real s_qxx(nx,ny,nz),s_qxy(nx,ny,nz),s_qxz(nx,ny,nz)
     &    ,s_qyy(nx,ny,nz),s_qyz(nx,ny,nz),s_qzz(nx,ny,nz)
c     declare fluxes ....................................................
c     Only for the qxx,qxy,... as they are the only quantities with
c     nontrivial fluxes. The derivatives dxuxx, ... do have fluxes
c     that turn out to be (but not by miracle) exactly the sources
c     of the uxx,uxy,...
      real fxxx(nx,ny,nz),fxxy(nx,ny,nz),fxxz(nx,ny,nz)
     &    ,fxyy(nx,ny,nz),fxyz(nx,ny,nz),fxzz(nx,ny,nz)
      real fyxx(nx,ny,nz),fyxy(nx,ny,nz),fyxz(nx,ny,nz)
     &    ,fyyy(nx,ny,nz),fyyz(nx,ny,nz),fyzz(nx,ny,nz)
      real fzxx(nx,ny,nz),fzxy(nx,ny,nz),fzxz(nx,ny,nz)
     &    ,fzyy(nx,ny,nz),fzyz(nx,ny,nz),fzzz(nx,ny,nz)
     
c .......................................................................
c     store current level n in old values. 
      old_alp = alp
      old_cux = cux
      old_cuy = cuy 
      old_cuz = cuz
      old_uxx = uxx
      old_uxy = uxy
      old_uxz = uxz
      old_uyy = uyy
      old_uyz = uyz
      old_uzz = uzz
      old_qxx = qxx
      old_qxy = qxy
      old_qxz = qxz
      old_qyy = qyy
      old_qyz = qyz
      old_qzz = qzz
      old_dxuxx = dxuxx
      old_dxuxy = dxuxy
      old_dxuxz = dxuxz
      old_dxuyy = dxuyy
      old_dxuyz = dxuyz
      old_dxuzz = dxuzz
      old_dyuxx = dyuxx
      old_dyuxy = dyuxy
      old_dyuxz = dyuxz
      old_dyuyy = dyuyy
      old_dyuyz = dyuyz
      old_dyuzz = dyuzz
      old_dzuxx = dzuxx
      old_dzuxy = dzuxy
      old_dzuxz = dzuxz
      old_dzuyy = dzuyy
      old_dzuyz = dzuyz
      old_dzuzz = dzuzz

c ....................................................................... 
c     Compute sources and fluxes of current level n
      call Sources(
     &     nx,ny,nz,
     &     x,y,z,r,psi,
     &     alp,cux,cuy,cuz,rg,
     &     uxx,uxy,uxz,uyy,uyz,uzz,
     &     gxx,gxy,gxz,gyy,gyz,gzz,
     &     qxx,qxy,qxz,qyy,qyz,qzz,
     &     dxuxx,dxuxy,dxuxz,dxuyy,dxuyz,dxuzz,
     &     dyuxx,dyuxy,dyuxz,dyuyy,dyuyz,dyuzz,
     &     dzuxx,dzuxy,dzuxz,dzuyy,dzuyz,dzuzz,
     &     s_alp,s_cux,s_cuy,s_cuz,
     &     s_uxx,s_uxy,s_uxz,s_uyy,s_uyz,s_uzz,
     &     s_qxx,s_qxy,s_qxz,s_qyy,s_qyz,s_qzz
     &     )

      call Fluxes(
     &     nx,ny,nz,
     &     x,y,z,r,psi,
     &     alp,cux,cuy,cuz,rg,
     &     uxx,uxy,uxz,uyy,uyz,uzz,
     &     gxx,gxy,gxz,gyy,gyz,gzz,
     &     qxx,qxy,qxz,qyy,qyz,qzz,
     &     dxuxx,dxuxy,dxuxz,dxuyy,dxuyz,dxuzz,
     &     dyuxx,dyuxy,dyuxz,dyuyy,dyuyz,dyuzz,
     &     dzuxx,dzuxy,dzuxz,dzuyy,dzuyz,dzuzz,
     &     fxxx,fxxy,fxxz,fxyy,fxyz,fxzz,
     &     fyxx,fyxy,fyxz,fyyy,fyyz,fyzz,
     &     fzxx,fzxy,fzxz,fzyy,fzyz,fzzz
     &     )

c .......................................................................
c     Predictor step: backwards   
c     Note that we store the predicted value in the same variables,
c     as we have already saved the old value.
c .......................................................................
c     First quantities without fluxes
      alp(2:,2:,2:) = alp(2:,2:,2:) + dt*s_alp(2:,2:,2:)
      cux(2:,2:,2:) = cux(2:,2:,2:) + dt*s_cux(2:,2:,2:)
      cuy(2:,2:,2:) = cuy(2:,2:,2:) + dt*s_cuy(2:,2:,2:)
      cuz(2:,2:,2:) = cuz(2:,2:,2:) + dt*s_cuz(2:,2:,2:)
      uxx(2:,2:,2:) = uxx(2:,2:,2:) + dt*s_uxx(2:,2:,2:)
      uxy(2:,2:,2:) = uxy(2:,2:,2:) + dt*s_uxy(2:,2:,2:)
      uxz(2:,2:,2:) = uxz(2:,2:,2:) + dt*s_uxz(2:,2:,2:)
      uyy(2:,2:,2:) = uyy(2:,2:,2:) + dt*s_uyy(2:,2:,2:)
      uyz(2:,2:,2:) = uyz(2:,2:,2:) + dt*s_uyz(2:,2:,2:)
      uzz(2:,2:,2:) = uzz(2:,2:,2:) + dt*s_uzz(2:,2:,2:)
c     the metric derivatives have a trivial flux and no source
c     x direction
      dxuxx(2:,2:,2:) = dxuxx(2:,2:,2:) 
     &        + dt/dx*( s_uxx(2:,2:,2:) - s_uxx(1:nx-1,2:,2:) )
      dxuxy(2:,2:,2:) = dxuxy(2:,2:,2:)
     &        + dt/dx*( s_uxy(2:,2:,2:) - s_uxy(1:nx-1,2:,2:) )
      dxuxz(2:,2:,2:) = dxuxz(2:,2:,2:)
     &        + dt/dx*( s_uxz(2:,2:,2:) - s_uxz(1:nx-1,2:,2:) )
      dxuyy(2:,2:,2:) = dxuyy(2:,2:,2:) 
     &        + dt/dx*( s_uyy(2:,2:,2:) - s_uyy(1:nx-1,2:,2:) )
      dxuyz(2:,2:,2:) = dxuyz(2:,2:,2:) 
     &        + dt/dx*( s_uyz(2:,2:,2:) - s_uyz(1:nx-1,2:,2:) )
      dxuzz(2:,2:,2:) = dxuzz(2:,2:,2:) 
     &        + dt/dx*( s_uzz(2:,2:,2:) - s_uzz(1:nx-1,2:,2:) )
c     y direction
      dyuxx(2:,2:,2:) = dyuxx(2:,2:,2:) 
     &        + dt/dy*( s_uxx(2:,2:,2:) - s_uxx(2:,1:ny-1,2:) )
      dyuxy(2:,2:,2:) = dyuxy(2:,2:,2:) 
     &        + dt/dy*( s_uxy(2:,2:,2:) - s_uxy(2:,1:ny-1,2:) )
      dyuxz(2:,2:,2:) = dyuxz(2:,2:,2:) 
     &        + dt/dy*( s_uxz(2:,2:,2:) - s_uxz(2:,1:ny-1,2:) )
      dyuyy(2:,2:,2:) = dyuyy(2:,2:,2:) 
     &        + dt/dy*( s_uyy(2:,2:,2:) - s_uyy(2:,1:ny-1,2:) )
      dyuyz(2:,2:,2:) = dyuyz(2:,2:,2:) 
     &        + dt/dy*( s_uyz(2:,2:,2:) - s_uyz(2:,1:ny-1,2:) )
      dyuzz(2:,2:,2:) = dyuzz(2:,2:,2:) 
     &        + dt/dy*( s_uzz(2:,2:,2:) - s_uzz(2:,1:ny-1,2:) )
c     z direction
      dzuxx(2:,2:,2:) = dzuxx(2:,2:,2:) 
     &        + dt/dz*( s_uxx(2:,2:,2:) - s_uxx(2:,2:,1:nz-1) )
      dzuxy(2:,2:,2:) = dzuxy(2:,2:,2:) 
     &        + dt/dz*( s_uxy(2:,2:,2:) - s_uxy(2:,2:,1:nz-1) )
      dzuxz(2:,2:,2:) = dzuxz(2:,2:,2:) 
     &        + dt/dz*( s_uxz(2:,2:,2:) - s_uxz(2:,2:,1:nz-1) )
      dzuyy(2:,2:,2:) = dzuyy(2:,2:,2:) 
     &        + dt/dz*( s_uyy(2:,2:,2:) - s_uyy(2:,2:,1:nz-1) )
      dzuyz(2:,2:,2:) = dzuyz(2:,2:,2:) 
     &        + dt/dz*( s_uyz(2:,2:,2:) - s_uyz(2:,2:,1:nz-1) )
      dzuzz(2:,2:,2:) = dzuzz(2:,2:,2:) 
     &        + dt/dz*( s_uzz(2:,2:,2:) - s_uzz(2:,2:,1:nz-1) )

c     Now the only "interesting" quantities with full 3d flux and source
      qxx(2:,2:,2:) = qxx(2:,2:,2:) + dt*s_qxx(2:,2:,2:) +
     &              dt/dx*( fxxx(2:,2:,2:) - fxxx(1:nx-1,2:,2:) ) +
     &              dt/dy*( fyxx(2:,2:,2:) - fyxx(2:,1:ny-1,2:) ) +
     &              dt/dz*( fzxx(2:,2:,2:) - fzxx(2:,2:,1:nz-1) ) 
      qxy(2:,2:,2:) = qxy(2:,2:,2:) + dt*s_qxy(2:,2:,2:) +
     &              dt/dx*( fxxy(2:,2:,2:) - fxxy(1:nx-1,2:,2:) ) +
     &              dt/dy*( fyxy(2:,2:,2:) - fyxy(2:,1:ny-1,2:) ) +
     &              dt/dz*( fzxy(2:,2:,2:) - fzxy(2:,2:,1:nz-1) ) 
      qxz(2:,2:,2:) = qxz(2:,2:,2:) + dt*s_qxz(2:,2:,2:) +
     &              dt/dx*( fxxz(2:,2:,2:) - fxxz(1:nx-1,2:,2:) ) +
     &              dt/dy*( fyxz(2:,2:,2:) - fyxz(2:,1:ny-1,2:) ) +
     &              dt/dz*( fzxz(2:,2:,2:) - fzxz(2:,2:,1:nz-1) ) 
      qyy(2:,2:,2:) = qyy(2:,2:,2:) + dt*s_qyy(2:,2:,2:) +
     &              dt/dx*( fxyy(2:,2:,2:) - fxyy(1:nx-1,2:,2:) ) +
     &              dt/dy*( fyyy(2:,2:,2:) - fyyy(2:,1:ny-1,2:) ) +
     &              dt/dz*( fzyy(2:,2:,2:) - fzyy(2:,2:,1:nz-1) ) 
      qyz(2:,2:,2:) = qyz(2:,2:,2:) + dt*s_qyz(2:,2:,2:) +
     &              dt/dx*( fxyz(2:,2:,2:) - fxyz(1:nx-1,2:,2:) ) +
     &              dt/dy*( fyyz(2:,2:,2:) - fyyz(2:,1:ny-1,2:) ) +
     &              dt/dz*( fzyz(2:,2:,2:) - fzyz(2:,2:,1:nz-1) ) 
      qzz(2:,2:,2:) = qzz(2:,2:,2:) + dt*s_qzz(2:,2:,2:) +
     &              dt/dx*( fxzz(2:,2:,2:) - fxzz(1:nx-1,2:,2:) ) +
     &              dt/dy*( fyzz(2:,2:,2:) - fyzz(2:,1:ny-1,2:) ) +
     &              dt/dz*( fzzz(2:,2:,2:) - fzzz(2:,2:,1:nz-1) ) 


c .......................................................................
c     Now that we have predicted variables, we need the predicted
c     sources and fluxes. But first, we need to get the "down" metric

      call invert(nx,ny,nz,1,
     &     uxx,uxy,uxz,uyy,uyz,uzz,
     &     rg,gxx,gxy,gxz,gyy,gyz,gzz)

      call Sources(
     &     nx,ny,nz,
     &     x,y,z,r,psi,
     &     alp,cux,cuy,cuz,rg,
     &     uxx,uxy,uxz,uyy,uyz,uzz,
     &     gxx,gxy,gxz,gyy,gyz,gzz,
     &     qxx,qxy,qxz,qyy,qyz,qzz,
     &     dxuxx,dxuxy,dxuxz,dxuyy,dxuyz,dxuzz,
     &     dyuxx,dyuxy,dyuxz,dyuyy,dyuyz,dyuzz,
     &     dzuxx,dzuxy,dzuxz,dzuyy,dzuyz,dzuzz,
     &     s_alp,s_cux,s_cuy,s_cuz,
     &     s_uxx,s_uxy,s_uxz,s_uyy,s_uyz,s_uzz,
     &     s_qxx,s_qxy,s_qxz,s_qyy,s_qyz,s_qzz
     &     )

      call Fluxes(
     &     nx,ny,nz,
     &     x,y,z,r,psi,
     &     alp,cux,cuy,cuz,rg,
     &     uxx,uxy,uxz,uyy,uyz,uzz,
     &     gxx,gxy,gxz,gyy,gyz,gzz,
     &     qxx,qxy,qxz,qyy,qyz,qzz,
     &     dxuxx,dxuxy,dxuxz,dxuyy,dxuyz,dxuzz,
     &     dyuxx,dyuxy,dyuxz,dyuyy,dyuyz,dyuzz,
     &     dzuxx,dzuxy,dzuxz,dzuyy,dzuyz,dzuzz,
     &     fxxx,fxxy,fxxz,fxyy,fxyz,fxzz,
     &     fyxx,fyxy,fyxz,fyyy,fyyz,fyzz,
     &     fzxx,fzxy,fzxz,fzyy,fzyz,fzzz
     &     )

c .......................................................................
c     Corrector step: forward  
c     Note that we store the corrected value in the same variables
c     as we do not longer need the predicted values.
c .......................................................................

c     First quantities without fluxes
      alp(2:nx-1,2:ny-1,2:nz-1) = alp(2:nx-1,2:ny-1,2:nz-1) 
     &     + dt*s_alp(2:nx-1,2:ny-1,2:nz-1)
      cux(2:nx-1,2:ny-1,2:nz-1) = cux(2:nx-1,2:ny-1,2:nz-1)
     &     + dt*s_cux(2:nx-1,2:ny-1,2:nz-1)
      cuy(2:nx-1,2:ny-1,2:nz-1) = cuy(2:nx-1,2:ny-1,2:nz-1) 
     &     + dt*s_cuy(2:nx-1,2:ny-1,2:nz-1)
      cuz(2:nx-1,2:ny-1,2:nz-1) = cuz(2:nx-1,2:ny-1,2:nz-1) 
     &     + dt*s_cuz(2:nx-1,2:ny-1,2:nz-1)
      uxx(2:nx-1,2:ny-1,2:nz-1) = uxx(2:nx-1,2:ny-1,2:nz-1)
     &     + dt*s_uxx(2:nx-1,2:ny-1,2:nz-1)
      uxy(2:nx-1,2:ny-1,2:nz-1) = uxy(2:nx-1,2:ny-1,2:nz-1) 
     &     + dt*s_uxy(2:nx-1,2:ny-1,2:nz-1)
      uxz(2:nx-1,2:ny-1,2:nz-1) = uxz(2:nx-1,2:ny-1,2:nz-1)
     &    + dt*s_uxz(2:nx-1,2:ny-1,2:nz-1)
      uyy(2:nx-1,2:ny-1,2:nz-1) = uyy(2:nx-1,2:ny-1,2:nz-1)
     &    + dt*s_uyy(2:nx-1,2:ny-1,2:nz-1)
      uyz(2:nx-1,2:ny-1,2:nz-1) = uyz(2:nx-1,2:ny-1,2:nz-1)
     &    + dt*s_uyz(2:nx-1,2:ny-1,2:nz-1)
      uzz(2:nx-1,2:ny-1,2:nz-1) = uzz(2:nx-1,2:ny-1,2:nz-1)
     &    + dt*s_uzz(2:nx-1,2:ny-1,2:nz-1)

c     derivatives with no source and trivial flux
c     x direction
      dxuxx(2:nx-1,2:ny-1,2:nz-1) = dxuxx(2:nx-1,2:ny-1,2:nz-1) 
     &  + dt/dx*( s_uxx(3:nx,2:ny-1,2:nz-1) - s_uxx(2:nx-1,2:ny-1,2:nz-1) )
      dxuxy(2:nx-1,2:ny-1,2:nz-1) = dxuxy(2:nx-1,2:ny-1,2:nz-1) 
     &  + dt/dx*( s_uxy(3:nx,2:ny-1,2:nz-1) - s_uxy(2:nx-1,2:ny-1,2:nz-1) )
      dxuxz(2:nx-1,2:ny-1,2:nz-1) = dxuxz(2:nx-1,2:ny-1,2:nz-1) 
     &  + dt/dx*( s_uxz(3:nx,2:ny-1,2:nz-1) - s_uxz(2:nx-1,2:ny-1,2:nz-1) )
      dxuyy(2:nx-1,2:ny-1,2:nz-1) = dxuyy(2:nx-1,2:ny-1,2:nz-1) 
     &  + dt/dx*( s_uyy(3:nx,2:ny-1,2:nz-1) - s_uyy(2:nx-1,2:ny-1,2:nz-1) )
      dxuyz(2:nx-1,2:ny-1,2:nz-1) = dxuyz(2:nx-1,2:ny-1,2:nz-1) 
     &  + dt/dx*( s_uyz(3:nx,2:ny-1,2:nz-1) - s_uyz(2:nx-1,2:ny-1,2:nz-1) )
      dxuzz(2:nx-1,2:ny-1,2:nz-1) = dxuzz(2:nx-1,2:ny-1,2:nz-1) 
     &  + dt/dx*( s_uzz(3:nx,2:ny-1,2:nz-1) - s_uzz(2:nx-1,2:ny-1,2:nz-1) )
c     y direction
      dyuxx(2:nx-1,2:ny-1,2:nz-1) = dyuxx(2:nx-1,2:ny-1,2:nz-1) 
     &  + dt/dy*( s_uxx(2:nx-1,3:ny,2:nz-1) - s_uxx(2:nx-1,2:ny-1,2:nz-1) )
      dyuxy(2:nx-1,2:ny-1,2:nz-1) = dyuxy(2:nx-1,2:ny-1,2:nz-1) 
     &  + dt/dy*( s_uxy(2:nx-1,3:ny,2:nz-1) - s_uxy(2:nx-1,2:ny-1,2:nz-1) )
      dyuxz(2:nx-1,2:ny-1,2:nz-1) = dyuxz(2:nx-1,2:ny-1,2:nz-1) 
     &  + dt/dy*( s_uxz(2:nx-1,3:ny,2:nz-1) - s_uxz(2:nx-1,2:ny-1,2:nz-1) )
      dyuyy(2:nx-1,2:ny-1,2:nz-1) = dyuyy(2:nx-1,2:ny-1,2:nz-1) 
     &  + dt/dy*( s_uyy(2:nx-1,3:ny,2:nz-1) - s_uyy(2:nx-1,2:ny-1,2:nz-1) )
      dyuyz(2:nx-1,2:ny-1,2:nz-1) = dyuyz(2:nx-1,2:ny-1,2:nz-1) 
     &  + dt/dy*( s_uyz(2:nx-1,3:ny,2:nz-1) - s_uyz(2:nx-1,2:ny-1,2:nz-1) )
      dyuzz(2:nx-1,2:ny-1,2:nz-1) = dyuzz(2:nx-1,2:ny-1,2:nz-1) 
     &  + dt/dy*( s_uzz(2:nx-1,3:ny,2:nz-1) - s_uzz(2:nx-1,2:ny-1,2:nz-1) )
c     z direction
      dzuxx(2:nx-1,2:ny-1,2:nz-1) = dzuxx(2:nx-1,2:ny-1,2:nz-1) 
     &  + dt/dz*( s_uxx(2:nx-1,2:ny-1,3:nz) - s_uxx(2:nx-1,2:ny-1,2:nz-1) )
      dzuxy(2:nx-1,2:ny-1,2:nz-1) = dzuxy(2:nx-1,2:ny-1,2:nz-1) 
     &  + dt/dz*( s_uxy(2:nx-1,2:ny-1,3:nz) - s_uxy(2:nx-1,2:ny-1,2:nz-1) )
      dzuxz(2:nx-1,2:ny-1,2:nz-1) = dzuxz(2:nx-1,2:ny-1,2:nz-1) 
     &  + dt/dz*( s_uxz(2:nx-1,2:ny-1,3:nz) - s_uxz(2:nx-1,2:ny-1,2:nz-1) )
      dzuyy(2:nx-1,2:ny-1,2:nz-1) = dzuyy(2:nx-1,2:ny-1,2:nz-1) 
     &  + dt/dz*( s_uyy(2:nx-1,2:ny-1,3:nz) - s_uyy(2:nx-1,2:ny-1,2:nz-1) )
      dzuyz(2:nx-1,2:ny-1,2:nz-1) = dzuyz(2:nx-1,2:ny-1,2:nz-1) 
     &  + dt/dz*( s_uyz(2:nx-1,2:ny-1,3:nz) - s_uyz(2:nx-1,2:ny-1,2:nz-1) )
      dzuzz(2:nx-1,2:ny-1,2:nz-1) = dzuzz(2:nx-1,2:ny-1,2:nz-1) 
     &  + dt/dz*( s_uzz(2:nx-1,2:ny-1,3:nz) - s_uzz(2:nx-1,2:ny-1,2:nz-1) )

c     full thing
      qxx(2:nx-1,2:ny-1,2:nz-1) = qxx(2:nx-1,2:ny-1,2:nz-1) 
     &     + dt*s_qxx(2:nx-1,2:ny-1,2:nz-1) +
     &  dt/dx*( fxxx(3:nx,2:ny-1,2:nz-1) - fxxx(2:nx-1,2:ny-1,2:nz-1) ) +
     &  dt/dy*( fyxx(2:nx-1,3:ny,2:nz-1) - fyxx(2:nx-1,2:ny-1,2:nz-1) ) +
     &  dt/dz*( fzxx(2:nx-1,2:ny-1,3:nz) - fzxx(2:nx-1,2:ny-1,2:nz-1) ) 
      qxy(2:nx-1,2:ny-1,2:nz-1) = qxy(2:nx-1,2:ny-1,2:nz-1) 
     &     + dt*s_qxy(2:nx-1,2:ny-1,2:nz-1) +
     &  dt/dx*( fxxy(3:nx,2:ny-1,2:nz-1) - fxxy(2:nx-1,2:ny-1,2:nz-1) ) +
     &  dt/dy*( fyxy(2:nx-1,3:ny,2:nz-1) - fyxy(2:nx-1,2:ny-1,2:nz-1) ) +
     &  dt/dz*( fzxy(2:nx-1,2:ny-1,3:nz) - fzxy(2:nx-1,2:ny-1,2:nz-1) ) 
      qxz(2:nx-1,2:ny-1,2:nz-1) = qxz(2:nx-1,2:ny-1,2:nz-1) 
     &     + dt*s_qxz(2:nx-1,2:ny-1,2:nz-1) +
     &  dt/dx*( fxxz(3:nx,2:ny-1,2:nz-1) - fxxz(2:nx-1,2:ny-1,2:nz-1) ) +
     &  dt/dy*( fyxz(2:nx-1,3:ny,2:nz-1) - fyxz(2:nx-1,2:ny-1,2:nz-1) ) +
     &  dt/dz*( fzxz(2:nx-1,2:ny-1,3:nz) - fzxz(2:nx-1,2:ny-1,2:nz-1) ) 
      qyy(2:nx-1,2:ny-1,2:nz-1) = qyy(2:nx-1,2:ny-1,2:nz-1) 
     &     + dt*s_qyy(2:nx-1,2:ny-1,2:nz-1) +
     &  dt/dx*( fxyy(3:nx,2:ny-1,2:nz-1) - fxyy(2:nx-1,2:ny-1,2:nz-1) ) +
     &  dt/dy*( fyyy(2:nx-1,3:ny,2:nz-1) - fyyy(2:nx-1,2:ny-1,2:nz-1) ) +
     &  dt/dz*( fzyy(2:nx-1,2:ny-1,3:nz) - fzyy(2:nx-1,2:ny-1,2:nz-1) ) 
      qyz(2:nx-1,2:ny-1,2:nz-1) = qyz(2:nx-1,2:ny-1,2:nz-1) 
     &     + dt*s_qyz(2:nx-1,2:ny-1,2:nz-1) +
     &  dt/dx*( fxyz(3:nx,2:ny-1,2:nz-1) - fxyz(2:nx-1,2:ny-1,2:nz-1) ) +
     &  dt/dy*( fyyz(2:nx-1,3:ny,2:nz-1) - fyyz(2:nx-1,2:ny-1,2:nz-1) ) +
     &  dt/dz*( fzyz(2:nx-1,2:ny-1,3:nz) - fzyz(2:nx-1,2:ny-1,2:nz-1) ) 
      qzz(2:nx-1,2:ny-1,2:nz-1) = qzz(2:nx-1,2:ny-1,2:nz-1) 
     &     + dt*s_qzz(2:nx-1,2:ny-1,2:nz-1) +
     &  dt/dx*( fxzz(3:nx,2:ny-1,2:nz-1) - fxzz(2:nx-1,2:ny-1,2:nz-1) ) +
     &  dt/dy*( fyzz(2:nx-1,3:ny,2:nz-1) - fyzz(2:nx-1,2:ny-1,2:nz-1) ) +
     &  dt/dz*( fzzz(2:nx-1,2:ny-1,3:nz) - fzzz(2:nx-1,2:ny-1,2:nz-1) ) 

c .......................................................................
c     Now we compute the final evolved value. Again, we store it
c     in the same variables, so the evolved values have replaced the
c     original ones.
      alp = (old_alp + alp) /2.
      cux = (old_cux + cux) /2.
      cuy = (old_cuy + cuy) /2.
      cuz = (old_cuz + cuz) /2.
      uxx = (old_uxx + uxx) /2.
      uxy = (old_uxy + uxy) /2.
      uxz = (old_uxz + uxz) /2.
      uyy = (old_uyy + uyy) /2.
      uyz = (old_uyz + uyz) /2.
      uzz = (old_uzz + uzz) /2.
      qxx = (old_qxx + qxx) /2.
      qxy = (old_qxy + qxy) /2.
      qxz = (old_qxz + qxz) /2.
      qyy = (old_qyy + qyy) /2.
      qyz = (old_qyz + qyz) /2.
      qzz = (old_qzz + qzz) /2.
      dxuxx = (old_dxuxx + dxuxx) /2.
      dxuxy = (old_dxuxy + dxuxy) /2.
      dxuxz = (old_dxuxz + dxuxz) /2.
      dxuyy = (old_dxuyy + dxuyy) /2.
      dxuyz = (old_dxuyz + dxuyz) /2.
      dxuzz = (old_dxuzz + dxuzz) /2.
      dyuxx = (old_dyuxx + dyuxx) /2.
      dyuxy = (old_dyuxy + dyuxy) /2.
      dyuxz = (old_dyuxz + dyuxz) /2.
      dyuyy = (old_dyuyy + dyuyy) /2.
      dyuyz = (old_dyuyz + dyuyz) /2.
      dyuzz = (old_dyuzz + dyuzz) /2.
      dzuxx = (old_dzuxx + dzuxx) /2.
      dzuxy = (old_dzuxy + dzuxy) /2.
      dzuxz = (old_dzuxz + dzuxz) /2.
      dzuyy = (old_dzuyy + dzuyy) /2.
      dzuyz = (old_dzuyz + dzuyz) /2.
      dzuzz = (old_dzuzz + dzuzz) /2.

c     Now we should call invert to compute the "down" metric but
c     we leave that to the Boundaries routine.

c     Note that if on wanted static boundary conditions, we still
c     have the old values, so here would be the place to restore the
c     boundary planes that have been modified in the prediction:
c         alp(nx,:,:) = old_alp(nx,:,:)
c         etc...

      return
      end

