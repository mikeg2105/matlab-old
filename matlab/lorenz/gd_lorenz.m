% 
%   This script uses geodise toolbox to run lorenz model
%   on iceberg and submit the job to sun grid engine



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Print the introduction 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc

disp ('  Run Lorenz model using geodise toolkit.') 

%disp ('  Press any key to continue')

%pause
disp (' ')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set up the demo variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The Globus server upon which to run the shell script. Note that the
% certificate subject line (returned by gd_certinfo) must map to a user
% account on the Globus server.
GLOBUSSERVER = 'iceberg.shef.ac.uk';
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
DIRNAME = 'geod/';
% Locate the directory containing the shell script
SCRIPTDIR = [fileparts(mfilename('fullpath')), filesep]
%JOBMANAGER = 'titania.shef.ac.uk/jobmanager-sge'
JOBMANAGER = [GLOBUSSERVER, '/jobmanager-sge']


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create a proxy certificate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%disp ('  (1) Query user credentials and create a proxy certificate')
%disp(' ')
%Query the user's certificate
%disp ('>> subject = gd_certinfo ')
%subject = gd_certinfo

% Create a Globus proxy certificate for GSI authentication
%disp ('>> gd_createproxy')
%gd_createproxy
%disp (' ')

% Return information about the proxy certificate
%disp ('>> gd_proxyinfo; ')
%gd_proxyinfo;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Put the remote files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(['>> gd_makedir(''',GLOBUSSERVER,''' ,''', DIRNAME, ''')'])
gd_makedir(GLOBUSSERVER, DIRNAME)


% GridFTP the demo shell script from the local directory to the users home
% directory on GLOBUSSERVER 
disp(' ')
disp('  (2.3) Transfering matlabDemo.sh to Globus server using GridFTP')
disp(['>> gd_putfile(''',GLOBUSSERVER,''' ,''',SCRIPTDIR,'matlabDemo.sh',''' ,''',DIRNAME,'matlabDemo.sh',''')'])
%gd_putfile(GLOBUSSERVER,[SCRIPTDIR,'mat_ice_sge_lorenz.sh'],[DIRNAME,'mat_ice_sge_lorenz.sh'])
gd_putfile(GLOBUSSERVER,[SCRIPTDIR,'lorenz.m'],[DIRNAME,'lorenz.m'])
gd_putfile(GLOBUSSERVER,[SCRIPTDIR,'runlorenz.m'],[DIRNAME,'runlorenz.m'])

%disp (' ')
%disp ('  Press any key to continue')
%pause
%disp (' ')
disp ('  Files Transferred')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Run the demonstration script
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Modify the permissions on the shell script, currently there is no API to
% perform chmod in the file transfer so this is a work around.
%disp('>> jobhandle = gd_jobsubmit([''&(executable=/bin/chmod) (arguments = 700 '',DIRNAME,''mat_ice_sge_lorenz.sh)''],GLOBUSSERVER);')
%jobhandle = gd_jobsubmit(['&(executable=/bin/chmod) (arguments = 700 ',DIRNAME,'mat_ice_sge_lorenz.sh)'],GLOBUSSERVER);
gd_jobpoll(jobhandle);

% The RSL string describes the GRAM job to be submitted to GLOBUSSERVER, the
% stdout and stderr are redirected to file. Note that GRAM will append
% existing files of the same name with output
RSLstring = ['&(executable=/usr/local/bin/matlab)(arguments = -nojvm -nosplash -nodisplay )(stdin=',DIRNAME,'runlorenz.m)(stdout=',DIRNAME,'stdout.out)(stderr=',DIRNAME,'stderr.out)'];
%RSLstring = ['&(executable=mat_ice_sge_lorenz.sh)(stdout=',DIRNAME,'stdout.out)(stderr=',DIRNAME,'stderr.out)'];
disp(['>> RSL = ', RSLstring,';'])
% Submit the job to the GRAM gatekeeper on GLOBUSSERVER
jobhandle = gd_jobsubmit(RSLstring,JOBMANAGER)

% Terminate the GRAM job
%gd_jobkill(jobHandle)


% Poll the GRAM job every 5 seconds for a maximum of one minute
gd_jobpoll(jobhandle, 30, 1200);

disp (' ')
disp ('  Press any key to continue')
pause
disp (' ')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get the output files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Retrieve the files
disp('Getting output file rlorenzout.mat')
gd_getfile(GLOBUSSERVER,[DIRNAME,'rlorenzout.mat'],[pwd,'/rlorenzout.mat'])



% Delete local files
% disp('>> delete([pwd,''/stdout.out''])')
% delete([pwd,'/stdout.out'])
% disp('>> delete([pwd,''/stdout.out''])')
% delete([pwd,'/stderr.out'])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Delete the remote files 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Delete remote files
gd_rmfile(GLOBUSSERVER,[DIRNAME,'rlorenzout.mat'])

gd_rmfile(GLOBUSSERVER,[DIRNAME,'lorenz.m'])
gd_rmfile(GLOBUSSERVER,[DIRNAME,'runlorenz.m'])
gd_rmfile(GLOBUSSERVER,[DIRNAME,'stdout.out'])
gd_rmfile(GLOBUSSERVER,[DIRNAME,'stdout.err'])
% Delete remote directory
gd_rmdir(GLOBUSSERVER, DIRNAME)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Destroy the proxy certificate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%gd_destroyproxy;

disp (' ')
disp ('  gd_lorenz Script complete')
