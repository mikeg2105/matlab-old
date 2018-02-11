% Abort left over jobs.
MPI_Abort;
pause(2.0);

% Delete left over MPI directory
MatMPI_Delete_all;
pause(2.0);

% Define machines, empty means run locally.
machines = {'comp41','comp46'};

% Define machines for Group 102 cluster.
%machines = {'node-a:/gigabit/node-a/kepner' ...
%            'node-b:/gigabit/node-b/kepner' ...
%            'node-c:/gigabit/node-c/kepner' ...
%            'node-d:/gigabit/node-d/kepner' ...
%            'node-e:/gigabit/node-e/kepner' ...
%            'node-f:/gigabit/node-f/kepner' ...
%            'node-g:/gigabit/node-g/kepner' ...
%            'node-h:/gigabit/node-h/kepner'};

% Example scripts.
%eval( MPI_Run('xbasic',     2,machines) );
% eval( MPI_Run('basic_mk1',      4,machines) );
% eval( MPI_Run('multi_basic',2,machines) );
% eval( MPI_Run('probe',      2,machines) );
% eval( MPI_Run('speedtest',  4,machines) );
 eval( MPI_Run('basic_app',  4,machines) );
% eval( MPI_Run('broadcast',  2,machines) );
% eval( MPI_Run('blurimage',  2,machines) );
% eval( MPI_Run('basic_app2',  2,machines) );
% eval( MPI_Run('basic_app3',  2,machines) );
% eval( MPI_Run('basic_app4',  2,machines) );


