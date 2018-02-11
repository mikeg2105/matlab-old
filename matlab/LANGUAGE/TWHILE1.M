% example while loop with a break
% 
try1 = 1;
while try1
  n = input( ' Enter a number: ' ) ;
  if  n < 0.5
    disp 'Too small !'
  elseif n > 100
    disp ' Too big !'
  else
     disp ' It will do.'
%    break
% the below line will also work for terminating the loop
     try1 = 0;
  end
end

