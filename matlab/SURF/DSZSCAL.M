% colour map  control for interactive surface plotting.

 dstmp = get(dsh67,'value');
 figure(h0);
 if dstmp == 1
   set(hax,'zscale','log');
 else 
   set(hax,'zscale','linear');
 end;
 return;

