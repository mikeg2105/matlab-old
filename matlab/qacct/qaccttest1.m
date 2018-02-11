%script to generate qacct info
clear all;
qacctfile='/home1/cs/cs1mkg/temp/qacctall0507.dat';

qacctimportfile(qacctfile);

%get user info names and user groups
userdetails=userdetails(textdata);
[nusers,ncols]=size(userdetails);
usergroups=usergrouplist(userdetails);
[groupdata,userdata]=groupdata(data,userdetails,usergroups);

sortgroupdata=sortrows(groupdata, -1);
sortuserdata=sortrows(userdata,-1);
sortgroupmem=sortrows(groupdata,-10);