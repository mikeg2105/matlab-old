#!/bin/sh

#Generate general files for dx
nits=100
nx=20
ny=20
nz=1
jobdir="results"


for jobname in 'diffuse2'
do

     
     gendatfilename="tmp/"$jobname".general"
     formfilename="tmp/"$jobname"_form.general"
     
     #echo "form is: "$formfilename " gendatfile is: "$gendatfilename
     
     #generate form.gen file
     echo "file=$jobdir/"$jobname".form" > tmp/temp1
     cat tmp/temp1 dx/form_temp1.gen > $formfilename
          
     #generate data.general file
     echo "file=$jobdir/"$jobname".dat" > tmp/temp2
     echo "grid= "$nx" x "$ny" x "$nz > tmp/temp3
     cat tmp/temp2 tmp/temp3 dx/data_temp1.gen > tmp/temp4
     echo "series= "$nits" , 1, 1, separator= lines 1" > tmp/temp5
     cat tmp/temp4 tmp/temp5 dx/data_temp2.gen > $gendatfilename     
     

done
