#!/bin/sh
# Ensure that under SGE, we're in /bin/sh too:
#$ -S /bin/sh
#$ -cwd
#$ -N matdc_partest1

/usr/local/packages/matlab_mdcdem_r06b/bin/matlab -nosplash -nodisplay < pjobdemo.m > mdcepartest1.out
