function [alp,cux,cuy,cuz,uxx,uxy,uxz,uyy,uyz,uzz,qxx,qxy,qxz,qyy,qyz,qzz,dxuxx,dxuxy,dxuxz,dxuyy,dxuyz,dxuzz,...
             dyuxx,dyuxy,dyuxz,dyuyy,dyuyz,dyuzz,...
             dzuxx,dzuxy,dzuxz,dzuyy,dzuyz,dzuzz]=method_grobj(...
             nx,ny,nz,...
             dt,dx,dy,dz,...
             x,y,z,r,psi,...
             alp,cux,cuy,cuz,rg,...
             uxx,uxy,uxz,uyy,uyz,uzz,...
             gxx,gxy,gxz,gyy,gyz,gzz,...
             qxx,qxy,qxz,qyy,qyz,qzz,...
             t00,txx,txy,txz,tyy,tyz,tzz,...
             dxuxx,dxuxy,dxuxz,dxuyy,dxuyz,dxuzz,...
             dyuxx,dyuxy,dyuxz,dyuyy,dyuyz,dyuzz,...
             dzuxx,dzuxy,dzuxz,dzuyy,dzuyz,dzuzz...
             )
// Solve Einstein equation for gravitationaly moving objects
//function [alp,cux,cuy,cuz,uxx,uxy,uxz,uyy,uyz,uzz,qxx,qxy,qxz,qyy,qyz,qzz,dxuxx,dxuxy,dxuxz,dxuyy,dxuyz,dxuzz,...
//             dyuxx,dyuxy,dyuxz,dyuyy,dyuyz,dyuzz,...
//             dzuxx,dzuxy,dzuxz,dzuyy,dzuyz,dzuzz]=method_grobj(...
//             nx,ny,nz,...
//             dt,dx,dy,dz,...
//             x,y,z,r,psi,...
//             alp,cux,cuy,cuz,rg,...
//             uxx,uxy,uxz,uyy,uyz,uzz,...
//             gxx,gxy,gxz,gyy,gyz,gzz,...
//             qxx,qxy,qxz,qyy,qyz,qzz,...
//             t00,txx,txy,txz,tyy,tyz,tzz,...
//             dxuxx,dxuxy,dxuxz,dxuyy,dxuyz,dxuzz,...
//             dyuxx,dyuxy,dyuxz,dyuyy,dyuyz,dyuzz,...
//             dzuxx,dzuxy,dzuxz,dzuyy,dzuyz,dzuzz...
//             )


endfunction

