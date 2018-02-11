#!/bin/bash

# Select one node to be the job manager
JOB_MANAGER_NODE=0
numnodes=2
ii=0

echo $JOB_MANAGER_NODE
echo $GMPI_ID
/usr/local/packages/matlabr14mdcdemo/toolbox/distcomp/bin/mdce status


 #       if [ "$GMPI_ID" == "$JOB_MANAGER_NODE" ]
#	then
#		/usr/local/packages/matlabr14mdcdemo/toolbox/distcomp/bin/startjobmanager.sh -nojini -name MyJobManager
#        else
#            /usr/local/packages/matlabr14mdcdemo/toolbox/distcomp/bin/startworker.sh -jobmanager MyJobManager
#        fi

