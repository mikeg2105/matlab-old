#!/bin/sh

#Generate general files for dx
nits=50
nx=40
ny=40
nz=1
jobdir="/home/mike/data/diffuse_rel"


for jobname in 'mrdifrun2_1' 'mrdifrun2_2' 'mrdifrun2_3' 'mrdifrun2_4' 'mrdifrun2_5' 'mrdifrun2_6' 'mrdifrun2_7' 'mrdifrun2_8' 'mrdifrun2_9' 'mrdifrun2_10' 'mrdifrun2_11' 'mrdifrun2_12' 'mrdifrun2_13' 'mrdifrun2_14' 'mrdifrun2_15' 'mrdifrun2_16' 'mrdifrun2_17' 'mrdifrun2_18' 'mrdifrun2_19' 'mrdifrun2_20'
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
