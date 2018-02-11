function allConfigs = distcompUserConfig()
%distcompUserConfig Return all the user configurations for the Distributed 
%Computing Toolbox as a cell array of function handles.
%
%   Copy this file to a directory that is higher on your MATLAB path than
%   MATLABROOT/toolbox/distcomp/user and edit so that it accurately reflects
%   your scheduler and how you want to run your jobs.
%
%   The most common way of modifying this file is to identify your scheduler
%   and customize the corresponding subfunction.
%    - If you are using a job manager, customize the 'jobmanager' subfunction
%    - If you are using LSF, customize the 'lsf' subfunction
%    - If you are using CCS, customize the 'ccs' subfunction
%    - If you are using the generic scheduler interface, customize the 'generic'
%    subfunction
%    - If you are using the mpiexec scheduler interface, customize the 'mpiexec'
%    subfunction
%
%   This API is subject to change in a future release.  Please be aware that the
%   configurations you enter in this file may need to be moved to a new API at a
%   later date.

%   Copyright 2005-2006 The MathWorks, Inc.
%   $Revision: 1.1.10.3.2.1 $  $Date: 2006/08/06 04:53:11 $

% In addition to modifying the configurations shown below, you can add new
% configurations.  If you want to create a new configuration called 'myconfig',
% add the subfunction myconfig to this file, and add the function handle
% @myconfig to the following cell array.

allConfigs = {@jobmanager, @lsf, @ccs, @sge, @mpiexec};

function conf = jobmanager()
%JOBMANAGER Return a sample configuration for a job manager.
%   You might want to change the name of the job manager, and assign values to
%   LookupURL and PathDependencies.

    %% Parameters to the findResource command
    % See the help for findResource for more information.
    % This is required for this configuration to be complete:
    conf.findResource.Type = 'jobmanager';
    % This is required for this configuration to be complete:
    conf.findResource.Name = 'default_jobmanager';
    % This is required for this configuration to be complete:
    %conf.findResource.LookupURL = 'JobManagerHost';
    conf.findResource.State = 'running';

    %% Job properties 
    % Use the doc command to obtain more information about these properties.
    % For example:  doc PathDependencies
    conf.job.PathDependencies = {}; 
    conf.job.FileDependencies = {};
    % The following job properties are specific to the job manager:
    conf.job.RestartWorker = false;
    conf.job.MaximumNumberOfWorkers = inf;
    conf.job.MinimumNumberOfWorkers = 1;
    conf.job.Timeout = inf;

    %% Parallel job properties 
    % Use the doc command to obtain more information about these properties.
    % For example:  doc PathDependencies
    conf.paralleljob.PathDependencies = {}; 
    conf.paralleljob.FileDependencies = {};
    conf.paralleljob.MaximumNumberOfWorkers = inf;
    conf.paralleljob.MinimumNumberOfWorkers = 1;
    % The following paralleljob properties are specific to the job manager:
    conf.paralleljob.RestartWorker = false;
    conf.paralleljob.Timeout = inf;
    
    %% Task properties
    % Use the doc command to obtain more information about these properties.
    % For example:  doc CaptureCommandWindowOutput
    conf.task.CaptureCommandWindowOutput = false;
    % The following task properties are specific to the job manager:
    conf.task.Timeout = inf;
    conf.task.FinishedFcn = '';

function conf = lsf()
%LSF Return a sample configuration for an LSF cluster.
%   You might want to assign values to DataLocation and to PathDependencies.

    %% Parameters to the findResource command
    % See the help for findResource for more information.
    % This is required for this configuration to be complete:
    conf.findResource.Type = 'LSF';

    %% LSF scheduler properties 
    % Use the doc command to obtain more information about these properties.
    % For example:  doc DataLocation
    % This is required for this configuration to be complete:
    % conf.lsfscheduler.DataLocation = '';
    conf.lsfscheduler.HasSharedFileSystem = true;
    conf.lsfscheduler.ClusterMatlabRoot = '';
    conf.lsfscheduler.SubmitArguments = '';
    % To run parallel jobs, the LSF scheduler automatically selects values for the
    % following properties, but you may need to override them:
    % conf.lsfscheduler.ClusterOsType = 'unix';
    % conf.lsfscheduler.ParallelSubmissionWrapperScript = '';
    % (Refer to the documentation for function "setupForParallelExecution")
    
    %% Job properties 
    % Use the doc command to obtain more information about these properties.
    % For example:  doc PathDependencies    
    conf.job.PathDependencies = {};
    conf.job.FileDependencies = {};
    
    %% Task properties
    % Use the doc command to obtain more information about these properties.
    % For example:  doc CaptureCommandWindowOutput
    conf.task.CaptureCommandWindowOutput = false;
    
function conf = ccs()
%CCS Return a sample configuration for a CCS cluster.
%   You might want to assign values to DataLocation and to PathDependencies.

    %% Parameters to the findResource command
    % See the help for findResource for more information.
    % This is required for this configuration to be complete:
    conf.findResource.Type = 'ccs';

    %% CCS scheduler properties 
    % Use the doc command to obtain more information about these properties.
    % For example:  doc DataLocation
    % This is required for this configuration to be complete:
    % conf.ccsscheduler.DataLocation = '';
    % conf.ccsscheduler.ClusterMatlabRoot = '';
    conf.ccsscheduler.HasSharedFileSystem = true;
    % If you have a network install of matlab the setting below will make
    % ClusterMatlabRoot the same as the matlabroot of the current matlab
    % conf.ccsscheduler.ClusterMatlabRoot = dctReplaceDriveWithUNCPath(matlabroot);    
    % conf.ccsscheduler.SchedulerHostname = '';
    
    %% Job properties 
    % Use the doc command to obtain more information about these properties.
    % For example:  doc PathDependencies    
    conf.job.PathDependencies = {};
    conf.job.FileDependencies = {};
    
    %% Task properties
    % Use the doc command to obtain more information about these properties.
    % For example:  doc CaptureCommandWindowOutput
    conf.task.CaptureCommandWindowOutput = false;
    
    
function conf = sge()
%GENERIC Return a sample configuration for a generic scheduler.
%   You might want to assign values to DataLocation, SubmitFcn, and 
%   PathDependencies.

    %% Parameters to the findResource command
    % See the help for findResource for more information.
    % This is required for this configuration to be complete:
    conf.findResource.Type = 'generic';
    
    %% Generic scheduler properties 
    % Use the doc command to obtain more information about these properties.
    % For example:  doc DataLocation
    % This is required for this configuration to be complete:
    % conf.genericscheduler.DataLocation = '';
    conf.genericscheduler.HasSharedFileSystem = true;
    conf.genericscheduler.ClusterMatlabRoot = '/usr/local/packages/matlab_mdcdem_r06b';
    % This is required for this configuration to be complete:
    conf.genericscheduler.SubmitFcn =  @sgeSubmitFcn;
    % The following are required to run parallel jobs:
    conf.genericscheduler.ParallelSubmitFcn = @sgeParallelSubmitFcn;
    conf.genericscheduler.ClusterOsType = 'unix';
    %% Job properties 
    % Use the doc command to obtain more information about these properties.
    % For example:  doc PathDependencies
    conf.job.PathDependencies = {};
    conf.job.FileDependencies = {};
    
    %% Task properties
    % Use the doc command to obtain more information about these properties.
    % For example:  doc CaptureCommandWindowOutput
    conf.task.CaptureCommandWindowOutput = false;
    
function conf = mpiexec()
%MPIEXEC Return a sample configuration for the mpiexec scheduler.
%   You might want to assign values to DataLocation, PathDependencies and 
%   MaximumNumberOfWorkers.    

    %% Parameters to the findResource command
    % See the help for findResource for more information.
    % This is required for this configuration to be complete:
    conf.findResource.Type = 'mpiexec';

    %% mpiexec scheduler properties 
    % Use the doc command to obtain more information about these properties.
    % For example:  doc DataLocation
    % This is required for this configuration to be complete:
    % conf.mpiexec.DataLocation = '';
    % conf.mpiexec.MpiexecFilename = '';
    % conf.mpiexec.HasSharedFileSystem = true;
    conf.mpiexec.ClusterMatlabRoot = '';
    conf.mpiexec.SubmitArguments = '';
    conf.mpiexec.EnvironmentSetMethod = '-env';
    % conf.mpiexec.ClusterOsType = 'unix';
    
    %% Parallel job properties 
    % Use the doc command to obtain more information about these properties.
    % For example:  doc PathDependencies    
    conf.paralleljob.PathDependencies = {};
    conf.paralleljob.FileDependencies = {};
    % This is required to be a finite number for this configuration to be
    % complete:
    conf.paralleljob.MaximumNumberOfWorkers = inf;
    % mpiexec does not use the MinimumNumberOfWorkers property.
    % conf.paralleljob.MinimumNumberOfWorkers = 1;
    
    %% Task properties
    % Use the doc command to obtain more information about these properties.
    % For example:  doc CaptureCommandWindowOutput
    conf.task.CaptureCommandWindowOutput = false;
    
