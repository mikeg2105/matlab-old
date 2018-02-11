%beats script

%id=getenv('SGE_TASK_ID');  %id is a string variable

outfile=sprintf('beat.mat');
iid=0;
%iid=sscanf(id,'%d'); %read scaling parameter from job id
wav1=zeros(20,100);
t=1:1:100;
for shift=1:1:20; wav1( shift ,:)=beat_wave(t,1,1,0.05,shift*iid/100,0); end;
save(outfile, 'wav1');

%To review the results load the matlab file

%res=cell(1,4);
%for ic=1:4
%    infile=sprintf('beat%d.mat',ic);
%    load(infile);
%    res{ic}=wav1;
%    subplot(2,2,ic);
%    surf(res{ic}, 'LineStyle', 'none');
%    xlabel('shift');
%    ylabel('tscale');
%end

%exit is optional
exit;
