jobname='gr_harm_mat1_15';
niters=8;
%resarray=cell(1,niters);
nx=40;
ny=40;
nz=40;

z=resarray{1};
h=surf(reshape(z(:,20,:),nx,nz), 'LineStyle', 'none');

for i=1:niters
    z=resarray{i};

    %update surface plot
    set(h,'ZData',reshape(z(:,20,:),nx,nz));
    shading interp;
    pause;

end %end of cycling over steps
%fclose(fd);
%exit;

