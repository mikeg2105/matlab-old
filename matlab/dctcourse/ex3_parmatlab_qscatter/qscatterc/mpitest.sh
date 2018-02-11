#!/bin/sh
MPIR_HOME=/usr/local/packages/openmpi-gnu-ether
#MPIR_HOME=/usr/local/mpich-gm2_PGI
#MPIR_HOME=/usr/local/packages/mpich-gnu-gm
#cd /home1/cs/cs1mkg/proj/cppdev/workspace/hello_mpi
$MPIR_HOME/bin/mpirun -np 2 -machinefile machines ./ex1

