#!/bin/bash

#$ -l h_rt=16:00:00
#$ -l arch=intel*
#$ -N hl_480_12800


scilab -nb -nw -f shootall_480_12800.sci
