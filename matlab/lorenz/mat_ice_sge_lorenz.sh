#!/bin/sh
#$ -cwd
#$ -l h_rt=00:30:00
#$ -q short.q

env
/usr/local/bin/matlab -nojvm -nosplash -nodisplay < runlorenz.m

