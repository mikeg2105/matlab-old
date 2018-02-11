#!/bin/sh

#Generate general files for dx
nsteps=24
nx=51
ny=51
jobdir="out"
for jobname in 'job'
do

     
     formfilename="out/"$jobname"_form.general"
     datfilename="out/"$jobname".general"
          
     #echo " formfile is: "$formfilename
     
     #generate form.gen file
     #echo "file="$jobname"/results/"$jobname".form" > tmp/temp1
     #echo "file="$jobname"/job"$jobname"form.out" > tmp/temp1
     echo "file="$jobdir"/"$jobname"form.out" > tmp/temp1
     #cat tmp/temp1 dx/base1_temp1.gen > $formfilename
    cat tmp/temp1 dx/base1_form.gen > $formfilename

     echo "file="$jobdir"/"$jobname".out" > tmp/temp1
     echo "grid" $nx "x" $ny > tmp/temp2
     echo "series = " $nsteps ", 1, 1, separator=lines 1" > tmp/temp3
     
     
     cat tmp/temp1 tmp/temp2 dx/base1.gen tmp/temp3 dx/base3.gen > $datfilename
          
     

done
