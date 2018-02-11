% colour map  control for interactive surface plotting.

 dstmp = get(dsh52,'value');
 figure(h0);
 if dstmp == 1
   set(hax,'tickdir','in');
 else 
   set(hax,'tickdir','out');
 end;
 return;

