*******************************************************************************
*
* [INCLUDE FILE] metric.h
* [VERSION]      H3expresso  (c) 1995 Joan Masso, NCSA & UIB
*
* [PURPOSE]      Declare the "Data Structures" of H3expresso, that is,
*                all the grid and metric variables
*
* [INCLUDED IN]  H3
*                Initial
*                Method
*                Sources
*                Fluxes
*                Boundaries 
*
******************************* 3-D vars **************************************

c $x,y,z,r$ : Spatial vectors and radius
      real x(nx,ny,nz),y(nx,ny,nz),z(nx,ny,nz),r(nx,ny,nz)

c $\Psi$ : conformal factor Psi 
      real psi(nx,ny,nz)

c $\alpha$ : Lapse 
      real alp(nx,ny,nz)

c $\Gamma^i$ : Momentum constraint related var  
      real cux(nx,ny,nz),cuy(nx,ny,nz),cuz(nx,ny,nz)

c $g^{ij}$ : Contravariant "upper" metric 
      real uxx(nx,ny,nz),uxy(nx,ny,nz),uxz(nx,ny,nz)
     &    ,uyy(nx,ny,nz),uyz(nx,ny,nz),uzz(nx,ny,nz)

c $g_{ij}$ : Covariant "down" metric
c           ==> It is NOT evolved but computed from the contravariant metric.
      real gxx(nx,ny,nz),gxy(nx,ny,nz),gxz(nx,ny,nz)
     &    ,gyy(nx,ny,nz),gyz(nx,ny,nz),gzz(nx,ny,nz)
c $\sqrt{g}$ : root of the covariant metric determinant 
      real rg(nx,ny,nz)

c $q^{ij}  = 2 \sqrt{g} k^{ij} $ : Extrinsic curvature related var 
      real qxx(nx,ny,nz),qxy(nx,ny,nz),qxz(nx,ny,nz)
     &    ,qyy(nx,ny,nz),qyz(nx,ny,nz),qzz(nx,ny,nz)

c $\partial_k g^{ij}$ : Derivatives of the contravariant upper metric 
c     x derivs
      real dxuxx(nx,ny,nz),dxuxy(nx,ny,nz),dxuxz(nx,ny,nz)
     &    ,dxuyy(nx,ny,nz),dxuyz(nx,ny,nz),dxuzz(nx,ny,nz)
c     y derivs
      real dyuxx(nx,ny,nz),dyuxy(nx,ny,nz),dyuxz(nx,ny,nz)
     &    ,dyuyy(nx,ny,nz),dyuyz(nx,ny,nz),dyuzz(nx,ny,nz)
c     z derivs
      real dzuxx(nx,ny,nz),dzuxy(nx,ny,nz),dzuxz(nx,ny,nz)
     &    ,dzuyy(nx,ny,nz),dzuyz(nx,ny,nz),dzuzz(nx,ny,nz)

*******************************************************************************

#ifdef CM5
cmf$ layout x(:news,:news,:news)
cmf$ layout y(:news,:news,:news)
cmf$ layout z(:news,:news,:news)
cmf$ layout r(:news,:news,:news)
cmf$ layout psi(:news,:news,:news)
cmf$ layout alp(:news,:news,:news)
cmf$ layout cux(:news,:news,:news)
cmf$ layout cuy(:news,:news,:news)
cmf$ layout cuz(:news,:news,:news)
cmf$ layout uxx(:news,:news,:news)
cmf$ layout uxy(:news,:news,:news)
cmf$ layout uxz(:news,:news,:news)
cmf$ layout uyy(:news,:news,:news)
cmf$ layout uyz(:news,:news,:news)
cmf$ layout uzz(:news,:news,:news)
cmf$ layout gxx(:news,:news,:news)
cmf$ layout gxy(:news,:news,:news)
cmf$ layout gxz(:news,:news,:news)
cmf$ layout gyy(:news,:news,:news)
cmf$ layout gyz(:news,:news,:news)
cmf$ layout gzz(:news,:news,:news)
cmf$ layout rg(:news,:news,:news)
cmf$ layout qxx(:news,:news,:news)
cmf$ layout qxy(:news,:news,:news)
cmf$ layout qxz(:news,:news,:news)
cmf$ layout qyy(:news,:news,:news)
cmf$ layout qyz(:news,:news,:news)
cmf$ layout qzz(:news,:news,:news)
cmf$ layout dxuxx(:news,:news,:news)
cmf$ layout dxuxy(:news,:news,:news)
cmf$ layout dxuxz(:news,:news,:news)
cmf$ layout dxuyy(:news,:news,:news)
cmf$ layout dxuyz(:news,:news,:news)
cmf$ layout dxuzz(:news,:news,:news)
cmf$ layout dyuxx(:news,:news,:news)
cmf$ layout dyuxy(:news,:news,:news)
cmf$ layout dyuxz(:news,:news,:news)
cmf$ layout dyuyy(:news,:news,:news)
cmf$ layout dyuyz(:news,:news,:news)
cmf$ layout dyuzz(:news,:news,:news)
cmf$ layout dzuxx(:news,:news,:news)
cmf$ layout dzuxy(:news,:news,:news)
cmf$ layout dzuxz(:news,:news,:news)
cmf$ layout dzuyy(:news,:news,:news)
cmf$ layout dzuyz(:news,:news,:news)
cmf$ layout dzuzz(:news,:news,:news)
#endif
