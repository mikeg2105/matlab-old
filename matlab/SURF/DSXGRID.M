% colour map  control for interactive surface plotting.

 dstmp = get(dsh68,'value');
 figure(h0);
 if dstmp == 1
   set(hax,'xgrid','on');
 else 
   set(hax,'xgrid','off');
 end;
 return;

