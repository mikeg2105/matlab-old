#!/bin/bash

#$ -l h_rt=16:00:00
#$ -l arch=intel*
#$ -N hl_60_1600


scilab -nb -nw -f shootall.sci