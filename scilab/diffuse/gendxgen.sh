#!/bin/sh

#Generate general files for dx
nits=20
nx=6
ny=6
nz=6


for jobname in 'test1_1' 'test1_2'  'test1_3' 'test1_4'  'test1_5' 'test1_6'  'test1_7' 'test1_8'  'test1_9' 'test1_10'  'test1_11' 'test1_12'  'test1_13' 'test1_14'  'test1_15'
do
  for jobtype in 'gxx' 'gxy' 'gxz' 'gyy' 'gyz' 'gzz' 'qxx' 'qxy' 'qxz' 'qyy' 'qyz' 'qzz'
  do
     
     gendatfilename="tmp/"$jobname"_"$jobtype".general"
     formfilename="tmp/"$jobname"_form.general"
     
     #echo "form is: "$formfilename " gendatfile is: "$gendatfilename
     
     #generate data.gen file
     echo "file=out/"$jobname".form" > tmp/temp1
     cat tmp/temp1 dx/form_temp1.gen > $formfilename
          
     #generate form file
     echo "file=out/"$jobname"_"$jobtype".dat" > tmp/temp2
     echo "grid= "$nx" x "$ny" x "$nz > tmp/temp3
     cat tmp/temp2 tmp/temp3 dx/data_temp1.gen > tmp/temp4
     echo "series= "$nits" , 1, 1, separator= lines 1" > tmp/temp5
     cat tmp/temp4 tmp/temp5 dx/data_temp2.gen > $gendatfilename     
     
  done

done
