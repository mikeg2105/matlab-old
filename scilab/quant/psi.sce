
//simple wave function

function  [psi]=psi(r,  theta,  phi, m,l,n)

//Y(theta, phi)
//radial

psi=y(theta,phi,m,l)*rad(r,n,l);


endfunction

function [factorial]=factorial(n)
 result=1;
 for i=1:n
   result=result*i;
 end
 factorial=result;
endfunction


function [y]=y(theta,phi,l,m)
   leg=1;
   leg=legendre(l, m, theta/(2*%pi), "norm")*(1/exp(%i * m* phi ));
   y=leg;
endfunction

function [rad]=rad(r,n,l)

   result=leg;
   sqrt(1/(factorial(n)))*exp(-r/n)
	 rad=result;
endfunction

function [ypol]=ypol(npoints, theta, phi,l,m)
  ypol=zeros(npoints,npoints);
  for i=1:npoints
    for j=1:npoints
      ypol(i,j)=y(theta(i),phi(j),l,m)
    end
  end

endfunction

function [xmat]=xmat(npoints, theta, phi)
 x=zeros(npoints);
 for i=1:npoints
    x(i)=cos(theta(i))*sin(phi(i));
 end
 xmat=x;
endfunction

function [ymat]=ymat(npoints, theta, phi)
 y=zeros(npoints);
 for i=1:npoints
    y(i)=sin(theta(i))*sin(phi(i));
 end
 ymat=y;
endfunction

function plotquant(npoints,theta,phi,l,m)

 for i=1:npoints
   x(i)=cos(theta(i))*sin(phi(i));
   y(i)=sin(theta(i))*sin(phi(i));
 end
 yres=ypol(npoints,theta,phi,l,m);
 plot3d(x,y,yres);
endfunction
