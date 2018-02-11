#!/bin/sh 
#$ -S /bin/sh
#$ -o job.out
#$ -cwd
#$ -j y

#
#   Running your jobs:
#
#   This is an example that can be used to test
#   the wrqsub command there are three additional
#   features for the script file and these are
#   1.  Specify the shell using -S /bin/sh
#   2.  Specify the path and name of the SGE output data
#   3.  Specify that you are a White Rose Grid user with 
#       the -P WhiteRose option
#   4.  Finally before the application is executed
#       change directory (cd) to that containing the input files
#       the working directory for this job
#
#   You may need to specify the full path for the executable 
#
#
#  It is very likely that you have a program 
#  that reads some data from the keyboard/and or files
#  and writes some results out to the screen and/or files.
#  You now want to run this program in batch. 
# 
#   This directory contains an artificial program that 
#  calculates the effect of quotas on the fish stocks.
#   A technically simple problem, the politicians prefer  
#   not to know about!
#   
#  The program is named <fish> and resides in this directory.
#  Your task is to run this program under SGE on a remote
#  WRG node using wrqsub. 
#  The following steps are advisable: 
#  (1) Run the program and see what it does.
#  (2) Create an input file which will contain the data 
#      you would normally enter at the keyboard.
#  (3) Prepare a job submission script which will 
#        -read the data from your input file
#        -write the results into a job output file 
#         or another file of your choice.
#  (4) Submit the script to SGE.
#  
#  Your other most common problem will be to estimate how much 
#   time you will need to run your job. 
#  This is vitally important as you do not want want your job 
# to abort because you ran out of time. 
#  (5) type man -s1 time : to find out about the time command
#       type man times : to find out about the times command.
#      type man timex : to find out about the timex command.
#      There is also the /usr/bin/time command that can be used.
#      Finally you could call time routines in your program
#      for timing the runs. See: man time 
#  (6) Select a suitable timer command to time your run.
#       Using the reported values you can predict your h_cpu needs.      
#env
#cd $HOME/$1
#/home1/cs/cs1mkg/bin/flip -u mould1.db
#/home1/cs/cs1mkg/bin/flip -u job.dat

echo "job started" > jobstatus.txt
/usr/local/packages/matlab_r2006b_7.3/bin/matlab -nosplash -nodisplay  < qacctanalysis.m > job.out
echo "job finished" > jobstatus.txt 

