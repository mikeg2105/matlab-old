exec('..\xmlutils\writexml.m');
exec('..\xmlutils\writex3d.m');
exec('diffuse_utils.m');
exec('diffuse_x3d.m');
exec('diffuse.m');
exec('diffuse_drv.m');
exec('diffuse_analysis.m');
chdir('results');

sirout=diffuse_analysis('diffuse_datlist.lis',10);

