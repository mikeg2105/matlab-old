///withoutPrompt 
function [x,y,typ]=IdealOpAmp3Pin(job,arg1,arg2)
  x=[];y=[];typ=[]
  select job
   case 'plot' then
    standard_draw(arg1)
   case 'getinputs' then
    [x,y,typ]=standard_inputs(arg1)
   case 'getoutputs' then
    [x,y,typ]=standard_outputs(arg1)
   case 'getorigin' then
    [x,y]=standard_origin(arg1)
   case 'set' then
    x=arg1;
   case 'define' then
  model=scicos_model()
  model.in=[1;1];model.out=1;
  model.sim='IdealOpAmp3Pin'
  model.blocktype='c'
  model.dep_ut=[%t %f]
  mo=modelica()
  mo.model='IdealOpAmp3Pin'
  mo.inputs=['in_p';'in_n'];
  mo.outputs=['out']
  model.equations=mo
  exprs=[string([1])]
  gr_i=['txt=[''OpAmp''];';
        'xstringb(orig(1),orig(2),txt,sz(1),sz(2),''fill'')']
    
  x=standard_define([2 2],model,exprs,gr_i)
  x.graphics.in_implicit=['I';'I']
  x.graphics.out_implicit=['I']
  end
endfunction ///\withPrompt{}


