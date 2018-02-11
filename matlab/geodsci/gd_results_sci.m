function [jobstatus]=gd_results_sci(jobhandle, jobname, node, infiles, outfiles)
% 
%   This script uses geodise toolbox to retrieve results
%   
disp ('  Get scilab results.')
numinfiles=size(infiles)
numoutfiles=size(outfiles)

DIRNAME = [jobname,'/'];
[GLOBUSSERVER, JOBMANAGER, SCIHOME]=nodeinfo(node);

%SCRIPTDIR='/home/cs1mkg/proj/math/scilab/wave_intro/wav_grid'
SCRIPTDIR=[pwd(),'/'];

% Retrieve the output files
disp('Getting output files.');
for i=1:numoutfiles(2)
    i
    from=[DIRNAME,char(outfiles(1,i))]
    to=[SCRIPTDIR,'out/',char(outfiles(1,i))]
    gd_getfile(GLOBUSSERVER,from,to);
end


% Delete remote in files
for i=1:numinfiles(2)
    gd_rmfile(GLOBUSSERVER,[DIRNAME,char(infiles(1,i))]);
end

% Delete remote out files
disp('Deleting remote in files.');
for i=1:numoutfiles(2)
    gd_rmfile(GLOBUSSERVER,[DIRNAME,char(outfiles(1,i))]);
end

gd_rmfile(GLOBUSSERVER,[DIRNAME,'stdout.out']);
gd_rmfile(GLOBUSSERVER,[DIRNAME,'stdout.err']);
% Delete remote directory
gd_rmdir(GLOBUSSERVER, DIRNAME);







