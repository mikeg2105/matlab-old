#!/bin/sh
#Script to generate the job input files
#using sed and template files in ingen

#For a range of parameters will create input files
# from a template using sed.

#Generates matlab files for processing the list of jobs
#myjobs.m to submit all of the jobs
#myjobstatus.m  to get status of all  of the jobs
#myjobresults.m to get the results from all of the jobs

#instead of myjobs we use the root name for the job set

jobsetname="tjarray1"
jobname="tj1"

count=0

for wtype in "1" "0"
do
	jobroot1=$jobname"_"$wtype
	for wamp in "20" "40"
	do
		jobroot2=$jobroot1"_"$wamp
		for wnum1 in "5" "20"
		do
			jobroot3=$jobroot2"_"$wnum1
			for wnum2 in "20" "5"
			do
				jobroot4=$jobroot3"_"$wnum2
				for wfreq in "6" "12"
				do
					jobroot=$jobroot4"_"$wfreq
					jobfile=$jobroot".sce"
					
					cp in/jobtemplate.sce tmp/jtemp2.sce
					
					echo "s/?wjname?/$jobroot/g" > tmp/ssed 
					sed -f tmp/ssed tmp/jtemp2.sce > tmp/jtemp1.sce
					
					
					echo "s/?wtype?/$wtype/g" > tmp/ssed
					sed -f tmp/ssed tmp/jtemp1.sce > tmp/jtemp2.sce
					echo "s/?wamp?/$wamp/g" > tmp/ssed 
					sed -f tmp/ssed tmp/jtemp2.sce > tmp/jtemp1.sce
					echo "s/?wnum1?/$wnum1/g" > tmp/ssed
					sed -f tmp/ssed tmp/jtemp1.sce > tmp/jtemp2.sce
					echo "s/?wnum2?/$wnum2/g" > tmp/ssed
					sed -f tmp/ssed tmp/jtemp2.sce > tmp/jtemp1.sce
					echo "s/?wfreq?/$wfreq/g" > tmp/ssed
					sed -f tmp/ssed tmp/jtemp1.sce > tmp/jtemp2.sce
					mv tmp/jtemp2.sce in/$jobfile
	
					#which node are we selecting
					count=$[$count+1]
					if test "$count" -lt 16
					then					
						node="iceberg"
					elif test "$count" -gt 15 &&  test "$count" -lt 32
					then
						node="ngs-c1"
					elif test "$count" -gt 31 &&  test "$count" -lt 64
					then
						node="maxima"
					else
						node="snowdon"					
					fi
					
					#append to my jobs.m file
					filename=$jobsetname"sub.m"
					
					if test $count -eq 1
					then
						echo "myjobsubmit('"$jobroot"', '"$node"');" > $filename
						cp $filename tmp/tempsub
					else
						echo "myjobsubmit('"$jobroot"', '"$node"');" > tmp/myjobstemp
						cp $filename tmp/tempsub
						cat tmp/tempsub tmp/myjobstemp > $filename
					fi
					
					
					#append to myjobstatus.m file
					filename=$jobsetname"stat.m"
					if test $count -eq 1
					then
						echo "myjobstatus('"$jobroot"');" > $filename
						cp $filename tmp/tempsub
					else
						echo "myjobstatus('"$jobroot"');" > tmp/myjobstemp
						cp $filename tmp/tempsub
						cat tmp/tempsub tmp/myjobstemp > $filename
					fi
					
					
					#append to myjoberesult.m file
					filename=$jobsetname"res.m"
					if test $count -eq 1
					then
						echo "myjobresult('"$jobroot"');" > $filename
						cp $filename tmp/tempsub
					else
						echo "myjobresult('"$jobroot"');" > tmp/myjobstemp
						cp $filename tmp/tempsub
						cat tmp/tempsub tmp/myjobstemp > $filename
					fi
					
				
				done
			done
		done
	done
done

