exec('..\xmlutils\writexml.m');
exec('..\xmlutils\writex3d.m');
exec('diffuse_utils.m');
exec('diffuse_x3d.m');
exec('diffuse.m');
exec('diffuse_drv.m');
exec('diffuse_analysis.m');
chdir('results');


diffuse_analy_faceset('diffuse_datlist.LIS', 'facesett1',91, 50, 50, 1, 1, 2, 3, 1);


exit();
