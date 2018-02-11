% colour map  control for interactive surface plotting.

 dstmp = get(dsh65,'value');
 figure(h0);
 if dstmp == 1
   set(hax,'xscale','log');
 else 
   set(hax,'xscale','linear');
 end;
 return;

