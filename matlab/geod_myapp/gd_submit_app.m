function [jobhandle]=gd_submit_app(appscript, jobname, node, infiles)
%   The application has in $MYHOME/easa/bin
%   The script wil setup the environment for the app
%   create a results directory
%   extracts job resources into results area
%   run app from results directory
%   creates a compressed archive of results
%   
%   on iceberg and submit the job to sun grid engine
disp ('  Run wave model using geodise toolkit.')
numfiles=size(infiles)



[GLOBUSSERVER, JOBMANAGER, MYHOME]=nodeinfo_app(node);
DIRNAME = [MYHOME,'/easa/',jobname,'/'];

%SCRIPTDIR='/home/cs1mkg/proj/math/scilab/wave_intro/wav_grid'
SCRIPTDIR=[pwd(),'/'];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Put the remote files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(['>> gd_makedir(''',GLOBUSSERVER,''' ,''', DIRNAME, ''')']);
gd_makedir(GLOBUSSERVER, DIRNAME);
mkdir 'in'

if numfiles(2)>1
    % take all of the files put in a file called
    % resources.tar.gz
    for i=2:numfiles(2)
        i
        from=[SCRIPTDIR,char(infiles(1,i))]
        to=[SCRIPTDIR,'in/',char(infiles(1,i))]
        cpcom=['cp ', from, ' ', to];
        unix(cpcom);
        
    end
    
    %tar and zip the files
    cpcom=['tar -zcvf resources.tar.gz in'];
    unix(cpcom);
    
end

%the header file is the actual script file
from=[SCRIPTDIR,char(infiles(1,1))]
to=[DIRNAME,char(infiles(1,1))]
gd_putfile(GLOBUSSERVER,from,to);

%transfer resources
if numfiles(2)>1
    from=[SCRIPTDIR,'resource.tar.gz']
    to=[DIRNAME,'resources.tar.gz']
    gd_putfile(GLOBUSSERVER,from,to);    
end


disp ('  Files Transferred');


% The RSL string describes the GRAM job to be submitted to GLOBUSSERVER, the
% stdout and stderr are redirected to file. Note that GRAM will append
% existing files of the same name with output
jobscriptfile=[DIRNAME,char(infiles(1,1))];
RSLstring = ['&(executable=',MYHOME,'/easa/bin/',appscript,')(arguments =',jobscriptfile,' resources.tar.gz)(directory=',DIRNAME,')(stdout=',DIRNAME,'stdout.out)(stderr=',DIRNAME,'stdout.err)'];
% Submit the job to the GRAM gatekeeper on GLOBUSSERVER
disp ('  Submitting job');
jobhandle = gd_jobsubmit(RSLstring,JOBMANAGER);

