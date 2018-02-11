function [gxx,gxy,gxz,gyy,gyz,gzz] = cyltocart(nx,ny,nz,x,y,z,r,grr,grt,grz,gtt,gtz,gzz)
//   [gxx,gxy,gxz,gyy,gyz,gzz] = spheretocart(nx,ny,nz,x,y,z,r,grr,grt,grz,gtt,gtz,gzz)
//  [PURPOSE] Convert spherical metric components to cartesian
//
//  [ARGUMENTS] 
//     [INPUT]
//        nx,ny,nz   : grid sizes of the 3d cube.
//        x,y,z,r    : grid vectors
//        grr,grt,...: Metric tensor in spherical coordinates
//     [OUTPUT]
//        gxx,gxy,...: Metric tensor in cartesian coordinates
// 
//  [VARIABLES] 3d arrays for coordinate derivative terms
//
//  [CALLED BY]  analywave.m

//     real x(nx,ny,nz),y(nx,ny,nz),z(nx,ny,nz),r(nx,ny,nz)

//      real grr(nx,ny,nz),grt(nx,ny,nz),grp(nx,ny,nz),
//     &     gtt(nx,ny,nz),gtp(nx,ny,nz),gpp(nx,ny,nz)

//      real gxx(nx,ny,nz),gxy(nx,ny,nz),gxz(nx,ny,nz),
//     &     gyy(nx,ny,nz),gyz(nx,ny,nz),gzz(nx,ny,nz)
      
      
//     define derivatives drx = (dr/dx)
//      real drx(nx,ny,nz),dry(nx,ny,nz),drz(nx,ny,nz)
//      real dtx(nx,ny,nz),dty(nx,ny,nz),dtz(nx,ny,nz)
//      real dpx(nx,ny,nz),dpy(nx,ny,nz),dpz(nx,ny,nz)
      
      drx = x./r;
      dry = y./r;
      drz = 0;
      
      dtx = -y./(r.^2);
      dty = x./((r.^2);
      dtz = 0;
      
      dzx = 0;
      dzy = 0;
      dzz = 1;
      
      gxx = (drx.^2).*grr+2.*drx.*dtx.*grt+2.*drx.*dpx.*grz+(dtx.^2).*gtt+2.*dtx.*dzx.*gtz+(dzx.^2).*gzz;
      
      gyy = (dry.^2).*grr+2*dry.*dty.*grt+2*dry.*dzy.*grz+(dty.^2).*gtt+2*dty.*dzy.*gtz+(dzy.^2).*gzz;
      
      gzz = (drz.^2).*grr+2*drz.*dtz.*grt+2*drz.*dzz.*grz+(dtz.^2).*gtt+2*dtz.*dzz.*gtz+(dzz.^2).*gzz;
      
      gxy = drx.*dry.*grr+(drx.*dty+dtx.*dry).*grt+(drx.*dzy+dzx.*dry).*grz+dtx.*dty.*gtt+(dtx.*dzy+dzx.*dty).*gtz+dzx.*dzy.*gzz;
      
      gxz = drx.*drz.*grr+(drx.*dtz+dtx.*drz).*grt+(drx.*dzz+dzx.*drz).*grz+dtx.*dtz.*gtt+(dtx.*dzz+dzx.*dtz).*gtz+dzx.*dzz.*gzz;
      
      gyz = dry.*drz.*grr+(dry.*dtz+dty.*drz).*grt+(dry.*dzz+dzy.*drz).*grz+dty.*dtz.*gtt+(dty.*dzz+dzy.*dtz).*gtz+dzy.*dzz.*gzz;



endfunction
