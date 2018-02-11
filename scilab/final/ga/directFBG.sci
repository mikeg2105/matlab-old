//
//  direct problem: computation of the reflectitivity spectrum of a FBG and of the errror function
//

function rhodot=f(z,rho,delta,lamb,zf,dn)                   // right hand side of the ODE
d=splin(zf,dn);                                             // spline interpolation of the apodisation function
dnz=interp(z,zf,dn,d);
rhodot(1)=-2*delta*rho(2)-%pi*dnz*2*rho(1)*rho(2)/(lamb);
rhodot(2)=2*delta*rho(1)+%pi*dnz*(rho(1)^2-rho(2)^2)/(lamb)+%pi/lamb*dnz;
endfunction
//
//
disp('reflectitivity spectrum of a FBG and corresponding errror function:');
//
Nc=evstr(x_dialog('number of interpolation points of the apodisation function','3'));
Np=evstr(x_dialog('number of computed points of the spectrum','80'));
dnmax=evstr(x_dialog('maximal value of the apodisation function','2E-4'));
//
n0=1.45;
L=0.01;
lambda0=1.55E-6;
lambdamin=1.5497E-6;
lambdamax=1.5503E-6;
//
z0=L;rho0=[0;0];
z=L:(-L/(Nc-1)):0;
zf=0:(L/(Nc-1)):L;
dn=dnmax*(ones(1,Nc)-2*rand(1,Nc));                         // random choice of the apodisation function
lambda=lambdamin:(lambdamax-lambdamin)/(Np-1):lambdamax;
rtarget=zeros(1,Np);
ref=[];
timer();
for i=1:Np
  delta0=2*n0*%pi*(1/(lambda(i))-1/lambda0);
  if abs(lambda(i)-lambda0)<0.1E-9 then rtarget(i)=1;end
  rho=ode(rho0,z0,z,list(f,delta0,lambda0,zf,dn));
  R=rho(1,$)^2+rho(2,$)^2;
  ref=[ref,R];
end
disp('computational time:');disp(timer());
xset('window',0);
xbasc();
d=splin(zf,dn);
dnz=interp(0:L/100:L,zf,dn,d);
plot2d(0:L/100:L,dnz)
plot2d(zf,dn,-1);
xtitle('apodisation function','z','dn(z)')
//
xset('window',1);
xbasc();
plot2d(lambda,ref)
plot2d(lambda,rtarget,2)
xtitle('reflectivity spectrum (black) and ideal spectrum (blue)','lambda','R(lambda)')
error=(sum((abs(ref-rtarget)).^0.75))^(1/0.75);
disp('error:');disp(error)


