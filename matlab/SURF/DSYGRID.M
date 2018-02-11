% colour map  control for interactive surface plotting.

 dstmp = get(dsh69,'value');
 figure(h0);
 if dstmp == 1
   set(hax,'ygrid','on');
 else 
   set(hax,'ygrid','off');
 end;
 return;

