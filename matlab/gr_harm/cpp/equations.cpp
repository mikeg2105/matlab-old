*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
*
* [FILE]       equations.cpp
*
* [VERSION]    H3expresso  (c) 1995 Joan Masso, NCSA & UIB
*
* [PURPOSE]    The "meat" of the code!!! The Einstein Equations in
*              the harmonic formulation.
* 
*     Check the paper describing the equations:
*           C. Bona and J. Masso, Physical Review Letters, 68, 1097 (1992)
* 
*     or, in my thesis:  "Numerical Relativity: The Quest for a 3-D Code",
*                          University of the Balearic Islands, 1992.
*           
*
* [ROUTINES]   Sources
*              Fluxes
*              dummyentry
*
* [COMMENTS]   These routines have been generated using Mathematica+MathTensor
*              The output may look kinda ugly... 
*
*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$


*==============================================================================
*
*  [ROUTINE NAME] Sources
*  [AUTHOR] Joan Masso, NCSA & UIB
* 
*  [PURPOSE] Compute the sources of the equations
*
*  [ARGUMENTS] 
*     [INPUT]
*        nx,ny,nz  : grid sizes of the 3d cube.
*        Full list of grid and metric arrays
*     [OUTPUT] 
*        s_alp,s_cux,...,s_gxx,...s_qxx,... : Sources of the variables
*                                             that DO have a source term.
*
*  [VARIABLES]  A bunch of 3d arrays (40) is declared to simplify the
*               computations. Without them, this routine would be MUCH longer! 
*               and the code MUCH slower! Too bad they take so much memory...
*
*  [INCLUDES]  metric.h  declares all the passed grid and metric arrays.
*
*  [CALLED BY]  Method
*  [CALLS TO]   Dummyentry
*
*  [WARNING]  A very stupid dummyentry routine has to be called at some
*             points to force most fortran compilers to generate code up to
*             that point and avoid trying to optimize the whole thing.
*             Both the cm5 and the c90 have problems without the calls.
*  
*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

       subroutine Sources(
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

       implicit none
       integer nx,ny,nz

#include "metric.h"

c     declare sources $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      real s_alp(nx,ny,nz)
      real s_cux(nx,ny,nz),s_cuy(nx,ny,nz),s_cuz(nx,ny,nz)
      real s_uxx(nx,ny,nz),s_uxy(nx,ny,nz),s_uxz(nx,ny,nz)
     &    ,s_uyy(nx,ny,nz),s_uyz(nx,ny,nz),s_uzz(nx,ny,nz)
      real s_qxx(nx,ny,nz),s_qxy(nx,ny,nz),s_qxz(nx,ny,nz)
     &    ,s_qyy(nx,ny,nz),s_qyz(nx,ny,nz),s_qzz(nx,ny,nz)


c      ****** declare all auxiliar quantities ******
       real qsum(nx,ny,nz),lx(nx,ny,nz),ly(nx,ny,nz),lz(nx,ny,nz)

       real Fxxx(nx,ny,nz),Fxxy(nx,ny,nz),Fxxz(nx,ny,nz)
     &      ,Fxyy(nx,ny,nz),Fxyz(nx,ny,nz),Fxzz(nx,ny,nz)
       real Fyxx(nx,ny,nz),Fyxy(nx,ny,nz),Fyxz(nx,ny,nz)
     &      ,Fyyy(nx,ny,nz),Fyyz(nx,ny,nz),Fyzz(nx,ny,nz)
       real Fzxx(nx,ny,nz),Fzxy(nx,ny,nz),Fzxz(nx,ny,nz)
     &      ,Fzyy(nx,ny,nz),Fzyz(nx,ny,nz),Fzzz(nx,ny,nz)

       real Hxxx(nx,ny,nz),Hxxy(nx,ny,nz),Hxxz(nx,ny,nz)
     &      ,Hxyy(nx,ny,nz),Hxyz(nx,ny,nz),Hxzz(nx,ny,nz)
       real Hyxx(nx,ny,nz),Hyxy(nx,ny,nz),Hyxz(nx,ny,nz)
     &      ,Hyyy(nx,ny,nz),Hyyz(nx,ny,nz),Hyzz(nx,ny,nz)
       real Hzxx(nx,ny,nz),Hzxy(nx,ny,nz),Hzxz(nx,ny,nz)
     &      ,Hzyy(nx,ny,nz),Hzyz(nx,ny,nz),Hzzz(nx,ny,nz)


c      ****** compute first all auxiliar quantities ******
c      q trace
       qsum = gxx*qxx + 2*gxy*qxy + 2*gxz*qxz + gyy*qyy + 2*gyz*qyz + gz
     & z*qzz

c      L up
       lx = -cux - dxuxx - dyuxy - dzuxz + dxuxx*uxx*gxx/2 + dyuxx*uxy*g
     & xx/2 + dzuxx*uxz*gxx/2 + dxuxy*uxx*gxy + dyuxy*uxy*gxy + dzuxy*ux
     & z*gxy + dxuxz*uxx*gxz + dyuxz*uxy*gxz + dzuxz*uxz*gxz + dxuyy*uxx
     & *gyy/2 + dyuyy*uxy*gyy/2 + dzuyy*uxz*gyy/2 + dxuyz*uxx*gyz + dyuy
     & z*uxy*gyz + dzuyz*uxz*gyz + dxuzz*uxx*gzz/2 + dyuzz*uxy*gzz/2 + d
     & zuzz*uxz*gzz/2

       ly = -cuy - dxuxy - dyuyy - dzuyz + dxuxx*uxy*gxx/2 + dyuxx*uyy*g
     & xx/2 + dzuxx*uyz*gxx/2 + dxuxy*uxy*gxy + dyuxy*uyy*gxy + dzuxy*uy
     & z*gxy + dxuxz*uxy*gxz + dyuxz*uyy*gxz + dzuxz*uyz*gxz + dxuyy*uxy
     & *gyy/2 + dyuyy*uyy*gyy/2 + dzuyy*uyz*gyy/2 + dxuyz*uxy*gyz + dyuy
     & z*uyy*gyz + dzuyz*uyz*gyz + dxuzz*uxy*gzz/2 + dyuzz*uyy*gzz/2 + d
     & zuzz*uyz*gzz/2

       lz = -cuz - dxuxz - dyuyz - dzuzz + dxuxx*uxz*gxx/2 + dyuxx*uyz*g
     & xx/2 + dzuxx*uzz*gxx/2 + dxuxy*uxz*gxy + dyuxy*uyz*gxy + dzuxy*uz
     & z*gxy + dxuxz*uxz*gxz + dyuxz*uyz*gxz + dzuxz*uzz*gxz + dxuyy*uxz
     & *gyy/2 + dyuyy*uyz*gyy/2 + dzuyy*uzz*gyy/2 + dxuyz*uxz*gyz + dyuy
     & z*uyz*gyz + dzuyz*uzz*gyz + dxuzz*uxz*gzz/2 + dyuzz*uyz*gzz/2 + d
     & zuzz*uzz*gzz/2

       call dummyentry(1)

c      auxiliar Chistoffel Gam: u u u 
       Fxxx = -(dxuxx*uxx)/2 - dyuxx*uxy/2 - dzuxx*uxz/2
       Fxxy = -(dxuxx*uxy)/2 - dyuxx*uyy/2 - dzuxx*uyz/2
       Fxyy = dxuyy*uxx/2 - dxuxy*uxy + dyuyy*uxy/2 + dzuyy*uxz/2 - dyux
     & y*uyy - dzuxy*uyz
       Fxxz = -(dxuxx*uxz)/2 - dyuxx*uyz/2 - dzuxx*uzz/2
       Fxyz = dxuyz*uxx/2 - dxuxz*uxy/2 + dyuyz*uxy/2 - dxuxy*uxz/2 + dz
     & uyz*uxz/2 - dyuxz*uyy/2 - dyuxy*uyz/2 - dzuxz*uyz/2 - dzuxy*uzz/2
     & 

       Fxzz = dxuzz*uxx/2 + dyuzz*uxy/2 - dxuxz*uxz + dzuzz*uxz/2 - dyux
     & z*uyz - dzuxz*uzz
       Fyxx = -(dxuxy*uxx) + dxuxx*uxy/2 - dyuxy*uxy - dzuxy*uxz + dyuxx
     & *uyy/2 + dzuxx*uyz/2
       Fyxy = -(dxuyy*uxx)/2 - dyuyy*uxy/2 - dzuyy*uxz/2
       Fyyy = -(dxuyy*uxy)/2 - dyuyy*uyy/2 - dzuyy*uyz/2
       Fyxz = -(dxuyz*uxx)/2 + dxuxz*uxy/2 - dyuyz*uxy/2 - dxuxy*uxz/2 -
     &  dzuyz*uxz/2 + dyuxz*uyy/2 - dyuxy*uyz/2 + dzuxz*uyz/2 - dzuxy*uz
     & z/2

       Fyyz = -(dxuyy*uxz)/2 - dyuyy*uyz/2 - dzuyy*uzz/2
       Fyzz = dxuzz*uxy/2 - dxuyz*uxz + dyuzz*uyy/2 - dyuyz*uyz + dzuzz*
     & uyz/2 - dzuyz*uzz
       Fzxx = -(dxuxz*uxx) - dyuxz*uxy + dxuxx*uxz/2 - dzuxz*uxz + dyuxx
     & *uyz/2 + dzuxx*uzz/2
       Fzxy = -(dxuyz*uxx)/2 - dxuxz*uxy/2 - dyuyz*uxy/2 + dxuxy*uxz/2 -
     &  dzuyz*uxz/2 - dyuxz*uyy/2 + dyuxy*uyz/2 - dzuxz*uyz/2 + dzuxy*uz
     & z/2

       Fzyy = -(dxuyz*uxy) + dxuyy*uxz/2 - dyuyz*uyy + dyuyy*uyz/2 - dzu
     & yz*uyz + dzuyy*uzz/2
       Fzxz = -(dxuzz*uxx)/2 - dyuzz*uxy/2 - dzuzz*uxz/2
       Fzyz = -(dxuzz*uxy)/2 - dyuzz*uyy/2 - dzuzz*uyz/2
       Fzzz = -(dxuzz*uxz)/2 - dyuzz*uyz/2 - dzuzz*uzz/2

       call dummyentry(2)

c      auxiliar Christoffel Ham:  u d d 
       Hxxx = Fxxx*gxx**2 + 2*Fxxy*gxx*gxy + Fxyy*gxy**2 + 2*Fxxz*gxx*gx
     & z + 2*Fxyz*gxy*gxz + Fxzz*gxz**2
       Hxxy = Fxxx*gxx*gxy + Fxxy*gxy**2 + Fxxz*gxy*gxz + Fxxy*gxx*gyy +
     &  Fxyy*gxy*gyy + Fxyz*gxz*gyy + Fxxz*gxx*gyz + Fxyz*gxy*gyz + Fxzz
     & *gxz*gyz

       Hxyy = Fxxx*gxy**2 + 2*Fxxy*gxy*gyy + Fxyy*gyy**2 + 2*Fxxz*gxy*gy
     & z + 2*Fxyz*gyy*gyz + Fxzz*gyz**2
       Hxxz = Fxxx*gxx*gxz + Fxxy*gxy*gxz + Fxxz*gxz**2 + Fxxy*gxx*gyz +
     &  Fxyy*gxy*gyz + Fxyz*gxz*gyz + Fxxz*gxx*gzz + Fxyz*gxy*gzz + Fxzz
     & *gxz*gzz

       Hxyz = Fxxx*gxy*gxz + Fxxy*gxz*gyy + Fxxy*gxy*gyz + Fxxz*gxz*gyz 
     & + Fxyy*gyy*gyz + Fxyz*gyz**2 + Fxxz*gxy*gzz + Fxyz*gyy*gzz + Fxzz
     & *gyz*gzz

       Hxzz = Fxxx*gxz**2 + 2*Fxxy*gxz*gyz + Fxyy*gyz**2 + 2*Fxxz*gxz*gz
     & z + 2*Fxyz*gyz*gzz + Fxzz*gzz**2
       Hyxx = Fyxx*gxx**2 + 2*Fyxy*gxx*gxy + Fyyy*gxy**2 + 2*Fyxz*gxx*gx
     & z + 2*Fyyz*gxy*gxz + Fyzz*gxz**2
       Hyxy = Fyxx*gxx*gxy + Fyxy*gxy**2 + Fyxz*gxy*gxz + Fyxy*gxx*gyy +
     &  Fyyy*gxy*gyy + Fyyz*gxz*gyy + Fyxz*gxx*gyz + Fyyz*gxy*gyz + Fyzz
     & *gxz*gyz

       Hyyy = Fyxx*gxy**2 + 2*Fyxy*gxy*gyy + Fyyy*gyy**2 + 2*Fyxz*gxy*gy
     & z + 2*Fyyz*gyy*gyz + Fyzz*gyz**2
       Hyxz = Fyxx*gxx*gxz + Fyxy*gxy*gxz + Fyxz*gxz**2 + Fyxy*gxx*gyz +
     &  Fyyy*gxy*gyz + Fyyz*gxz*gyz + Fyxz*gxx*gzz + Fyyz*gxy*gzz + Fyzz
     & *gxz*gzz

       Hyyz = Fyxx*gxy*gxz + Fyxy*gxz*gyy + Fyxy*gxy*gyz + Fyxz*gxz*gyz 
     & + Fyyy*gyy*gyz + Fyyz*gyz**2 + Fyxz*gxy*gzz + Fyyz*gyy*gzz + Fyzz
     & *gyz*gzz

       Hyzz = Fyxx*gxz**2 + 2*Fyxy*gxz*gyz + Fyyy*gyz**2 + 2*Fyxz*gxz*gz
     & z + 2*Fyyz*gyz*gzz + Fyzz*gzz**2
       Hzxx = Fzxx*gxx**2 + 2*Fzxy*gxx*gxy + Fzyy*gxy**2 + 2*Fzxz*gxx*gx
     & z + 2*Fzyz*gxy*gxz + Fzzz*gxz**2
       Hzxy = Fzxx*gxx*gxy + Fzxy*gxy**2 + Fzxz*gxy*gxz + Fzxy*gxx*gyy +
     &  Fzyy*gxy*gyy + Fzyz*gxz*gyy + Fzxz*gxx*gyz + Fzyz*gxy*gyz + Fzzz
     & *gxz*gyz

       Hzyy = Fzxx*gxy**2 + 2*Fzxy*gxy*gyy + Fzyy*gyy**2 + 2*Fzxz*gxy*gy
     & z + 2*Fzyz*gyy*gyz + Fzzz*gyz**2
       Hzxz = Fzxx*gxx*gxz + Fzxy*gxy*gxz + Fzxz*gxz**2 + Fzxy*gxx*gyz +
     &  Fzyy*gxy*gyz + Fzyz*gxz*gyz + Fzxz*gxx*gzz + Fzyz*gxy*gzz + Fzzz
     & *gxz*gzz

       Hzyz = Fzxx*gxy*gxz + Fzxy*gxz*gyy + Fzxy*gxy*gyz + Fzxz*gxz*gyz 
     & + Fzyy*gyy*gyz + Fzyz*gyz**2 + Fzxz*gxy*gzz + Fzyz*gyy*gzz + Fzzz
     & *gyz*gzz

       Hzzz = Fzxx*gxz**2 + 2*Fzxy*gxz*gyz + Fzyy*gyz**2 + 2*Fzxz*gxz*gz
     & z + 2*Fzyz*gyz*gzz + Fzzz*gzz**2

       call dummyentry(3)

c      ***** now, the sources of the equations *****

c      source of lapse 
       s_alp = alp/rg *(-(alp*qsum)/2)

c      source momentum
       s_cux = alp/rg*(lx*qsum + Hxxx*qxx - 2*gxx*lx*qxx - 2*gxy*ly*qxx 
     & - 2*gxz*lz*qxx + 2*Hxxy*qxy - 2*gxy*lx*qxy - 2*gyy*ly*qxy - 2*gyz
     & *lz*qxy + 2*Hxxz*qxz - 2*gxz*lx*qxz - 2*gyz*ly*qxz - 2*gzz*lz*qxz
     &  + Hxyy*qyy + 2*Hxyz*qyz + Hxzz*qzz)

       s_cuy = alp/rg*(ly*qsum + Hyxx*qxx + 2*Hyxy*qxy - 2*gxx*lx*qxy - 
     & 2*gxy*ly*qxy - 2*gxz*lz*qxy + 2*Hyxz*qxz + Hyyy*qyy - 2*gxy*lx*qy
     & y - 2*gyy*ly*qyy - 2*gyz*lz*qyy + 2*Hyyz*qyz - 2*gxz*lx*qyz - 2*g
     & yz*ly*qyz - 2*gzz*lz*qyz + Hyzz*qzz)

       s_cuz = alp/rg*(lz*qsum + Hzxx*qxx + 2*Hzxy*qxy + 2*Hzxz*qxz - 2*
     & gxx*lx*qxz - 2*gxy*ly*qxz - 2*gxz*lz*qxz + Hzyy*qyy + 2*Hzyz*qyz 
     & - 2*gxy*lx*qyz - 2*gyy*ly*qyz - 2*gyz*lz*qyz + Hzzz*qzz - 2*gxz*l
     & x*qzz - 2*gyz*ly*qzz - 2*gzz*lz*qzz)

       call dummyentry(4)
c      source g
       s_uxx = alp/rg*(qxx)
       s_uxy = alp/rg*(qxy)
       s_uyy = alp/rg*(qyy)
       s_uxz = alp/rg*(qxz)
       s_uyz = alp/rg*(qyz)
       s_uzz = alp/rg*(qzz)

c      source of q
       s_qxx = alp*rg*( 2*cux**2 - 2*Fxxx*Hxxx - 4*Fxxy*Hxxy - 4*Fxxz*Hx
     & xz - 2*Fxyy*Hxyy - 4*Fxyz*Hxyz - 2*Fxzz*Hxzz - 2*lx**2 + gxx*qxx*
     & *2/rg**2 + 2*gxy*qxx*qxy/rg**2 + gyy*qxy**2/rg**2 + 2*gxz*qxx*qxz
     & /rg**2 + 2*gyz*qxy*qxz/rg**2 + gzz*qxz**2/rg**2)

       s_qxy = alp*rg*( 2*cux*cuy - 2*Fyxx*Hxxx - 4*Fyxy*Hxxy - 4*Fyxz*H
     & xxz - 2*Fyyy*Hxyy - 4*Fyyz*Hxyz - 2*Fyzz*Hxzz - 2*lx*ly + gxx*qxx
     & *qxy/rg**2 + gxy*qxy**2/rg**2 + gxz*qxy*qxz/rg**2 + gxy*qxx*qyy/r
     & g**2 + gyy*qxy*qyy/rg**2 + gyz*qxz*qyy/rg**2 + gxz*qxx*qyz/rg**2 
     & + gyz*qxy*qyz/rg**2 + gzz*qxz*qyz/rg**2)

       s_qyy = alp*rg*( 2*cuy**2 - 2*Fyxx*Hyxx - 4*Fyxy*Hyxy - 4*Fyxz*Hy
     & xz - 2*Fyyy*Hyyy - 4*Fyyz*Hyyz - 2*Fyzz*Hyzz - 2*ly**2 + gxx*qxy*
     & *2/rg**2 + 2*gxy*qxy*qyy/rg**2 + gyy*qyy**2/rg**2 + 2*gxz*qxy*qyz
     & /rg**2 + 2*gyz*qyy*qyz/rg**2 + gzz*qyz**2/rg**2)

       s_qxz = alp*rg*( 2*cux*cuz - 2*Fzxx*Hxxx - 4*Fzxy*Hxxy - 4*Fzxz*H
     & xxz - 2*Fzyy*Hxyy - 4*Fzyz*Hxyz - 2*Fzzz*Hxzz - 2*lx*lz + gxx*qxx
     & *qxz/rg**2 + gxy*qxy*qxz/rg**2 + gxz*qxz**2/rg**2 + gxy*qxx*qyz/r
     & g**2 + gyy*qxy*qyz/rg**2 + gyz*qxz*qyz/rg**2 + gxz*qxx*qzz/rg**2 
     & + gyz*qxy*qzz/rg**2 + gzz*qxz*qzz/rg**2)

       s_qyz = alp*rg*( 2*cuy*cuz - 2*Fzxx*Hyxx - 4*Fzxy*Hyxy - 4*Fzxz*H
     & yxz - 2*Fzyy*Hyyy - 4*Fzyz*Hyyz - 2*Fzzz*Hyzz - 2*ly*lz + gxx*qxy
     & *qxz/rg**2 + gxy*qxz*qyy/rg**2 + gxy*qxy*qyz/rg**2 + gxz*qxz*qyz/
     & rg**2 + gyy*qyy*qyz/rg**2 + gyz*qyz**2/rg**2 + gxz*qxy*qzz/rg**2 
     & + gyz*qyy*qzz/rg**2 + gzz*qyz*qzz/rg**2)

       s_qzz = alp*rg*( 2*cuz**2 - 2*Fzxx*Hzxx - 4*Fzxy*Hzxy - 4*Fzxz*Hz
     & xz - 2*Fzyy*Hzyy - 4*Fzyz*Hzyz - 2*Fzzz*Hzzz - 2*lz**2 + gxx*qxz*
     & *2/rg**2 + 2*gxy*qxz*qyz/rg**2 + gyy*qyz**2/rg**2 + 2*gxz*qxz*qzz
     & /rg**2 + 2*gyz*qyz*qzz/rg**2 + gzz*qzz**2/rg**2)

c      *** done ***
       return
       end
*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>



*==============================================================================
*
*  [ROUTINE NAME] Fluxes
*  [AUTHOR] Joan Masso, NCSA & UIB
* 
*  [PURPOSE] Compute the fluxes of the equations
*
*  [ARGUMENTS] 
*     [INPUT]
*        nx,ny,nz  : grid sizes of the 3d cube.
*        Full list of grid and metric arrays
*     [OUTPUT] 
*        fxxx,fxxy,... : fluxes of the qxx,..., as they are the only
*                        variables with "complicated" fluxes.
*                       That is, F^k_{ij} of the $q^{ij}$
*
*  [INCLUDES]  metric.h  declares all the passed grid and metric arrays.
*
*  [CALLED BY]  Method
*  
*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

      subroutine Fluxes(
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

       implicit none
       integer nx,ny,nz

#include "metric.h"

c     declare fluxes ..................................................
      real Fxxx(nx,ny,nz),Fxxy(nx,ny,nz),Fxxz(nx,ny,nz)
     &    ,Fxyy(nx,ny,nz),Fxyz(nx,ny,nz),Fxzz(nx,ny,nz)
      real Fyxx(nx,ny,nz),Fyxy(nx,ny,nz),Fyxz(nx,ny,nz)
     &    ,Fyyy(nx,ny,nz),Fyyz(nx,ny,nz),Fyzz(nx,ny,nz)
      real Fzxx(nx,ny,nz),Fzxy(nx,ny,nz),Fzxz(nx,ny,nz)
     &    ,Fzyy(nx,ny,nz),Fzyz(nx,ny,nz),Fzzz(nx,ny,nz)

c      ******* q fluxes *******
       Fxxx = alp*rg*(2*cux*uxx + dxuxx*uxx + dyuxx*uxy + dzuxx*uxz)
       Fxxy = alp*rg*(cuy*uxx + dxuxy*uxx + cux*uxy + dyuxy*uxy + dzuxy*
     & uxz)
       Fxyy = alp*rg*(dxuyy*uxx + 2*cuy*uxy + dyuyy*uxy + dzuyy*uxz)
       Fxxz = alp*rg*(cuz*uxx + dxuxz*uxx + dyuxz*uxy + cux*uxz + dzuxz*
     & uxz)
       Fxyz = alp*rg*(dxuyz*uxx + cuz*uxy + dyuyz*uxy + cuy*uxz + dzuyz*
     & uxz)
       Fxzz = alp*rg*(dxuzz*uxx + dyuzz*uxy + 2*cuz*uxz + dzuzz*uxz)
       Fyxx = alp*rg*(2*cux*uxy + dxuxx*uxy + dyuxx*uyy + dzuxx*uyz)
       Fyxy = alp*rg*(cuy*uxy + dxuxy*uxy + cux*uyy + dyuxy*uyy + dzuxy*
     & uyz)
       Fyyy = alp*rg*(dxuyy*uxy + 2*cuy*uyy + dyuyy*uyy + dzuyy*uyz)
       Fyxz = alp*rg*(cuz*uxy + dxuxz*uxy + dyuxz*uyy + cux*uyz + dzuxz*
     & uyz)
       Fyyz = alp*rg*(dxuyz*uxy + cuz*uyy + dyuyz*uyy + cuy*uyz + dzuyz*
     & uyz)
       Fyzz = alp*rg*(dxuzz*uxy + dyuzz*uyy + 2*cuz*uyz + dzuzz*uyz)
       Fzxx = alp*rg*(2*cux*uxz + dxuxx*uxz + dyuxx*uyz + dzuxx*uzz)
       Fzxy = alp*rg*(cuy*uxz + dxuxy*uxz + cux*uyz + dyuxy*uyz + dzuxy*
     & uzz)
       Fzyy = alp*rg*(dxuyy*uxz + 2*cuy*uyz + dyuyy*uyz + dzuyy*uzz)
       Fzxz = alp*rg*(cuz*uxz + dxuxz*uxz + dyuxz*uyz + cux*uzz + dzuxz*
     & uzz)
       Fzyz = alp*rg*(dxuyz*uxz + cuz*uyz + dyuyz*uyz + cuy*uzz + dzuyz*
     & uzz)
       Fzzz = alp*rg*(dxuzz*uxz + dyuzz*uyz + 2*cuz*uzz + dzuzz*uzz)
c      *** done ***
       return
       end
*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


*==============================================================================
*  [ROUTINE NAME] dummyentry
*  [AUTHOR] Joan Masso, NCSA & UIB (and it took me a lot of time!!!)
*  [PURPOSE] Nothing: just a break point for the compilers. See Sources.
*  [CALLED BY]  Sources  
*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
      subroutine dummyentry(i)
      integer i
      return
      end
*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

