%Script file for submitting wave job to grid
%Available nodes (nicknames)
%iceberg
%maxima
%snowdon
%ngs-c1
%ngs-c2

%The scilab input script file (.sce) is in the in directory

jobhandle=myjobsubmit('wave2ddx_1', 'ngs-c1');
%jobhandle='https://grid-compute.leeds.ac.uk:64021/22442/1127987794/';


status=gd_status_sci(jobhandle)

% Poll the GRAM job every 30 seconds for a maximum of 30 minutes
%gd_jobpoll(jobhandle, 30, 1800);



%status=myjobresult('wave2ddx_1');


