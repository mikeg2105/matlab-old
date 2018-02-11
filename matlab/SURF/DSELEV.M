% elevation  control for interactive surface plotting.

 disp 'changing elevation angle'
 newelev = get(dsh3,'value');
 figure(h0);
 [oldaz oldelev] = view;
 view(oldaz,newelev);
 return
 
