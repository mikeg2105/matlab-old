#!/bin/sh
# Ensure that under SGE, we're in /bin/sh too:
#$ -S /bin/sh
#$ -cwd
#$ -N matdc_test2

/usr/local/packages/matlab_mdcdem_r06b/bin/matlab -nosplash -nodisplay < pjobdemo.m > mdcetest2.out
