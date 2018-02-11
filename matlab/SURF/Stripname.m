function name = stripname( pathn )
% given a filename with extention(s) this function
% will strip all the extensions out as it would
% have been done by matlab during a 'load filename' command.
% for example aaa.bbb should return just aaa.
%             aaa.bbb.ccc should return just aaa again.

[mm,nn] = size( pathn );


ifirst=1;
ilast = nn;
for i = 1:nn
  if strcmp(pathn(1,i),'.')
     ilast =  i-1;
     name= pathn(1,1:ilast);
     return
  end
end
name = pathn;
return  
