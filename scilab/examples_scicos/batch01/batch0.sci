function e=eval_cost(p,z)
  global('Info','AA','ZZ','i')
  i=1;ZZ=z;AA=zeros(ZZ);
  %scicos_context.a=p(1)
  %scicos_context.b=p(2)
  scicos_simulate(scs_m,Info,%scicos_context,'nw')
  e=norm(AA-ZZ)
  // disp(e)
endfunction

load Untitled0.cos

global('Info','AA','ZZ','i')
Z=[ones(1002,1),[1:1002]'/500];

p0=[0.;0.];
Info=list();
%scicos_context.a=p0(1);
%scicos_context.b=p0(2);
for ZZ=Z
  i=1;AA=zeros(ZZ);
  scicos_simulate(scs_m,Info,%scicos_context);
end

  [p,err]=datafit(eval_cost,Z,p0,'ar',30); 

Info=list();
for ZZ=Z
  i=1;AA=zeros(ZZ);
  %scicos_context.a=p(1);
  %scicos_context.b=p(2);
  scicos_simulate(scs_m,Info,%scicos_context);
end 

