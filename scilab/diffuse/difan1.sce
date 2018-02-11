
exec('diffuse_utils.m');

exec('diffuse.m');
exec('diffuse_drv.m');
exec('diffuse_analysis.m');
chdir('results');

sirout=diffuse_analysis('diffuse_datlist.lis',10);

