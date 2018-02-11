///withoutPrompt 
function [t,u,y]=syslinsim(Sys,tf,dt,ui,T,U)
 // Define symbolic parameters
  %scicos_context.num=Sys.num
  %scicos_context.den=Sys.den
  %scicos_context.dt=dt
  // Add initial input and a fake end point
  UT=[[0,T,tf+1];[ui,U,0]];
  mopen("foo","wb")
  mput(UT,"d")
  mclose()
  load("bg.cos")
  scs_m.props.tf=tf
  // run simulation in batch mode
  scicos_simulate(scs_m,list(),%scicos_context)
  // read back result in Scilab
  mopen("goo","rb")
  YT=mget(3*tf/dt+1000,"d")
  mclose()
  t=YT(3:3:$);u=YT(1:3:$);y=YT(2:3:$)
endfunction ///\withPrompt{}


