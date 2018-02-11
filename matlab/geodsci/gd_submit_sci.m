function [jobhandle]=gd_submit_sci(jobname, node, infiles)
% 
%   This script uses geodise toolbox to run simple wave model
%   on iceberg and submit the job to sun grid engine
disp ('  Run wave model using geodise toolkit.')
numfiles=size(infiles)


DIRNAME = [jobname,'/'];
[GLOBUSSERVER, JOBMANAGER, SCIHOME]=nodeinfo(node);


%SCRIPTDIR='/home/cs1mkg/proj/math/scilab/wave_intro/wav_grid'
SCRIPTDIR=[pwd(),'/'];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Put the remote files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(['>> gd_makedir(''',GLOBUSSERVER,''' ,''', DIRNAME, ''')']);
gd_makedir(GLOBUSSERVER, DIRNAME);
for i=1:numfiles(2)
    i
    from=[SCRIPTDIR,'in/',char(infiles(1,i))]
    to=[DIRNAME,char(infiles(1,i))]
    gd_putfile(GLOBUSSERVER,from,to)
end


disp ('  Files Transferred');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Run the demonstration script
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% The RSL string describes the GRAM job to be submitted to GLOBUSSERVER, the
% stdout and stderr are redirected to file. Note that GRAM will append
% existing files of the same name with output
RSLstring = ['&(executable=',SCIHOME,'/bin/scilab)(environment=(SCI "',SCIHOME,'"))(arguments = -nb -nw -f ',DIRNAME,jobname,'.sce)(stdout=',DIRNAME,'stdout.out)(stderr=',DIRNAME,'stdout.err)'];
% Submit the job to the GRAM gatekeeper on GLOBUSSERVER
disp ('  Submitting job');
jobhandle = gd_jobsubmit(RSLstring,JOBMANAGER);

