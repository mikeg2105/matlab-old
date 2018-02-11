% colour map  control for interactive surface plotting.

 dstmp = get(dsh66,'value');
 figure(h0);
 if dstmp == 1
   set(hax,'yscale','log');
 else 
   set(hax,'yscale','linear');
 end;
 return;

