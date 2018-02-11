#!/bin/csh -f
# 
#
#___INFO__MARK_BEGIN__
##########################################################################
#
#  The Contents of this file are made available subject to the terms of
#  the Sun Industry Standards Source License Version 1.2
#
#  Sun Microsystems Inc., March, 2001
#
#
#  Sun Industry Standards Source License Version 1.2
#  =================================================
#  The contents of this file are subject to the Sun Industry Standards
#  Source License Version 1.2 (the "License"); You may not use this file
#  except in compliance with the License. You may obtain a copy of the
#  License at http://gridengine.sunsource.net/Gridengine_SISSL_license.html
#
#  Software provided under this License is provided on an "AS IS" basis,
#  WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING,
#  WITHOUT LIMITATION, WARRANTIES THAT THE SOFTWARE IS FREE OF DEFECTS,
#  MERCHANTABLE, FIT FOR A PARTICULAR PURPOSE, OR NON-INFRINGING.
#  See the License for the specific provisions governing your rights and
#  obligations concerning the Software.
#
#  The Initial Developer of the Original Code is: Sun Microsystems, Inc.
#
#  Copyright: 2001 by Sun Microsystems, Inc.
#
#  All Rights Reserved.
#
##########################################################################
#___INFO__MARK_END__

# 
# sample pvm job
# this script starts the pvm sample spmd
# note that this job uses the pvm group communication
# 
# our name 
#$ -N sciPVM_Job
# pe request
#$ -pe pvm 4
#$ -v SGE_QMASTER_PORT,DISPLAY
#$ -S /bin/csh
# ---------------------------

# uncomment the following line for tight integration
export PVM_TMP=$TMPDIR

echo "Got $NSLOTS slots."

/bin/echo Here I am on a $SGE_ARCH called `hostname`.

# spmd requests $NSLOTS on __different__ hosts
##$PVM_ROOT/pvm/bin/$PVM_ARCH/spmd $NSLOTS
scilab -nb -nw -f example_pvm.sce