function [txx, txy, txz, tyy, tyz, tzz]=enmomt_parts(nx,ny,nz,dx,dy,dz,nparts, x, y, z,ppx, ppy, ppz, vx, vy, vz, m)

txx=zeros(nx,ny,nz);
txy=zeros(nx,ny,nz);
txz=zeros(nx,ny,nz);
tyy=zeros(nx,ny,nz);
tyz=zeros(nx,ny,nz);
tzz=zeros(nx,ny,nz);

tpxx=m*vx*vx;
tpxy=m*vx*vy;
tpxz=m*vx*vz;
tpyy=m*vy*vy;
tpyz=m*vy*vz;
tpzz=m*vz*vz;

ipx=int8(1+ppx+(nx/2));
ipy=int8(1+ppy+(ny/2));
ipz=int8(ppz);

if ipx > nx
    ipx=ipx-nx;
end
if ipx < 1
    ipx=ipx+nx;    
end

if ipy > ny
    ipy=ipy-ny;
end
if ipy < 1
    ipy=ipy+ny;    
end

if ipz > nz
    ipz=ipz-nz;
end
if ipz < 1
    ipz=ipz+nz;    
end

txx(ipx,ipy,ipz)=tpxx;
txy(ipx,ipy,ipz)=tpxy;
txz(ipx,ipy,ipz)=tpxz;
tyy(ipx,ipy,ipz)=tpyy;
tyz(ipx,ipy,ipz)=tpyz;
tzz(ipx,ipy,ipz)=tpzz;

endfunction



