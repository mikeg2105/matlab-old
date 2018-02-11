% Titles and axis on/off  control for interactive surface plotting.

 dstmp = get(dsh60,'Value');
 figure(h0);

 if dstmp == 1
   axis on
 else 
   axis off
 end;
 return;
 
