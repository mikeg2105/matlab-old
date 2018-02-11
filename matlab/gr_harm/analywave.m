function [gxx,gxy,gxz,gyy,gyz,gzz]=analywave(nx,ny,nz,time,par1,par2,x,y,z,r)
%     Covariant metric $g_{ij}$ is computed analytically and depends
%     on the parameters par1 and par2

%  [AUTHOR] Joan Masso, NCSA & UIB
%           Based on an original routine by Malcolm Tobias, WashU.
% 
%  [PURPOSE] Initialize the metric tensor $g_{ij}$ with a linearized
%     Eppley style packet of incoming/outgoing waves. The metric
%     is computed in spherical coordinates and then transformed to
%     cartesian. 
%
%  [ARGUMENTS] 
%     [INPUT]
%        nx,ny,nz  : grid sizes of the 3d cube.
%        time, x,y,z,r  : time scalar and grid vectors
%        par1,par2 : Parameters controlling the amplitude and shape
%                    of the blob of waves.
%     [OUTPUT]
%        gxx,gxy,...,gzz: covariant metric $g_{ij}$
% 
%  [VARIABLES] A LOT of 3d local arrays is declared to make the
%     computation of the metric easier... due to historical reasons
%     it is not worth cleaning up... Anyway, this routine is only
%     called once so efficiency is not a crucial issue.
%
%  [CALLED BY]  initial.m
%  [CALLS  TO]  spheretocart.m

%real x(nx,ny,nz),y(nx,ny,nz),z(nx,ny,nz),r(nx,ny,nz)
%      real gxx(nx,ny,nz),gxy(nx,ny,nz),gxz(nx,ny,nz),
%     &     gyy(nx,ny,nz),gyz(nx,ny,nz),gzz(nx,ny,nz)

%     Local Vars.

%     Metric in spherical coordinates
%     $g_{rr},g_{r\theta},g_{r\phi},g_{\theta\theta}...$ etc.
%      real grr(nx,ny,nz),grt(nx,ny,nz),grp(nx,ny,nz),
%     &     gtt(nx,ny,nz),gtp(nx,ny,nz),gpp(nx,ny,nz)

%     Auxiliar coefficients
%      real fp(nx,ny,nz),fn(nx,ny,nz) 	
%      real fpa(nx,ny,nz),fna(nx,ny,nz)
%      real fpb(nx,ny,nz),fnb(nx,ny,nz)
%      real fpc(nx,ny,nz),fnc(nx,ny,nz)
%      real fpd(nx,ny,nz),fnd(nx,ny,nz)
%      real tp(nx,ny,nz),tn(nx,ny,nz)
%      real ca(nx,ny,nz),cb(nx,ny,nz),cc(nx,ny,nz)
%      real ck(nx,ny,nz),cl(nx,ny,nz)
      
%      real frr(nx,ny,nz),frt(nx,ny,nz),frp(nx,ny,nz),
%     &     ftt1(nx,ny,nz),ftt2(nx,ny,nz),ftp1(nx,ny,nz),
%     2     fpp1(nx,ny,nz),fpp2(nx,ny,nz)
      
%      real drt(nx,ny,nz),drp(nx,ny,nz),dtt(nx,ny,nz),
%     &     dtp(nx,ny,nz),dpp(nx,ny,nz)
      
%      real sint(nx,ny,nz),cost(nx,ny,nz),sinp(nx,ny,nz),cosp(nx,ny,nz)
      
%      real amp,m,ra
%      integer iparity

%     Wave characteristics: amplitude and m value (shape)
      amp = par1;
%     integer m is gonna be the integer part of par2
      m = par2;

%     Some hardwired values for H3expresso
%     centering of the wave     
      ra = 0;
%     parity of the wave (1 = odd, 2 = even)
      iparity = 2;

%     advanced/retarded times.
      tp = (time+r-ra);
      tn = (time-r+ra);
      
%     Eppley style packet
      fp = amp .* tp.*exp(-tp.^2);
      fpa = amp .* (1 - 2.*tp.^2).*exp(-tp.^2);
      fpb = amp .* (-6.*tp + 4.*tp.^3).*exp(-tp.^2);
      fpc = amp .* (-6 + 24.*tp.^2 - 8.*tp.^4).*exp(-tp.^2);
      fpd = amp .* (60.*tp - 80.*tp.^3 + 16.*tp.^5).*exp(-tp.^2);
      
      fn = amp .* tn.*exp(-tn.^2);
      fna = amp .* (1 - 2.*tn.^2).*exp(-tn.^2);
      fnb = amp .* (-6.*tn + 4.*tn.^3).*exp(-tn.^2);
      fnc = amp .* (-6 +24.*tn.^2 - 8.*tn.^4).*exp(-tn.^2);
      fnd = amp .* (60.*tn - 80.*tn.^3 + 16.*tn.^5).*exp(-tn.^2);
      
%     coefficients
      ca = 3.*( (fpb-fnb)./r.^3 -3.*(fna+fpa)./r.^4 +3.*(fp-fn)./r.^5 );
      cb = -( -(fnc+fpc)./r.^2 +3.*(fpb-fnb)./r.^3 -6.*(fna+fpa)./r.^4+6.*(fp-fn)./r.^5 ); 
      cc = ( (fpd-fnd)./r -2.*(fnc+fpc)./r.^2 +9.*(fpb-fnb)./r.^3-21.*(fna+fpa)./r.^4 +21.*(fp-fn)./r.^5 )./4;
      ck = (fpb-fnb)./r.^2-3.*(fpa+fna)./r.^3+3.*(fp-fn)./r.^4;
      cl = -(fpc+fnc)./r+2.*(fpb-fnb)./r.^2-3.*(fpa+fna)./r.^3+3.*(fp-fn)./r.^4;
      
      
      sint = (x.^2+y.^2).^0.5./r;
      cost = z./r;
      sinp = y./(x.^2+y.^2).^0.5;
      cosp = x./(x.^2+y.^2).^0.5;

%     Choose coeffs. depending on m value.
      if m==0
         frr = 2-3.*sint.^2;
         frt = -3.*sint.*cost;
         frp = 0.;
         ftt1 = 3.*sint.^2;
         ftt2 = -1.;
         ftp1 = 0.;
         fpp1 = -ftt1;
         fpp2 = 3.*sint.^2-1;
         drt = 0.;
         drp = -4.*cost.*sint;
         dtt = 0.;
         dtp = -sint.^2;
         dpp = 0.;
      end
      
      if m==-1
         frr = 2.*sint.*cost.*sinp;
         frt = (cost.^2-sint.^2).*sinp; 
         frp = cost.*cosp; 
         ftt1 = -frr;
         ftt2 = 0.;
         ftp1 = sint.*cosp; 
         fpp1 = -ftt1;
         fpp2 = ftt1;
         drt = -2.*cost.*sinp;
         drp = -2.*(cost.^2-sint.^2).*cosp;
         dtt = -sint.*sinp;
         dtp = -cost.*sint.*cosp;
         dpp = sint.*sinp;
      end
      
      if m==-2
         frr = sint.^2.*2.*sinp.*cosp;
         frt = sint.*cost.*2.*sinp.*cosp;
         frp = sint.*(1-2.*sinp.^2);
         ftt1 = (1+cost.^2).*2.*sinp.*cosp;
         ftp1 = -cost.*2.*sinp.*cosp;
         ftt2 = -2.*sinp.*cosp;
         fpp1 = -ftt1;
         fpp2 = cost.^2.*2.*sinp.*cosp;
         drt = 8.*sint.*sinp.*cosp;
         drp = 4.*sint.*cost.*(1-2.*sinp.^2);
         dtt = -4.*cost.*sinp.*cosp;
         dtp = (2-sint.^2).*(2.*sinp.^2-1);
         dpp = 2.*cost.*2.*sinp.*cosp;
      end
      
      if m==1
         frr = 2.*sint.*cost.*cosp;
         frt = (cost.^2-sint.^2).*cosp;
         frp = -cost.*sinp;
         ftt1 = -2.*sint.*cost.*cosp;
         ftt2 = 0.;
         ftp1 = -sint.*sinp;
         fpp1 = -ftt1;
         fpp2 = ftt1;
         drt = -2.*cost.*cosp;
         drp = 2.*(cost.^2-sint.^2).*sinp;
         dtt = -sint.*cosp;
         dtp = cost.*sint.*sinp;
         dpp = sint.*cosp;
      end
      
      if m==2
         frr = sint.^2.*(1-2.*sinp.^2);
         frt = sint.*cost.*(1-2.*sinp.^2);
         frp = -sint.*2.*sinp.*cosp;
         ftt1 = (1+cost.^2).*(1-2.*sinp.^2);
         ftt2 = (2.*sinp.^2-1);
         ftp1 = cost.*2.*sinp.*cosp;
         fpp1 = -ftt1;
         fpp2 = cost.^2.*(1-2.*sinp.^2);
         drt = 4.*sint.*(1-2.*sinp.^2);
         drp = -4.*sint.*cost.*2.*sinp.*cosp;
         dtt = -2.*cost.*(1-2.*sinp.^2);
         dtp = (2-sint.^2).*2.*sinp.*cosp;
         dpp = 2.*cost.*(1-2.*sinp.^2);
      end

%     Set the metric in spherical coordinates
      if iparity==2	
         grr = 1 + ca.*frr;
         grt = cb.*frt.*r;
         grp = cb.*frp.*(x.^2+y.^2).^0.5;
         gtt = r.^2.*(1 + cc.*ftt1 + ca.*ftt2);
         gtp = (ca - 2.*cc).*ftp1.*r.*(x.^2+y.^2).^0.5;
         gpp = (x.^2+y.^2).*(1 + cc.*fpp1 + ca.*fpp2);
      end
      
      if iparity==1
         grr = 1.;
         grt = ck.*drt.*r;
         grp = ck.*drp.*r.*sint;
         gtt = (1+cl.*dtt).*r.^2;
         gtp = cl.*dtp.*r.^2.*sint;
         gpp = (1+cl.*dpp).*r.^2.*sint.^2;
      end

%     Transform the spherical coordinates to cartesian
      [gxx,gxy,gxz,gyy,gyz,gzz]=spheretocart(nx,ny,nz,x,y,z,r,grr,grt,grp,gtt,gtp,gpp);
      
%endfunction