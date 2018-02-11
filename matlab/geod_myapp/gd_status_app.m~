function [jobstatus]=gd_status_app(jobhandle)
% 
%   This script uses geodise toolbox to return string value for job status
% 
status=gd_jobstatus(jobhandle);

if status==-1
    jobstatus='UNKNOWN';    
elseif status==1
    jobstatus='PENDING';
elseif status==2
    jobstatus='ACTIVE';
elseif status==3   
    jobstatus='DONE';
elseif status==4 
    jobstatus='FAILED';
elseif status==5
    jobstatus='SUSPENDED';
elseif status==6
    jobstatus='UNSUBMITTED';
end




