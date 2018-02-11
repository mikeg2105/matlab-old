#!/bin/sh
export MPIR_HOME=/usr/local/mpich-gm2_GNU
#cd /home1/cs/cs1mkg/proj/cppdev/workspace/hello_mpi
$MPIR_HOME/bin/mpirun -np 4 -machinefile machines ./ex1

