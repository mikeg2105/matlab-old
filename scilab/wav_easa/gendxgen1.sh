#!/bin/sh

#Generate general files for dx
nsteps=10
nx=100
ny=100

for jobname in 'job3'
do

     
     formfilename="dx/"$jobname"_form.general"
     datfilename="dx/"$jobname".general"
          
     #echo " formfile is: "$formfilename
     
     #generate form.gen file
     echo "file="$jobname"/results/"$jobname".form" > tmp/temp1
     cat tmp/temp1 dx/base1_temp1.gen > $formfilename


     echo "file="$jobname"/results/"$jobname".out" > tmp/temp1
     echo "grid" $nx "x" $ny > tmp/temp2
     echo "series = " $nsteps ", 1, 1, separator=lines 1" > tmp/temp3
     
     
     cat tmp/temp1 tmp/temp2 dx/base1.gen tmp/temp3 dx/base3.gen > $datfilename
          
     

done
