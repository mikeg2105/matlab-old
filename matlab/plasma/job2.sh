#!/bin/bash
#$ -cwd -j y
#$ -l h_cpu=24:05:00

scilab -nb -nw -f atmosparticledx1.sce > out/job1.out
