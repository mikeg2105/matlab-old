% colour map  control for interactive surface plotting.

 dstmp = get(dsh51,'value');
 figure(h0);
 if dstmp == 1
   set(hax,'box','on');
 else 
   set(hax,'box','off');
 end;
 return;

