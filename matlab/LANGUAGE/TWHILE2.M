% example while statement and example prompt for input via disp command.
% 
try1 = 1;
prompt2 = 'Try Again ! ';
while try1
  n = input( ' Enter a number: ' ) ;
  if  n < 0.5
     disp 'Too small !';
     disp ( prompt2);
  elseif n > 100
     disp ' Too big !'
     disp ( prompt2);
  else
     disp ' It will do.'
     break
  end
end
