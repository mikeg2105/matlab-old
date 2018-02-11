function [gxx,gxy,gxz,gyy,gyz,gzz]=analywave_bhcol(nx,ny,nz,time,par1,par2,x,y,z,r)
//     Covariant metric $g_{ij}$ is computed analytically and depends
//     on the parameters par1 and par2

//  [AUTHOR] Joan Masso, NCSA & UIB
//           Based on an original routine by Malcolm Tobias, WashU.
// 
//  [PURPOSE] Initialize the metric tensor $g_{ij}$ with a linearized
//     Eppley style packet of incoming/outgoing waves. The metric
//     is computed in spherical coordinates and then transformed to
//     cartesian. 
//
//  [ARGUMENTS] 
//     [INPUT]
//        nx,ny,nz  : grid sizes of the 3d cube.
//        time, x,y,z,r  : time scalar and grid vectors
//        par1,par2 : Parameters controlling the amplitude and shape
//                    of the blob of waves.
//     [OUTPUT]
//        gxx,gxy,...,gzz: covariant metric $g_{ij}$
// 
//  [VARIABLES] A LOT of 3d local arrays is declared to make the
//     computation of the metric easier... due to historical reasons
//     it is not worth cleaning up... Anyway, this routine is only
//     called once so efficiency is not a crucial issue.
//
//  [CALLED BY]  initial.m
//  [CALLS  TO]  spheretocart.m

//real x(nx,ny,nz),y(nx,ny,nz),z(nx,ny,nz),r(nx,ny,nz)
//      real gxx(nx,ny,nz),gxy(nx,ny,nz),gxz(nx,ny,nz),
//     &     gyy(nx,ny,nz),gyz(nx,ny,nz),gzz(nx,ny,nz)

//     Local Vars.

//     Metric in spherical coordinates
//     $g_{rr},g_{r\theta},g_{r\phi},g_{\theta\theta}...$ etc.
//      real grr(nx,ny,nz),grt(nx,ny,nz),grp(nx,ny,nz),
//     &     gtt(nx,ny,nz),gtp(nx,ny,nz),gpp(nx,ny,nz)

//     Auxiliar coefficients
//      real fp(nx,ny,nz),fn(nx,ny,nz) 	
//      real fpa(nx,ny,nz),fna(nx,ny,nz)
//      real fpb(nx,ny,nz),fnb(nx,ny,nz)
//      real fpc(nx,ny,nz),fnc(nx,ny,nz)
//      real fpd(nx,ny,nz),fnd(nx,ny,nz)
//      real tp(nx,ny,nz),tn(nx,ny,nz)
//      real ca(nx,ny,nz),cb(nx,ny,nz),cc(nx,ny,nz)
//      real ck(nx,ny,nz),cl(nx,ny,nz)
      
//      real frr(nx,ny,nz),frt(nx,ny,nz),frp(nx,ny,nz),
//     &     ftt1(nx,ny,nz),ftt2(nx,ny,nz),ftp(nx,ny,nz),
//     2     fpp1(nx,ny,nz),fpp2(nx,ny,nz)
      
//      real drt(nx,ny,nz),drp(nx,ny,nz),dtt(nx,ny,nz),
//     &     dtp(nx,ny,nz),dpp(nx,ny,nz)
      
//      real sint(nx,ny,nz),cost(nx,ny,nz),sinp(nx,ny,nz),cosp(nx,ny,nz)
      
//      real amp,m,ra
//      integer iparity
//    http://arxiv.org/PS_cache/gr-qc/pdf/9408/9408042v1.pdf
//  blackhole collosion two spherically symmetric same mass black holes

//     Wave characteristics: amplitude and m value (shape)
      amp = par1;
//     integer m is gonna be the integer part of par2
      m = par2;

//     Some hardwired values for H3expresso
//     centering of the wave     
      ra = 0;
//     parity of the wave (1 = odd, 2 = even)
      iparity = 2;

//     advanced/retarded times.
      tp = (time+r-ra);
      tn = (time-r+ra);
      



       //Misner metric
       //increase mu increases separation and reduces system mass
       n=par1;
       mu=par2;
       
       //conformal factor
       cfactor=0;
       for i=1:5
        term=cothm(i.*mu);
        rnplus=sqrt((r.*r)+(z+term).*(z+term)));
        rnminus=sqrt((r.*r)+(z-term).*(z-term)));
        cfactor=cactor+(1./(sinhm(i.*mu))).*((1./rnplus)+(1./rnminus));       
       end

       grr=1;
       grt=0;
       grz=0;
       gtr=0;
       gtt=r.*r;
       gtz=0;
       gzr=0;
       gzt=0;
       gzz=1;

//     Transform the spherical coordinates to cartesian
      [gxx,gxy,gxz,gyy,gyz,gzz]=spheretocart(nx,ny,nz,x,y,z,r,grr,grt,grp,gtt,gtp,gpp);
      
endfunction
