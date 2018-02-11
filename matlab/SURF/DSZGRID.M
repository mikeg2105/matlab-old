% colour map  control for interactive surface plotting.

 dstmp = get(dsh70,'value');
 figure(h0);
 if dstmp == 1
   set(hax,'zgrid','on');
 else 
   set(hax,'zgrid','off');
 end;
 return;

