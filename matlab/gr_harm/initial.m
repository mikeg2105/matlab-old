function [x,y,z,r,psi,alp,cux,cuy,cuz,rg,uxx,uxy,uxz,uyy,uyz,uzz,gxx,gxy,gxz,gyy,gyz,gzz,qxx,qxy,qxz,qyy,qyz,qzz,dxuxx,dxuxy,dxuxz,dxuyy,dxuyz,dxuzz,dyuxx,dyuxy,dyuxz,dyuyy,dyuyz,dyuzz,dzuxx,dzuxy,dzuxz,dzuyy,dzuyz,dzuzz] = initial(nx,ny,nz,dx,dy,dz,par1,par2,time,dt)
%  initial
% [x,y,z,r,psi,alp,cux,cuy,cuz,rg,uxx,uxy,uxz,uyy,uyz,uzz,gxx,gxy,gxz,gyy,gyz,gzz,qxx,qxy,qxz,qyy,qyz,qzz,dxuxx,dxuxy,dxuxz,dxuyy,dxuyz,dxuzz,dyuxx,dyuxy,dyuxz,dyuyy,dyuyz,dyuzz,dzuxx,dzuxy,dzuxz,dzuyy,dzuyz,dzuzz] = initial(nx,ny,nz,dx,dy,dz,par1,par2,time,dt)


% $x,y,z,r$ : Spatial vectors and radius
%      real x(nx,ny,nz),y(nx,ny,nz),z(nx,ny,nz),r(nx,ny,nz)
       x=zeros(nx,ny,nz);
       y=zeros(nx,ny,nz);
       z=zeros(nx,ny,nz);
       r=zeros(nx,ny,nz);
% $\Psi$ : conformal factor Psi 
% real psi(nx,ny,nz)
       psi=zeros(nx,ny,nz);
% $\alpha$ : Lapse 
%      real alp(nx,ny,nz)
        alp=zeros(nx,ny,nz);
        alp(nx/2,ny/2,nz/2)=0.01;

% $\Gamma^i$ : Momentum constraint related var  
%      real cux(nx,ny,nz),cuy(nx,ny,nz),cuz(nx,ny,nz)
       cux=zeros(nx,ny,nz);
       cuy=zeros(nx,ny,nz);
       cuz=zeros(nx,ny,nz);
       
% $g^{ij}$ : Contravariant "upper" metric 
%      real uxx(nx,ny,nz),uxy(nx,ny,nz),uxz(nx,ny,nz)
%     &    ,uyy(nx,ny,nz),uyz(nx,ny,nz),uzz(nx,ny,nz)
       uxx=zeros(nx,ny,nz);
       uxy=zeros(nx,ny,nz);
       uxz=zeros(nx,ny,nz);
       uyy=zeros(nx,ny,nz);
       uyz=zeros(nx,ny,nz);
       uzz=zeros(nx,ny,nz);       
% $g_{ij}$ : Covariant "down" metric
%           ==> It is NOT evolved but computed from the contravariant metric.
%      real gxx(nx,ny,nz),gxy(nx,ny,nz),gxz(nx,ny,nz)
%     &    ,gyy(nx,ny,nz),gyz(nx,ny,nz),gzz(nx,ny,nz)

       gxx=zeros(nx,ny,nz);
       gxy=zeros(nx,ny,nz);
       gxz=zeros(nx,ny,nz);
       gyy=zeros(nx,ny,nz);
       gyz=zeros(nx,ny,nz);
       gzz=zeros(nx,ny,nz);
% $\sqrt{g}$ : root of the covariant metric determinant 
%      real rg(nx,ny,nz)
       rg=ones(nx,ny,nz);
% $q^{ij}  = 2 \sqrt{g} k^{ij} $ : Extrinsic curvature related var 
%      real qxx(nx,ny,nz),qxy(nx,ny,nz),qxz(nx,ny,nz)
%     &    ,qyy(nx,ny,nz),qyz(nx,ny,nz),qzz(nx,ny,nz)
       qxx=zeros(nx,ny,nz);
       qxy=zeros(nx,ny,nz);
       qxz=zeros(nx,ny,nz);
       qyy=zeros(nx,ny,nz);
       qyz=zeros(nx,ny,nz);
       qzz=zeros(nx,ny,nz);
% $\partial_k g^{ij}$ : Derivatives of the contravariant upper metric 
%     x derivs
%     real dxuxx(nx,ny,nz),dxuxy(nx,ny,nz),dxuxz(nx,ny,nz)
%     &    ,dxuyy(nx,ny,nz),dxuyz(nx,ny,nz),dxuzz(nx,ny,nz)
       dxuxx=zeros(nx,ny,nz);
       dxuxy=zeros(nx,ny,nz);
       dxuxz=zeros(nx,ny,nz);
       dxuyy=zeros(nx,ny,nz);
       dxuyz=zeros(nx,ny,nz);
       dxuzz=zeros(nx,ny,nz); 


%     y derivs
%     real dyuxx(nx,ny,nz),dyuxy(nx,ny,nz),dyuxz(nx,ny,nz)
%     &    ,dyuyy(nx,ny,nz),dyuyz(nx,ny,nz),dyuzz(nx,ny,nz)
       dyuxx=zeros(nx,ny,nz);
       dyuxy=zeros(nx,ny,nz);
       dyuxz=zeros(nx,ny,nz);
       dyuyy=zeros(nx,ny,nz);
       dyuyz=zeros(nx,ny,nz);
       dyuzz=zeros(nx,ny,nz); 


%     z derivs
%      real dzuxx(nx,ny,nz),dzuxy(nx,ny,nz),dzuxz(nx,ny,nz)
%     &    ,dzuyy(nx,ny,nz),dzuyz(nx,ny,nz),dzuzz(nx,ny,nz)
       dzuxx=zeros(nx,ny,nz);
       dzuxy=zeros(nx,ny,nz);
       dzuxz=zeros(nx,ny,nz);
       dzuyy=zeros(nx,ny,nz);
       dzuyz=zeros(nx,ny,nz);
       dzuzz=zeros(nx,ny,nz); 


      
      
%     Initialize the grid vectors $x,y,z$  grid going from -xmax to xmax
%     We use triplet notation to avoid loops around the other directions.

      for i=1:nx 
         x(i,:,:)= (i-1-(nx-1)/2)*dx;  
      end
      for j=1:ny 
         y(:,j,:)= (j-1-(ny-1)/2)*dy;  
      end
      for k=1:nz 
         z(:,:,k)= (k-1-(nz-1)/2)*dz;  
      end
      
%     compute radial coordinate $r$
      r = sqrt(x.^2 + y.^2 + z.^2);

%     Conformal factor $\psi$ for the linearized waves is simply one.
%     It should not be used anywhere and has been kept to avoid changing
%     the data structure between H3.3 and H3expresso.
      psi= 1;

%     Initial Gauge choice: lapse $\alpha = 1$
%      alp= 1;
      
%     Covariant metric $g_{ij}$ is computed analytically and depends
%     on the parameters par1 and par2
      [gxx,gxy,gxz,gyy,gyz,gzz]=analywave(nx,ny,nz,time,par1,par2,x,y,z,r);     
      
%     At t=0. (H3expresso) we have time symmetry so the extrinsic
%     curvature related quantities are zero.
%      qxx = 0.
%      qxy = 0.
%      qxz = 0.
%      qyy = 0.
%      qyz = 0.
%      qzz = 0.
      
%     Now we compute the contravariant metric $g^{ij}$ which is our
%     evolved metric.
      [uxx,uxy,uxz,uyy,uyz,uzz,rg]=invert(nx,ny,nz,...
          -1,gxx,gxy,gxz,gyy,gyz,gzz);
      
      
%     We also need the derivatives at the initial time.
%     Because the analytic expressions are VERY cumbersome, we
%     will use a patch  and compute them as central differences
      [dxuxx,dyuxx,dzuxx,...
          dxuxy,dyuxy,dzuxy,...
          dxuxz,dyuxz,dzuxz,...
          dxuyy,dyuyy,dzuyy,...
          dxuyz,dyuyz,dzuyz,...
          dxuzz,dyuzz,dzuzz]=centralderiv(...
          nx,ny,nz,...
          dx,dy,dz,...
          uxx,uxy,uxz,uyy,uyz,uzz);

      
      
%     Finally, we need the momentum related quantities $\Gamma^i$
%     so we will use the constrained relations at the initial time
%     to derive them. NOTE that they are only Valid for a constant lapse.
      [cux, cuy, cuz]=curelation(nx,ny,nz,...
                    uxx,uxy,uxz,uyy,uyz,uzz,...
                    gxx,gxy,gxz,gyy,gyz,gzz,...
                    dxuxx,dxuxy,dxuxz,dxuyy,dxuyz,dxuzz,...
                    dyuxx,dyuxy,dyuxz,dyuyy,dyuyz,dyuzz,...
                    dzuxx,dzuxy,dzuxz,dzuyy,dzuyz,dzuzz);
      