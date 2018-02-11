% azimuth control for interactive surface plotting.

 disp 'changing azimuth angle'
 newazim = get(dsh2,'value');
 figure(h0);
 [oldaz oldelev] = view;
 view(newazim,oldelev);
 return

