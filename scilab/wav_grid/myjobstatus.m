function [status]=myjobstatus(jobname)






%save job info for reading later
jobfile=['in/',jobname,'.mat']

load(jobfile, 'jobhandle', 'jobname', 'node', 'infiles', 'outfiles');

disp(['Status for job',jobname]);

status=gd_status_sci(jobhandle);
