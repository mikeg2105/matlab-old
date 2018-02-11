*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
*
* [FILE]       initial.cpp
*
* [VERSION]    H3expresso  (c) 1995 Joan Masso, NCSA & UIB
*
* [PURPOSE]    All the routines related with the initial data
*
* [ROUTINES]   Initial  
*              Analywave
*              Curelation
*              Centralderiv
*
* [COMMENTS]   H3expresso only supports linearized waves as initial data.
*
*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$


*==============================================================================
*
*  [ROUTINE NAME] Initial
*  [AUTHOR] Joan Masso, NCSA & UIB
* 
*  [PURPOSE] Initialize the metric structure with the initial data.
*     See the comments inside the routine for specific info, as some
*     special routines have to be called to supply initial data.
*
*  [ARGUMENTS] 
*     [INPUT]
*        nx,ny,nz  : grid sizes of the 3d cube.
*        dx,dy,dz  : grid spacings that will be used to init the grid
*        par1,par2 : Parameters for the initial analytical waves.   
*     [OUTPUT]
*        time,dt   : time and time step to initialize.
*        Full list of grid and metric arrays to be initialized.
*  [INCLUDES]  metric.h  declares all the passed grid and metric arrays.
*
*  [CALLED BY]  H3
*  [CALLS  TO]  Analywave
*               invert
*               Centralderiv
*               Curelation
*  
*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

      subroutine Initial(
     &     nx,ny,nz,dx,dy,dz,par1,par2,
     &     time,dt,
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
      
      real par1,par2
      integer nx,ny,nz
      real time,dt,dx,dy,dz

c     Metric structure arrays
#include "metric.h"

c     local vars
      integer i,j,k

c     Init time $t$
      time= 0.

c     We will use a fixed dt during the evolution. This dt
c     should be less than the maximum courant time step of dx/sqrt(3)
c     Note that we assume that the metric factor on the courant does
c     not play any role... this is true for the linearized waves.
      dt = 0.5*dx

c     Initialize the grid vectors $x,y,z$  grid going from -xmax to xmax
c     We use triplet notation to avoid loops around the other directions.

      do i=1,nx 
         x(i,:,:)= (i-1-(nx-1.)/2.)*dx  
      end do
      do j=1,ny 
         y(:,j,:)= (j-1-(ny-1.)/2.)*dy  
      end do
      do k=1,nz 
         z(:,:,k)= (k-1-(nz-1.)/2.)*dz  
      end do
      
c     compute radial coordinate $r$
      r = sqrt(x**2 + y**2 + z**2)

C     Conformal factor $\psi$ for the linearized waves is simply one.
C     It should not be used anywhere and has been kept to avoid changing
c     the data structure between H3.3 and H3expresso.
      psi= 1.

c     Initial Gauge choice: lapse $\alpha = 1$
      alp= 1.

c     Covariant metric $g_{ij}$ is computed analytically and depends
c     on the parameters par1 and par2
      call Analywave(
     &     nx,ny,nz,time,par1,par2,
     &     x,y,z,r,
     &     gxx,gxy,gxz,gyy,gyz,gzz)

c     At t=0. (H3expresso) we have time symmetry so the extrinsic
c     curvature related quantities are zero.
      qxx = 0.
      qxy = 0.
      qxz = 0.
      qyy = 0.
      qyz = 0.
      qzz = 0.
      
c     Now we compute the contravariant metric $g^{ij}$ which is our
c     evolved metric.
      call invert(nx,ny,nz,
     &     -1,gxx,gxy,gxz,gyy,gyz,gzz,
     &     rg,uxx,uxy,uxz,uyy,uyz,uzz)
      
      
c     We also need the derivatives at the initial time.
c     Because the analytic expressions are VERY cumbersome, we
c     will use a patch  and compute them as central differences
      call Centralderiv(
     &     nx,ny,nz,
     &     dx,dy,dz,
     &     uxx,uxy,uxz,uyy,uyz,uzz,
     &     dxuxx,dyuxx,dzuxx,
     &     dxuxy,dyuxy,dzuxy,
     &     dxuxz,dyuxz,dzuxz,
     &     dxuyy,dyuyy,dzuyy,
     &     dxuyz,dyuyz,dzuyz,
     &     dxuzz,dyuzz,dzuzz)

      
      
c     Finally, we need the momentum related quantities $\Gamma^i$
C     so we will use the constrained relations at the initial time
C     to derive them. NOTE that they are only Valid for a constant lapse.
      call Curelation(nx,ny,nz,
     &               uxx,uxy,uxz,uyy,uyz,uzz,
     &               gxx,gxy,gxz,gyy,gyz,gzz,
     &               dxuxx,dxuxy,dxuxz,dxuyy,dxuyz,dxuzz,
     &               dyuxx,dyuxy,dyuxz,dyuyy,dyuyz,dyuzz,
     &               dzuxx,dzuxy,dzuxz,dzuyy,dzuyz,dzuzz,
     &               cux, cuy, cuz)
      
      return
      end
*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>



*==============================================================================
*
*  [ROUTINE NAME] Analywave    
*  [AUTHOR] Joan Masso, NCSA & UIB
*           Based on an original routine by Malcolm Tobias, WashU.
* 
*  [PURPOSE] Initialize the metric tensor $g_{ij}$ with a linearized
*     Eppley style packet of incoming/outgoing waves. The metric
*     is computed in spherical coordinates and then transformed to
*     cartesian. 
*
*  [ARGUMENTS] 
*     [INPUT]
*        nx,ny,nz  : grid sizes of the 3d cube.
*        time, x,y,z,r  : time scalar and grid vectors
*        par1,par2 : Parameters controlling the amplitude and shape
*                    of the blob of waves.
*     [OUTPUT]
*        gxx,gxy,...,gzz: covariant metric $g_{ij}$
* 
*  [VARIABLES] A LOT of 3d local arrays is declared to make the
*     computation of the metric easier... due to historical reasons
*     it is not worth cleaning up... Anyway, this routine is only
*     called once so efficiency is not a crucial issue.
*
*  [CALLED BY]  Initial
*  [CALLS  TO]  Spheretocart
*
*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

      subroutine Analywave(
     &     nx,ny,nz,time,par1,par2,
     &     x,y,z,r,
     &     gxx,gxy,gxz,gyy,gyz,gzz)


      implicit NONE

      integer nx,ny,nz
      real time
      real par1,par2
      
      real x(nx,ny,nz),y(nx,ny,nz),z(nx,ny,nz),r(nx,ny,nz)
      real gxx(nx,ny,nz),gxy(nx,ny,nz),gxz(nx,ny,nz),
     &     gyy(nx,ny,nz),gyz(nx,ny,nz),gzz(nx,ny,nz)

c     Local Vars.

c     Metric in spherical coordinates
c     $g_{rr},g_{r\theta},g_{r\phi},g_{\theta\theta}...$ etc.
      real grr(nx,ny,nz),grt(nx,ny,nz),grp(nx,ny,nz),
     &     gtt(nx,ny,nz),gtp(nx,ny,nz),gpp(nx,ny,nz)

c     Auxiliar coefficients
      real fp(nx,ny,nz),fn(nx,ny,nz) 	
      real fpa(nx,ny,nz),fna(nx,ny,nz)
      real fpb(nx,ny,nz),fnb(nx,ny,nz)
      real fpc(nx,ny,nz),fnc(nx,ny,nz)
      real fpd(nx,ny,nz),fnd(nx,ny,nz)
      real tp(nx,ny,nz),tn(nx,ny,nz)
      real ca(nx,ny,nz),cb(nx,ny,nz),cc(nx,ny,nz)
      real ck(nx,ny,nz),cl(nx,ny,nz)
      
      real frr(nx,ny,nz),frt(nx,ny,nz),frp(nx,ny,nz),
     &     ftt1(nx,ny,nz),ftt2(nx,ny,nz),ftp(nx,ny,nz),
     2     fpp1(nx,ny,nz),fpp2(nx,ny,nz)
      
      real drt(nx,ny,nz),drp(nx,ny,nz),dtt(nx,ny,nz),
     &     dtp(nx,ny,nz),dpp(nx,ny,nz)
      
      real sint(nx,ny,nz),cost(nx,ny,nz),sinp(nx,ny,nz),cosp(nx,ny,nz)
      
      real amp,m,ra
      integer iparity

c     Wave characteristics: amplitude and m value (shape)
      amp = par1
c     integer m is gonna be the integer part of par2
      m = par2

c     Some hardwired values for H3expresso
c     centering of the wave     
      ra = 0.
c     parity of the wave (1 = odd, 2 = even)
      iparity = 2

c     advanced/retarded times.
      tp = (time+r-ra)
      tn = (time-r+ra)
      
c     Eppley style packet
      fp = amp * tp*exp(-tp**2)
      fpa = amp * (1 - 2*tp**2)*exp(-tp**2)
      fpb = amp * (-6*tp + 4*tp**3)*exp(-tp**2)
      fpc = amp * (-6 + 24*tp**2 - 8*tp**4)*exp(-tp**2)
      fpd = amp * (60*tp - 80*tp**3 + 16*tp**5)*exp(-tp**2)
      
      fn = amp * tn*exp(-tn**2)
      fna = amp * (1 - 2*tn**2)*exp(-tn**2)
      fnb = amp * (-6*tn + 4*tn**3)*exp(-tn**2)
      fnc = amp * (-6 +24*tn**2 - 8*tn**4)*exp(-tn**2)
      fnd = amp * (60*tn - 80*tn**3 + 16*tn**5)*exp(-tn**2)
      
c     coefficients
      ca = 3*( (fpb-fnb)/r**3 -3*(fna+fpa)/r**4 +3*(fp-fn)/r**5 )
      cb = -( -(fnc+fpc)/r**2 +3*(fpb-fnb)/r**3 -6*(fna+fpa)/r**4
     &     +6*(fp-fn)/r**5 ) 
      cc = ( (fpd-fnd)/r -2*(fnc+fpc)/r**2 +9*(fpb-fnb)/r**3
     &     -21*(fna+fpa)/r**4 +21*(fp-fn)/r**5 )/4
      ck = (fpb-fnb)/r**2-3*(fpa+fna)/r**3+3*(fp-fn)/r**4
      cl = -(fpc+fnc)/r+2*(fpb-fnb)/r**2-3*(fpa+fna)/r**3+
     &     3*(fp-fn)/r**4
      
      
      sint = (x**2+y**2)**0.5/r
      cost = z/r
      sinp = y/(x**2+y**2)**0.5
      cosp = x/(x**2+y**2)**0.5

c     Choose coeffs. depending on m value.
      if (m.eq.0) then
         frr = 2-3*sint**2
         frt = -3*sint*cost
         frp = 0.
         ftt1 = 3*sint**2
         ftt2 = -1.
         ftp = 0.
         fpp1 = -ftt1
         fpp2 = 3*sint**2-1
         drt = 0.
         drp = -4*cost*sint
         dtt = 0.
         dtp = -sint**2
         dpp = 0.
      endif
      
      if (m.eq.-1) then
         frr = 2*sint*cost*sinp
         frt = (cost**2-sint**2)*sinp 
         frp = cost*cosp 
         ftt1 = -frr
         ftt2 = 0.
         ftp = sint*cosp 
         fpp1 = -ftt1
         fpp2 = ftt1
         drt = -2*cost*sinp
         drp = -2*(cost**2-sint**2)*cosp
         dtt = -sint*sinp
         dtp = -cost*sint*cosp
         dpp = sint*sinp
      endif
      
      if (m.eq.-2) then
         frr = sint**2*2*sinp*cosp
         frt = sint*cost*2*sinp*cosp
         frp = sint*(1-2*sinp**2)
         ftt1 = (1+cost**2)*2*sinp*cosp
         ftt2 = -2*sinp*cosp
         fpp1 = -ftt1
         fpp2 = cost**2*2*sinp*cosp
         drt = 8*sint*sinp*cosp
         drp = 4*sint*cost*(1-2*sinp**2)
         dtt = -4*cost*sinp*cosp
         dtp = (2-sint**2)*(2*sinp**2-1)
         dpp = 2*cost*2*sinp*cosp
      endif
      
      if (m.eq.1) then
         frr = 2*sint*cost*cosp
         frt = (cost**2-sint**2)*cosp
         frp = -cost*sinp
         ftt1 = -2*sint*cost*cosp
         ftt2 = 0.
         ftp = -sint*sinp
         fpp1 = -ftt1
         fpp2 = ftt1
         drt = -2*cost*cosp
         drp = 2*(cost**2-sint**2)*sinp
         dtt = -sint*cosp
         dtp = cost*sint*sinp
         dpp = sint*cosp
      endif
      
      if (m.eq.2) then
         frr = sint**2*(1-2*sinp**2)
         frt = sint*cost*(1-2*sinp**2)
         frp = -sint*2*sinp*cosp
         ftt1 = (1+cost**2)*(1-2*sinp**2)
         ftt2 = (2*sinp**2-1)
         ftp = cost*2*sinp*cosp
         fpp1 = -ftt1
         fpp2 = cost**2*(1-2*sinp**2)
         drt = 4*sint*(1-2*sinp**2)
         drp = -4*sint*cost*2*sinp*cosp
         dtt = -2*cost*(1-2*sinp**2)
         dtp = (2-sint**2)*2*sinp*cosp
         dpp = 2*cost*(1-2*sinp**2)
      endif

c     Set the metric in spherical coordinates
      if (iparity.eq.2) then	
         grr = 1 + ca*frr
         grt = cb*frt*r
         grp = cb*frp*(x**2+y**2)**0.5
         gtt = r**2*(1 + cc*ftt1 + ca*ftt2)
         gtp = (ca - 2*cc)*ftp*r*(x**2+y**2)**0.5
         gpp = (x**2+y**2)*(1 + cc*fpp1 + ca*fpp2)
      endif
      
      if (iparity.eq.1) then
         grr = 1.
         grt = ck*drt*r
         grp = ck*drp*r*sint
         gtt = (1+cl*dtt)*r**2
         gtp = cl*dtp*r**2*sint
         gpp = (1+cl*dpp)*r**2*sint**2
      endif

C     Transform the spherical coordinates to cartesian
      call spheretocart(
     &     nx,ny,nz,
     &     x,y,z,r,
     &     grr,grt,grp,gtt,gtp,gpp,
     &     gxx,gxy,gxz,gyy,gyz,gzz)

      return
      end
*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>



*==============================================================================
*
*  [ROUTINE NAME] Spheretocart
*  [AUTHOR] Joan Masso, NCSA & UIB
*           Based on an original routine by Malcolm Tobias, WashU.
* 
*  [PURPOSE] Convert spherical metric components to cartesian
*
*  [ARGUMENTS] 
*     [INPUT]
*        nx,ny,nz   : grid sizes of the 3d cube.
*        x,y,z,r    : grid vectors
*        grr,grt,...: Metric tensor in spherical coordinates
*     [OUTPUT]
*        gxx,gxy,...: Metric tensor in cartesian coordinates
* 
*  [VARIABLES] 3d arrays for coordinate derivative terms
*
*  [CALLED BY]  Analywave
*
*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

      subroutine spheretocart(
     &     nx,ny,nz,
     &     x,y,z,r,
     &     grr,grt,grp,gtt,gtp,gpp,
     &     gxx,gxy,gxz,gyy,gyz,gzz)

      implicit NONE

      integer nx,ny,nz

      real x(nx,ny,nz),y(nx,ny,nz),z(nx,ny,nz),r(nx,ny,nz)

      real grr(nx,ny,nz),grt(nx,ny,nz),grp(nx,ny,nz),
     &     gtt(nx,ny,nz),gtp(nx,ny,nz),gpp(nx,ny,nz)

      real gxx(nx,ny,nz),gxy(nx,ny,nz),gxz(nx,ny,nz),
     &     gyy(nx,ny,nz),gyz(nx,ny,nz),gzz(nx,ny,nz)
      
      
c     define derivatives drx = (dr/dx)
      real drx(nx,ny,nz),dry(nx,ny,nz),drz(nx,ny,nz)
      real dtx(nx,ny,nz),dty(nx,ny,nz),dtz(nx,ny,nz)
      real dpx(nx,ny,nz),dpy(nx,ny,nz),dpz(nx,ny,nz)
      
      drx = x/r
      dry = y/r
      drz = z/r
      
      dtx = x*z/(r**2*sqrt(x**2+y**2))
      dty = y*z/(r**2*sqrt(x**2+y**2))
      dtz = (z**2/r**2-1)/sqrt(x**2+y**2)
      
      dpx = -y/(x**2+y**2)
      dpy = x/(x**2+y**2)
      dpz = 0.
      
      gxx = drx**2*grr+2.*drx*dtx*grt+2.*drx*dpx*grp+dtx**2*gtt+
     &     2.*dtx*dpx*gtp+dpx**2*gpp
      
      gyy = dry**2*grr+2.*dry*dty*grt+2.*dry*dpy*grp+dty**2*gtt+
     &     2.*dty*dpy*gtp+dpy**2*gpp
      
      gzz = drz**2*grr+2.*drz*dtz*grt+2.*drz*dpz*grp+dtz**2*gtt+
     &     2.*dtz*dpz*gtp+dpz**2*gpp
      
      gxy = drx*dry*grr+(drx*dty+dtx*dry)*grt+(drx*dpy+dpx*dry)*grp
     &     +dtx*dty*gtt+(dtx*dpy+dpx*dty)*gtp+dpx*dpy*gpp
      
      gxz = drx*drz*grr+(drx*dtz+dtx*drz)*grt+(drx*dpz+dpx*drz)*grp
     &     +dtx*dtz*gtt+(dtx*dpz+dpx*dtz)*gtp+dpx*dpz*gpp
      
      gyz = dry*drz*grr+(dry*dtz+dty*drz)*grt+(dry*dpz+dpy*drz)*grp
     &     +dty*dtz*gtt+(dty*dpz+dpy*dtz)*gtp+dpy*dpz*gpp
      
      return
      end
*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>








*==============================================================================
*
*  [ROUTINE NAME] Curelation
*  [AUTHOR] Joan Masso, NCSA & UIB
* 
*  [PURPOSE] Compute the vector $\Gamma^i$ based on the metric and
*            derivatives and the algebraic relation that holds at
*            the initial time. 
*  [WARNING] Only valid for the initial time, when the lapse is 
*            spatially constant and the derivatives are zero.
*
*  [ARGUMENTS] 
*     [INPUT]
*        nx,ny,nz   : grid sizes of the 3d cube.
*        uxx,uxy,...: Contravarian ("up") metric tensor
*        gxx,gxy,...: Covariant ("down")  metric tensor
*        dxuxx,.....: All derivatives of the "up" metric tensor.
*     [OUTPUT]
*        cux,cuy,cuz: Momemtum related vector $\Gamma^i$
* 
*  [CALLED BY]  Initial
*
*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

      subroutine Curelation(nx,ny,nz,
     &               uxx,uxy,uxz,uyy,uyz,uzz,
     &               gxx,gxy,gxz,gyy,gyz,gzz,
     &               dxuxx,dxuxy,dxuxz,dxuyy,dxuyz,dxuzz,
     &               dyuxx,dyuxy,dyuxz,dyuyy,dyuyz,dyuzz,
     &               dzuxx,dzuxy,dzuxz,dzuyy,dzuyz,dzuzz,
     &               cux, cuy, cuz)

      implicit none
      integer nx,ny,nz


      real cux(nx,ny,nz),cuy(nx,ny,nz),cuz(nx,ny,nz)
      real uxx(nx,ny,nz),uxy(nx,ny,nz),uxz(nx,ny,nz)
      real uyy(nx,ny,nz),uyz(nx,ny,nz),uzz(nx,ny,nz)
      real gxx(nx,ny,nz),gxy(nx,ny,nz),gxz(nx,ny,nz)
      real gyy(nx,ny,nz),gyz(nx,ny,nz),gzz(nx,ny,nz)
      real dxuxx(nx,ny,nz),dxuxy(nx,ny,nz),dxuxz(nx,ny,nz)
      real dxuyy(nx,ny,nz),dxuyz(nx,ny,nz),dxuzz(nx,ny,nz)
      real dyuxx(nx,ny,nz),dyuxy(nx,ny,nz),dyuxz(nx,ny,nz)
      real dyuyy(nx,ny,nz),dyuyz(nx,ny,nz),dyuzz(nx,ny,nz)
      real dzuxx(nx,ny,nz),dzuxy(nx,ny,nz),dzuxz(nx,ny,nz)
      real dzuyy(nx,ny,nz),dzuyz(nx,ny,nz),dzuzz(nx,ny,nz)


        cux = - dxuxx-dyuxy-dzuxz
     &        + dxuxx*uxx*gxx/2  + dyuxx*uxy*gxx/2  + dzuxx*uxz*gxx/2
     &        + dxuxy*uxx*gxy + dyuxy*uxy*gxy + dzuxy*uxz*gxy
     &        + dxuxz*uxx*gxz + dyuxz*uxy*gxz + dzuxz*uxz*gxz
     &        + dxuyy*uxx*gyy/2 + dyuyy*uxy*gyy/2 + dzuyy*uxz*gyy/2
     &        + dxuyz*uxx*gyz + dyuyz*uxy*gyz + dzuyz*uxz*gyz
     &        + dxuzz*uxx*gzz/2 + dyuzz*uxy*gzz/2 + dzuzz*uxz*gzz/2


        cuy = - dxuxy - dyuyy - dzuyz
     &       + dxuxx*uxy*gxx/2+ dyuxx*uyy*gxx/2 + dzuxx*uyz*gxx/2
     &       + dxuxy*uxy*gxy+ dyuxy*uyy*gxy+ dzuxy*uyz*gxy
     &       + dxuxz*uxy*gxz+ dyuxz*uyy*gxz+ dzuxz*uyz*gxz
     &       + dxuyy*uxy*gyy/2+ dyuyy*uyy*gyy/2+ dzuyy*uyz*gyy/2
     &       + dxuyz*uxy*gyz+ dyuyz*uyy*gyz+ dzuyz*uyz*gyz
     &       + dxuzz*uxy*gzz/2+ dyuzz*uyy*gzz/2+ dzuzz*uyz*gzz/2


        cuz = - dxuxz - dyuyz - dzuzz
     &       + dxuxx*uxz*gxx/2+ dyuxx*uyz*gxx/2 + dzuxx*uzz*gxx/2
     &       + dxuxy*uxz*gxy+ dyuxy*uyz*gxy+ dzuxy*uzz*gxy
     &       + dxuxz*uxz*gxz+ dyuxz*uyz*gxz+ dzuxz*uzz*gxz
     &       + dxuyy*uxz*gyy/2+ dyuyy*uyz*gyy/2+ dzuyy*uzz*gyy/2
     &       + dxuyz*uxz*gyz+ dyuyz*uyz*gyz+ dzuyz*uzz*gyz
     &       + dxuzz*uxz*gzz/2+ dyuzz*uyz*gzz/2+ dzuzz*uzz*gzz/2


      return
      end
*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


*==============================================================================
*
*  [ROUTINE NAME] Centralderiv
*  [AUTHOR] Joan Masso, NCSA & UIB
* 
*  [PURPOSE] Compute the derivatives of the metric tensor
*            with a central finite differencing scheme that 
*            assumes a regular grid spacing. The finite
*            differencing is implemented using triplet notation.
*
*            At the boundaries, the derivatives are computed
*            by linear extrapolation of the interior derivatives.
*
*  [ARGUMENTS] 
*     [INPUT]
*        nx,ny,nz   : grid sizes of the 3d cube.
*        dx,dy,dz   : grid spacing: regular grid assumed.
*        uxx,uxy,...: Metric tensor
*     [OUTPUT]
*        dxuxx,.....: All derivatives of the metric tensor.
* 
*  [CALLED BY]  Initial
*
*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
      subroutine Centralderiv(
     &     nx,ny,nz,
     &     dx,dy,dz,
     &     uxx,uxy,uxz,uyy,uyz,uzz,
     &     dxuxx,dyuxx,dzuxx,
     &     dxuxy,dyuxy,dzuxy,
     &     dxuxz,dyuxz,dzuxz,
     &     dxuyy,dyuyy,dzuyy,
     &     dxuyz,dyuyz,dzuyz,
     &     dxuzz,dyuzz,dzuzz)

      
      implicit none
      integer nx,ny,nz
      real dx,dy,dz

      real uxx(nx,ny,nz),uxy(nx,ny,nz),uxz(nx,ny,nz)
      real uyy(nx,ny,nz),uyz(nx,ny,nz),uzz(nx,ny,nz)

      real dxuxx(nx,ny,nz),dxuxy(nx,ny,nz),dxuxz(nx,ny,nz)
      real dxuyy(nx,ny,nz),dxuyz(nx,ny,nz),dxuzz(nx,ny,nz)
      real dyuxx(nx,ny,nz),dyuxy(nx,ny,nz),dyuxz(nx,ny,nz)
      real dyuyy(nx,ny,nz),dyuyz(nx,ny,nz),dyuzz(nx,ny,nz)
      real dzuxx(nx,ny,nz),dzuxy(nx,ny,nz),dzuxz(nx,ny,nz)
      real dzuyy(nx,ny,nz),dzuyz(nx,ny,nz),dzuzz(nx,ny,nz)

c     X direction
c     Centered differencing in the interior.
      dxuxx(2:nx-1,:,:) = ( uxx(3:nx,:,:) - uxx(1:nx-2,:,:) )/2./dx
      dxuxy(2:nx-1,:,:) = ( uxy(3:nx,:,:) - uxy(1:nx-2,:,:) )/2./dx
      dxuxz(2:nx-1,:,:) = ( uxz(3:nx,:,:) - uxz(1:nx-2,:,:) )/2./dx
      dxuyy(2:nx-1,:,:) = ( uyy(3:nx,:,:) - uyy(1:nx-2,:,:) )/2./dx
      dxuyz(2:nx-1,:,:) = ( uyz(3:nx,:,:) - uyz(1:nx-2,:,:) )/2./dx
      dxuzz(2:nx-1,:,:) = ( uzz(3:nx,:,:) - uzz(1:nx-2,:,:) )/2./dx

c     Linear extrapolation on a regular grid is trivial... at both ends.
      dxuxx(1,:,:) = 2.*dxuxx(2,:,:) - dxuxx(3,:,:)
      dxuxy(1,:,:) = 2.*dxuxy(2,:,:) - dxuxy(3,:,:)
      dxuxz(1,:,:) = 2.*dxuxz(2,:,:) - dxuxz(3,:,:)
      dxuyy(1,:,:) = 2.*dxuyy(2,:,:) - dxuyy(3,:,:)
      dxuyz(1,:,:) = 2.*dxuyz(2,:,:) - dxuyz(3,:,:)
      dxuzz(1,:,:) = 2.*dxuzz(2,:,:) - dxuzz(3,:,:)             
      dxuxx(nx,:,:) = 2.*dxuxx(nx-1,:,:) - dxuxx(nx-2,:,:)
      dxuxy(nx,:,:) = 2.*dxuxy(nx-1,:,:) - dxuxy(nx-2,:,:)
      dxuxz(nx,:,:) = 2.*dxuxz(nx-1,:,:) - dxuxz(nx-2,:,:)
      dxuyy(nx,:,:) = 2.*dxuyy(nx-1,:,:) - dxuyy(nx-2,:,:)
      dxuyz(nx,:,:) = 2.*dxuyz(nx-1,:,:) - dxuyz(nx-2,:,:)
      dxuzz(nx,:,:) = 2.*dxuzz(nx-1,:,:) - dxuzz(nx-2,:,:)             

c     Y direction
      dyuxx(:,2:ny-1,:) = ( uxx(:,3:ny,:) - uxx(:,1:ny-2,:) )/2./dy
      dyuxy(:,2:ny-1,:) = ( uxy(:,3:ny,:) - uxy(:,1:ny-2,:) )/2./dy
      dyuxz(:,2:ny-1,:) = ( uxz(:,3:ny,:) - uxz(:,1:ny-2,:) )/2./dy
      dyuyy(:,2:ny-1,:) = ( uyy(:,3:ny,:) - uyy(:,1:ny-2,:) )/2./dy
      dyuyz(:,2:ny-1,:) = ( uyz(:,3:ny,:) - uyz(:,1:ny-2,:) )/2./dy
      dyuzz(:,2:ny-1,:) = ( uzz(:,3:ny,:) - uzz(:,1:ny-2,:) )/2./dy
      dyuxx(:,1,:) = 2.*dyuxx(:,2,:) - dyuxx(:,3,:)
      dyuxy(:,1,:) = 2.*dyuxy(:,2,:) - dyuxy(:,3,:)
      dyuxz(:,1,:) = 2.*dyuxz(:,2,:) - dyuxz(:,3,:)
      dyuyy(:,1,:) = 2.*dyuyy(:,2,:) - dyuyy(:,3,:)
      dyuyz(:,1,:) = 2.*dyuyz(:,2,:) - dyuyz(:,3,:)
      dyuzz(:,1,:) = 2.*dyuzz(:,2,:) - dyuzz(:,3,:)       
      dyuxx(:,ny,:) = 2.*dyuxx(:,ny-1,:) - dyuxx(:,ny-2,:)
      dyuxy(:,ny,:) = 2.*dyuxy(:,ny-1,:) - dyuxy(:,ny-2,:)
      dyuxz(:,ny,:) = 2.*dyuxz(:,ny-1,:) - dyuxz(:,ny-2,:)
      dyuyy(:,ny,:) = 2.*dyuyy(:,ny-1,:) - dyuyy(:,ny-2,:)
      dyuyz(:,ny,:) = 2.*dyuyz(:,ny-1,:) - dyuyz(:,ny-2,:)
      dyuzz(:,ny,:) = 2.*dyuzz(:,ny-1,:) - dyuzz(:,ny-2,:)       

c     Z direction
      dzuxx(:,:,2:nz-1) = ( uxx(:,:,3:nz) - uxx(:,:,1:nz-2) )/2./dz
      dzuxy(:,:,2:nz-1) = ( uxy(:,:,3:nz) - uxy(:,:,1:nz-2) )/2./dz
      dzuxz(:,:,2:nz-1) = ( uxz(:,:,3:nz) - uxz(:,:,1:nz-2) )/2./dz
      dzuyy(:,:,2:nz-1) = ( uyy(:,:,3:nz) - uyy(:,:,1:nz-2) )/2./dz
      dzuyz(:,:,2:nz-1) = ( uyz(:,:,3:nz) - uyz(:,:,1:nz-2) )/2./dz
      dzuzz(:,:,2:nz-1) = ( uzz(:,:,3:nz) - uzz(:,:,1:nz-2) )/2./dz
      dzuxx(:,:,1) = 2.*dzuxx(:,:,2) - dzuxx(:,:,3)
      dzuxy(:,:,1) = 2.*dzuxy(:,:,2) - dzuxy(:,:,3)
      dzuxz(:,:,1) = 2.*dzuxz(:,:,2) - dzuxz(:,:,3)
      dzuyy(:,:,1) = 2.*dzuyy(:,:,2) - dzuyy(:,:,3)
      dzuyz(:,:,1) = 2.*dzuyz(:,:,2) - dzuyz(:,:,3)
      dzuzz(:,:,1) = 2.*dzuzz(:,:,2) - dzuzz(:,:,3)       
      dzuxx(:,:,nz) = 2.*dzuxx(:,:,nz-1) - dzuxx(:,:,nz-2)
      dzuxy(:,:,nz) = 2.*dzuxy(:,:,nz-1) - dzuxy(:,:,nz-2)
      dzuxz(:,:,nz) = 2.*dzuxz(:,:,nz-1) - dzuxz(:,:,nz-2)
      dzuyy(:,:,nz) = 2.*dzuyy(:,:,nz-1) - dzuyy(:,:,nz-2)
      dzuyz(:,:,nz) = 2.*dzuyz(:,:,nz-1) - dzuyz(:,:,nz-2)
      dzuzz(:,:,nz) = 2.*dzuzz(:,:,nz-1) - dzuzz(:,:,nz-2)       


      return
      end
*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

