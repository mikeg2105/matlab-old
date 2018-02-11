#!/bin/sh

#Generate general files for dx
nits=100
nx=30
ny=30
nz=30
jobdir="/scratch/cs1mkg/results/gr_harm_easa/out"


for jobname in 'test2_4'
do
  for jobtype in 'gxx' 'gxy' 'gxz' 'gyy' 'gyz' 'gzz' 'qxx' 'qxy' 'qxz' 'qyy' 'qyz' 'qzz'
  do
     
     gendatfilename="tmp/"$jobname"_"$jobtype".general"
     formfilename="tmp/"$jobname"_form.general"
     
     #echo "form is: "$formfilename " gendatfile is: "$gendatfilename
     
     #generate form.gen file
     echo "file=$jobdir/"$jobname".form" > tmp/temp1
     cat tmp/temp1 dx/form_temp1.gen > $formfilename
          
     #generate data.general file
     echo "file=$jobdir/"$jobname"_"$jobtype".dat" > tmp/temp2
     echo "grid= "$nx" x "$ny" x "$nz > tmp/temp3
     cat tmp/temp2 tmp/temp3 dx/data_temp1.gen > tmp/temp4
     echo "series= "$nits" , 1, 1, separator= lines 1" > tmp/temp5
     cat tmp/temp4 tmp/temp5 dx/data_temp2.gen > $gendatfilename     
     
  done

done
