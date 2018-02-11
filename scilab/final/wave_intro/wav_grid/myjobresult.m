function [status]=myjobresult(jobname)






%save job info for reading later
jobfile=['in/',jobname,'.mat']

load(jobfile, 'jobhandle', 'jobname', 'node', 'infiles', 'outfiles');

gd_results_sci(jobhandle, jobname, node, infiles, outfiles);

status=gd_status_sci(jobhandle);