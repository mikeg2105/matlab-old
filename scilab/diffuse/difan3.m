exec('..\xmlutils\writexml.m');
exec('..\xmlutils\writex3d.m');
exec('diffuse_utils.m');
exec('diffuse_x3d.m');
exec('diffuse.m');
exec('diffuse_drv.m');
exec('diffuse_analysis.m');
chdir('results');


diffuse_analy_faceset('diffuse_datlist_1.lis', 'facesett1',66, 25, 25, 1, 1, 2, 3, 1);
diffuse_analy_faceset('diffuse_datlist_2.lis', 'facesett2',66, 25, 25, 1, 1, 2, 3, 1);

exit();
