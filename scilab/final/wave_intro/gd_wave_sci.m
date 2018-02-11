% 
%   This script uses geodise toolbox to run lorenz model
%   on iceberg and submit the job to sun grid engine



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Print the introduction 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc

disp ('  Run wave model using geodise toolkit.') 

%disp ('  Press any key to continue')

%pause
disp (' ')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set up the demo variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The Globus server upon which to run the shell script. Note that the
% certificate subject line (returned by gd_certinfo) must map to a user
% account on the Globus server.

%disp('  Enter the name of the Globus GT2 server that you wish to use?')
%disp('    Note that you must have authorisation to access the GRAM')
%disp('    and GridFTP services on this server.')
%servername = input('input>> ','s');
%if ~isempty(servername)
%    GLOBUSSERVER = servername
%else
%    GLOBUSSERVER
%end 

% The name of the directory on the Globus server
DIRNAME = 'geod_waveintro/';
%GLOBUSSERVER = 'iceberg.shef.ac.uk';
%SCIHOME = '/usr/local/packages/scilab-3.1.1';
%JOBMANAGER = [GLOBUSSERVER, '/jobmanager-sge']

GLOBUSSERVER = 'grid-compute.leeds.ac.uk';
SCIHOME = '/home/data01_a/ngs0244/tools/scilab/scilab-3.1.1';
JOBMANAGER = [GLOBUSSERVER, '/jobmanager-pbs']

%GLOBUSSERVER = 'grid-compute.oesc.ox.ac.uk';
%SCIHOME = '/home/ngs0176/tools/scilab/scilab-3.1.1';
%JOBMANAGER = [GLOBUSSERVER, '/jobmanager-pbs']

%GLOBUSSERVER = 'grid.lancs.ac.uk';
%SCIHOME = '/home/hpc/ngs/ngs0014/tools/scilab/scilab-3.1.1';
%JOBMANAGER = [GLOBUSSERVER, '/jobmanager-sge']

%GLOBUSSERVER = 'pascali.wrg.york.ac.uk';
%SCIHOME = '/home/grid/wrsmg1/tools/scilab_solaris/scilab-3.1.1';
%JOBMANAGER = [GLOBUSSERVER, '/jobmanager-sge'];

%GLOBUSSERVER = 'maxima.leeds.ac.uk';
%SCIHOME = '/home/ufaserv2_wrga/wrsmg/tools/scilab_solaris/scilab-3.1.1';
%JOBMANAGER = [GLOBUSSERVER, '/jobmanager-sge']

%GLOBUSSERVER = 'snowdon.leeds.ac.uk';
%SCIHOME = '/home/ufaserv2_wrga/wrsmg/tools/scilab/scilab-3.1.1';
%JOBMANAGER = [GLOBUSSERVER, '/jobmanager-sge']

% Locate the directory containing the shell script
%SCRIPTDIR = [fileparts(mfilename('fullpath')), filesep];
SCRIPTDIR='/home/cs1mkg/proj/math/scilab/wave_intro/'
%JOBMANAGER = 'titania.shef.ac.uk/jobmanager-sge'







%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Put the remote files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(['>> gd_makedir(''',GLOBUSSERVER,''' ,''', DIRNAME, ''')']);
gd_makedir(GLOBUSSERVER, DIRNAME);


% GridFTP the demo shell script from the local directory to the users home
% directory on GLOBUSSERVER 
disp(' ');
disp('  (2.3) Transfering files to Globus server using GridFTP');
gd_putfile(GLOBUSSERVER,[SCRIPTDIR,'run_wave2d_dx.sce'],[DIRNAME,'run_wave2d_dx.sce']);
gd_putfile(GLOBUSSERVER,[SCRIPTDIR,'wave2d.sce'],[DIRNAME,'wave2d.sce']);
gd_putfile(GLOBUSSERVER,[SCRIPTDIR,'wave2ddx_1.in'],[DIRNAME,'wave2ddx_1.in']);

disp ('  Files Transferred');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Run the demonstration script
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Modify the permissions on the shell script, currently there is no API to
% perform chmod in the file transfer so this is a work around.
%disp('>> jobhandle = gd_jobsubmit([''&(executable=/bin/chmod) (arguments = 700 '',DIRNAME,''mat_ice_sge_lorenz.sh)''],GLOBUSSERVER);')
%jobhandle = gd_jobsubmit(['&(executable=/bin/chmod) (arguments = 700 ',DIRNAME,'mat_ice_sge_lorenz.sh)'],GLOBUSSERVER);
%gd_jobpoll(jobhandle);

% The RSL string describes the GRAM job to be submitted to GLOBUSSERVER, the
% stdout and stderr are redirected to file. Note that GRAM will append
% existing files of the same name with output
RSLstring = ['&(executable=',SCIHOME,'/bin/scilab)(environment=(SCI "',SCIHOME,'"))(arguments = -nb -nw -f ',DIRNAME,'run_wave2d_dx.sce)(stdout=',DIRNAME,'stdout.out)(stderr=',DIRNAME,'stdout.err)'];
%RSLstring = ['&(executable=mat_ice_sge_lorenz.sh)(stdout=',DIRNAME,'stdout.out)(stderr=',DIRNAME,'stderr.out)'];
disp(['>> RSL = ', RSLstring,';']);
% Submit the job to the GRAM gatekeeper on GLOBUSSERVER
jobhandle = gd_jobsubmit(RSLstring,JOBMANAGER);

% Terminate the GRAM job
%gd_jobkill(jobHandle)


% Poll the GRAM job every 5 seconds for a maximum of one minute
gd_jobpoll(jobhandle, 5, 1200);

%disp (' ');
%disp ('  Press any key to continue');
%pause
%disp (' ');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get the output files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Retrieve the files
disp('Getting output file wave2ddx_1.out');
gd_getfile(GLOBUSSERVER,[DIRNAME,'wave2ddx_1.out'],[pwd,'/wave2ddx_1.out']);



% Delete local files
% disp('>> delete([pwd,''/stdout.out''])')
% delete([pwd,'/stdout.out'])
% disp('>> delete([pwd,''/stdout.out''])')
% delete([pwd,'/stderr.out'])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Delete the remote files 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Delete remote files
gd_rmfile(GLOBUSSERVER,[DIRNAME,'wave2ddx_1.out']);
gd_rmfile(GLOBUSSERVER,[DIRNAME,'wave2ddx_1.in']);
gd_rmfile(GLOBUSSERVER,[DIRNAME,'run_wave2d_dx.sce']);
gd_rmfile(GLOBUSSERVER,[DIRNAME,'wave2d.sce']);
gd_rmfile(GLOBUSSERVER,[DIRNAME,'stdout.out']);
gd_rmfile(GLOBUSSERVER,[DIRNAME,'stdout.err']);
% Delete remote directory
gd_rmdir(GLOBUSSERVER, DIRNAME);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Destroy the proxy certificate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%gd_destroyproxy;

%disp (' ');
%disp ('  gd_lorenz Script complete');

exit;
