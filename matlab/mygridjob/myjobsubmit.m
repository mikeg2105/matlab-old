
%Use the jobname to create list of input files
%infiles={'sim.xml','initconfig.xml'};
%outfiles={[jobname,'.out'], [jobname,'.form']};

jobname='mystarjob1';
infiles={'StarSim1.xml'}
outfiles={'results.tar.gz'};
node='iceberg'


jobhandle=gd_submit_app('runapp.sh',jobname, node,infiles);

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