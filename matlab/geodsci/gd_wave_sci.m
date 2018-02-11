%Script file for submitting wave job to grid
infiles={'run_wave2d_dx.sce','wave2d.sce'};
outfiles={'wave2ddx_1.out', 'wave2ddx_1.form'};
node='ngs-c1';
jobname='wave2ddx_1';
%jobhandle='https://grid-compute.leeds.ac.uk:64021/22442/1127987794/';
jobhandle=gd_submit_sci(jobname, node,infiles);

%save job info for reading later
jobfile=[jobname,'.mat']
save(jobfile, 'jobhandle', 'jobname', 'node', 'infiles', 'outfiles');

%load(jobfile, 'jobhandle', 'jobname', 'node', 'infiles', 'outfiles');

%save job info as ascii
fd=fopen('jobtemp', 'w+');
fprintf(fd, '%s %s %s\n', jobhandle, jobname, node);
fclose(fd);

ucommand=['cat jobs.txt jobtemp > jobstemp.txt; mv jobstemp.txt jobs.txt'];
unix(ucommand);

status=gd_jobstatus(jobhandle)

% Poll the GRAM job every 30 seconds for a maximum of 30 minutes
%gd_jobpoll(jobhandle, 30, 1800);

%gd_results_sci(jobhandle, jobname, node,infiles, outfiles);


