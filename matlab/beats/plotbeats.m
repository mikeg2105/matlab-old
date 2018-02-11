res=cell(1,4);
for ic=1:4
    infile=sprintf('beat%d.mat',ic);
    load(infile);
    res{ic}=wav1;
    subplot(2,2,ic);
    surf(res{ic}, 'LineStyle', 'none');
    xlabel('tscale');
    ylabel('shift');
end