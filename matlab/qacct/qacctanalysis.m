%script to generate qacct info
clear all;
%qacctfile='/home1/cs/cs1mkg/temp/qacctall0507.dat';
qacctfile='qacctresults.dat';
mng=20;
mnu=10;


fid=fopen('inputdata.txt','r');
mng=fscanf(fid,'%f',1);
mnu=fscanf(fid,'%f',1);

startdate=fscanf(fid,'%s',1);
enddate=fscanf(fid,'%s',1);
mstartdate=startdate(1:6)
menddate=enddate(1:6)
fclose(fid);
qacctimportfile(qacctfile);



%get user info names and user groups
vuserdetails=userdetails(textdata);
[nusers,ncols]=size(vuserdetails);
if mnu>nusers
   mnu=nusers;
end
usergroups=usergrouplist(vuserdetails);

[vgroupdata,userdata]=groupdata(data,vuserdetails,usergroups);
[ngroups,ncols]=size(usergroups);
if mng>ngroups
    mng=ngroups;
end
sortgroupdata=sortrows(vgroupdata, -1);
sortuserdata=sortrows(userdata,-1);
sortgroupmem=sortrows(vgroupdata,-10);

groupusage=sortgroupdata(1:mng, 8:11);
groupmem=sortgroupmem(1:mng, 8:11);
userusage=sortuserdata(1:mnu,8:11);

users=vuserdetails(userusage(:,4),1);
maxuserusage=max(userusage(:,1));
meanuserusage=mean(userdata(:,8));
totalwtime=sum(userdata(:,8));
totalcputime=sum(userdata(:,4))/3600;

groups=usergroups(groupusage(:,4),1);
maxgroupusage=max(groupusage(:,1));
meangroupusage=mean(vgroupdata(:,8));

memgroups=usergroups(groupmem(:,4),1);
maxgroupmem=max(vgroupdata(:,10));
meangroupmem=mean(vgroupdata(:,10));

%tempusers=userdetails(userusage(:,4),1);
%for i=1:nu


h=figure('Visible','off','IntegerHandle','Off');
hold on;
bar(userusage(:,1))
hold on
text(0.8*mnu,0.6*max(userusage(:,1)),users);
stitle=['Used Wallclocktime for Top Users \newline from ',mstartdate,' until ', menddate];
title(stitle); 
ylabel('Used wallclock time(hrs)');
xlabel('User');
print -djpeg 'qacctuserswtime.jpg'
hold off;

h=figure('Visible','off','IntegerHandle','Off');
hold on;
bar(userusage(:,2))
hold on
text(0.8*mnu,0.6*max(userusage(:,2)),users);
title(['Utilisation for Top Users. \newline from ',mstartdate,' until ', menddate]); 
ylabel('Utilisation (%)');
xlabel('User');
print -djpeg 'qacctuserutilisation.jpg'
hold off;

h=figure('Visible','off','IntegerHandle','Off');
hold on;
bar(groupusage(:,1))
hold on
text(0.8*mng,0.6*max(groupusage(:,1)),groups);
title(['Used Wallclocktime for Top User Groups.\newline from ',mstartdate,' until ', menddate]); 
ylabel('Used wallclock time(hrs)');
xlabel('Group');
print -djpeg 'qacctgroupswtime.jpg'
hold off;

h=figure('Visible','off','IntegerHandle','Off');
hold on;
bar(groupusage(:,2))
hold on
text(0.8*mng,0.6*max(groupusage(:,2)),groups);
title(['Utilisation for Top User Groups. \newline From ',mstartdate,' until ', menddate]); 
ylabel('Utilisation (%)');
xlabel('Group');
print -djpeg 'qacctgrouputilisation.jpg'
hold off;

h=figure('Visible','off','IntegerHandle','Off');
hold on;
bar(groupmem(:,3))
hold on
text(0.8*mng,0.6*max(groupmem(:,3)),memgroups);
stitle=['Memory Utilisation for Top User Groups.\newline From ',mstartdate,' until ', menddate]
title(stitle); 
ylabel('Memory Utilisation (GB/cpucycle)');
xlabel('Group');
print -djpeg 'qacctgroupmemutil.jpg'
hold off;


%prepare data for saving

%save the ouput asci files

%save('stats.txt','meanuserusage','maxuserusage','meangroupusage','maxgroupusage','meangroupmem','maxgroupmem','-ASCII')
fid=fopen('stats.txt','w');
fprintf(fid,'totalwtime totalcputime(hrs) meanuserusage maxuserusage meangroupusage maxgroupusage meangroupmem maxgroupem\n');
fprintf(fid,'%f %f %f %f %f %f %f %f\n',totalwtime, totalcputime, meanuserusage, maxuserusage, meangroupusage, maxgroupusage, meangroupmem, maxgroupmem);
fclose(fid);




fid=fopen('userdat.txt','w');
fprintf(fid, 'wallclock utime stime cpu memory io iow wallclock(hrs) utilisation memory(mem/cpu) uid\n');
for i=1:nusers
    tempstr=vuserdetails{i,1};
    fprintf(fid,'%s %f %f %f %f %f %f %f %f %f %f %f\n',tempstr, userdata(i,:));
end
fclose(fid);

fid=fopen('sorteduserdat.txt','w');
fprintf(fid, 'wallclock utime stime cpu memory io iow wallclock(hrs) utilisation memory(mem/cpu) uid\n');
for i=1:nusers
    tempstr=vuserdetails{sortuserdata(i,11),1};
    fprintf(fid,'%s %f %f %f %f %f %f %f %f %f %f %f\n',tempstr, sortuserdata(i,:));
end
fclose(fid);

fid=fopen('sortgroupdat.txt','w');
fprintf(fid, 'wallclock utime stime cpu memory io iow wallclock(hrs) utilisation memory(mem/cpu) gid\n');
for i=1:ngroups
    tempstr=usergroups{sortgroupdata(i,11),1};
    fprintf(fid,'%s %f %f %f %f %f %f %f %f %f %f %f\n',tempstr, sortgroupdata(i,:));
end
fclose(fid);

fid=fopen('groupdat.txt','w');
fprintf(fid, 'wallclock utime stime cpu memory io iow wallclock(hrs) utilisation memory(mem/cpu) gid\n');
for i=1:ngroups
    tempstr=usergroups{vgroupdata(i,11),1};
    fprintf(fid,'%s %f %f %f %f %f %f %f %f %f %f %f\n',tempstr, vgroupdata(i,:));
end
fclose(fid);

fid=fopen('sorgroupmemdat.txt','w');
fprintf(fid, 'wallclock utime stime cpu memory io iow wallclock(hrs) utilisation memory(mem/cpu) gid\n');
for i=1:ngroups
    tempstr=usergroups{sortgroupmem(i,11),1};
    fprintf(fid,'%s %f %f %f %f %f %f %f %f %f %f %f\n',tempstr, sortgroupmem(i,:));
end
fclose(fid);



