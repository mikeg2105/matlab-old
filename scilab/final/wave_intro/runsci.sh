#!/bin/sh

#Shell script to run matlab

#method=0 run locally
#method=1 run using ssh
#method=2 run using geodise
method=1

if test "$method" -eq 0
then
   scilex -nb -nw -f run_wave2d_local_dx.sce
elif test "$method" -eq 1
then
  matlab -nosplash -nodisplay < gd_wave_sci.m
fi
