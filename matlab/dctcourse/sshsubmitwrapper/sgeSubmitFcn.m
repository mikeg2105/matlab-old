function sgeSubmitFcn(scheduler, job, props, varargin) 
%SUBMITFCN Submit a Matlab job to a SGE scheduler
%
% See also workerDecodeFunc.
%
% Assign the relevant values to environment variables, starting 
% with identifying the decode function to be run by the worker:

% Copyright 2006 The MathWorks, Inc.



% Submit the wrapper script to SGE once for each task, supplying a different
% environment each time.
for i = 1:props.NumberOfTasks
    fprintf('Submitting task %i\n', i);
    
envstr=makeenv(...
    'SGE_ROOT','/usr/local/sge6.0',...
    'SGE_ARCH','lx26-amd64',...
    'SGE_CELL','default',...
    'PATH','/usr/local/bin:/bin:/usr/bin:/usr/local/sge6.0/bin/lx26-amd64',...
    'MDCE_DECODE_FUNCTION', 'sgeDecodeFunc',...
    'MDCE_STORAGE_LOCATION', props.StorageLocation,... 
    'MDCE_STORAGE_CONSTRUCTOR', props.StorageConstructor,...
    'MDCE_JOB_LOCATION', props.JobLocation,... 
    'MDCE_DEBUG', 'true',...
    'MDCE_MATLAB_EXE', props.MatlabExecutable,...
    'MDCE_MATLAB_ARGS', props.MatlabArguments,...
    'MDCE_TASK_LOCATION', props.TaskLocations{i});

qsubScriptName=[pwd,'/myqsub_auto.sh']
makewrapper(qsubScriptName,envstr);
[dirpart] = fileparts( mfilename( 'fullpath' ) );
scriptName = fullfile( dirpart, 'sgeWrapper.sh' );

    % Choose a file for the output. Please note that currently, DataLocation refers
    % to a directory on disk, but this may change in the future.
    logFile = fullfile( scheduler.DataLocation, ...
                        sprintf( 'Job%d_Task%d.out', job.ID, job.Tasks(i).ID ) );
    % Finally, submit to SGE. note the following:
    % "-N Job#" - specifies the job name
    % "-j yes" joins together output and error streams
    % "-o ..." specifies where standard output goes to
    
    cmdLine = sprintf('ssh iceberg %s -N Job%d.%d -j yes -o "%s" "%s"', ...
                       qsubScriptName,job.ID, job.Tasks(i).ID, logFile, scriptName );
    [s, w] = system( cmdLine );

    if s ~= 0
        warning( 'distcompexamples:generic:SGE', ...
                 'Submit failed with the following message:\n%s', w);
    else
        % The output of successful submissions shows the SGE job identifier%
        fprintf( 1, 'Job output will be written to: %s\nQSUB output: %s\n', logFile, w );
    end
end

function str=makeenv(varargin)
str=sprintf('export %s="%s"\n',varargin{:})
function makewrapper(fname,envstr);
%makes a .sh wrapper for qsub that contains the necessary environment
%variables:
fid=fopen(fname,'w');
str=fprintf(fid,'#!/bin/sh \n #set environment variables: \n%s\nqsub $*\n',envstr)
fclose(fid);
unix(['chmod u+x ',fname]);


