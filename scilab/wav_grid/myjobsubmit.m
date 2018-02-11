function [jobhandle]=myjobsubmit(jobname, node)

%Use the jobname to create list of input files
infiles={[jobname,'.sce'],'wave2d.sce'};
outfiles={[jobname,'.out'], [jobname,'.form']};


jobhandle=gd_submit_sci(jobname, node,infiles);

%save job info for reading later
jobfile=['in/',jobname,'.mat']
save(jobfile, 'jobhandle', 'jobname', 'node', 'infiles', 'outfiles');

%load(jobfile, 'jobhandle', 'jobname', 'node', 'infiles', 'outfiles');

%save job info as ascii
fd=fopen('tmp/jobtemp', 'w+');
fprintf(fd, '%s %s %s\n', jobhandle, jobname, node);
fclose(fd);

ucommand=['cat jobs.txt tmp/jobtemp > tmp/jobstemp.txt; mv tmp/jobstemp.txt jobs.txt'];
unix(ucommand);