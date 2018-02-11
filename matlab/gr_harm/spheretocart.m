function [gxx,gxy,gxz,gyy,gyz,gzz] = spheretocart(nx,ny,nz,x,y,z,r,grr,grt,grp,gtt,gtp,gpp)
%   [gxx,gxy,gxz,gyy,gyz,gzz] = spheretocart(nx,ny,nz,x,y,z,r,grr,grt,grp,gtt,gtp,gpp)
%  [PURPOSE] Convert spherical metric components to cartesian
%
%  [ARGUMENTS] 
%     [INPUT]
%        nx,ny,nz   : grid sizes of the 3d cube.
%        x,y,z,r    : grid vectors
%        grr,grt,...: Metric tensor in spherical coordinates
%     [OUTPUT]
%        gxx,gxy,...: Metric tensor in cartesian coordinates
% 
%  [VARIABLES] 3d arrays for coordinate derivative terms
%
%  [CALLED BY]  analywave.m

%     real x(nx,ny,nz),y(nx,ny,nz),z(nx,ny,nz),r(nx,ny,nz)

%      real grr(nx,ny,nz),grt(nx,ny,nz),grp(nx,ny,nz),
%     &     gtt(nx,ny,nz),gtp(nx,ny,nz),gpp(nx,ny,nz)

%      real gxx(nx,ny,nz),gxy(nx,ny,nz),gxz(nx,ny,nz),
%     &     gyy(nx,ny,nz),gyz(nx,ny,nz),gzz(nx,ny,nz)
      
      
%     define derivatives drx = (dr/dx)
%      real drx(nx,ny,nz),dry(nx,ny,nz),drz(nx,ny,nz)
%      real dtx(nx,ny,nz),dty(nx,ny,nz),dtz(nx,ny,nz)
%      real dpx(nx,ny,nz),dpy(nx,ny,nz),dpz(nx,ny,nz)
      
      drx = x./r;
      dry = y./r;
      drz = z./r;
      
      dtx = x.*z./(r.^2.*sqrt(x.^2+y.^2));
      dty = y.*z./(r.^2.*sqrt(x.^2+y.^2));
      dtz = (z.^2./r.^2-1)./sqrt(x.^2+y.^2);
      
      dpx = -y./(x.^2+y.^2);
      dpy = x./(x.^2+y.^2);
      dpz = 0.;
      
      gxx = drx.^2.*grr+2.*drx.*dtx.*grt+2.*drx.*dpx.*grp+dtx.^2.*gtt+2.*dtx.*dpx.*gtp+dpx.^2.*gpp;
      
      gyy = dry.^2.*grr+2..*dry.*dty.*grt+2..*dry.*dpy.*grp+dty.^2.*gtt+2..*dty.*dpy.*gtp+dpy.^2.*gpp;
      
      gzz = drz.^2.*grr+2..*drz.*dtz.*grt+2..*drz.*dpz.*grp+dtz.^2.*gtt+2..*dtz.*dpz.*gtp+dpz.^2.*gpp;
      
      gxy = drx.*dry.*grr+(drx.*dty+dtx.*dry).*grt+(drx.*dpy+dpx.*dry).*grp+dtx.*dty.*gtt+(dtx.*dpy+dpx.*dty).*gtp+dpx.*dpy.*gpp;
      
      gxz = drx.*drz.*grr+(drx.*dtz+dtx.*drz).*grt+(drx.*dpz+dpx.*drz).*grp+dtx.*dtz.*gtt+(dtx.*dpz+dpx.*dtz).*gtp+dpx.*dpz.*gpp;
      
      gyz = dry.*drz.*grr+(dry.*dtz+dty.*drz).*grt+(dry.*dpz+dpy.*drz).*grp+dty.*dtz.*gtt+(dty.*dpz+dpy.*dtz).*gtp+dpy.*dpz.*gpp;



%endfunction
