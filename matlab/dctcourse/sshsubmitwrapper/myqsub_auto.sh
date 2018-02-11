#!/bin/sh 
 #set environment variables: 
export SGE_ROOT="/usr/local/sge6.0"
export SGE_ARCH="lx26-amd64"
export SGE_CELL="default"
export PATH="/usr/local/bin:/bin:/usr/bin:/usr/local/sge6.0/bin/lx26-amd64"
export MDCE_DECODE_FUNCTION="sgeDecodeFunc"
export MDCE_STORAGE_LOCATION="PC{}:UNIX{/home1/me/me1nds/DistributedIceberg/matlabdc/test1}:"
export MDCE_STORAGE_CONSTRUCTOR="makeFileStorageObject"
export MDCE_JOB_LOCATION="Job22"
export MDCE_DEBUG="true"
export MDCE_MATLAB_EXE="/usr/local/packages/matlab_mdcdem_r06b/bin/worker"
export MDCE_MATLAB_ARGS=""
export MDCE_TASK_LOCATION="Job22/Task1"

qsub $*
