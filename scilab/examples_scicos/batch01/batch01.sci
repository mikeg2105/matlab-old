function e=eval_cost(p,z)
  global('Info','AA','ZZ','i')
  i=1;ZZ=z;AA=zeros(ZZ);
  %scicos_context.a=p(1)
  %scicos_context.b=p(2)
  Info=scicos_simulate(scs_m,Info,%scicos_context,'nw')
  e=norm(AA-ZZ) 
  //disp(e) 
endfunction

load Untitled0.cos
global('Info','AA','ZZ','i')

Z=sign(sin([1:1002]/100))'; // generate a square wave

p0=[0.;0.];  // intial values of a and b
Info=list();
%scicos_context.a=p0(1);
%scicos_context.b=p0(2);
ZZ=Z;
i=1;AA=zeros(Z);
scicos_simulate(scs_m,Info,%scicos_context);
// datafit is an optimization function that
// uses optim but does not require the gradient

  [p,err]=datafit(eval_cost,Z,p0,'ar',30); 

ZZ=Z;
i=1;AA=zeros(Z);
%scicos_context.a=p(1);
%scicos_context.b=p(2);
// final simulation to visualize the solution
scicos_simulate(scs_m,list(),%scicos_context);


