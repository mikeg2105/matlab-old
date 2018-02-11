##############################################################################
#
# This gmake makefile makes the "H3expresso" code on the following 
# architectures:
#
#          CM-5 with Vector Units	cm5vu
#          Cray C90			c90
#
# Author: Joan Masso. Heavily based on the G code Makefile by John Towns
#
# **************************** INSTRUCTIONS **********************************
#
# "make"         -- makes the "H3expresso" code in the current directory 
#                  (subject to definitions below) using the  environment
#                  variable SYSTEM to set the type system to compile for. 
#                  If the environment variable SYSTEM is not set, the 
#                  Makefile makes a choice based on the information it can
#                  obtain from the system. This will work successfully for
#                  the following machines:
#			cm5.ncsa.uiuc.edu 
#                       mario.psc.edu
#
# "make clean"   -- removes all files and directories in the SRCD, OBJD 
#                  and EXED directories.
#                  #######################################################
#                  WARNING!!!! DO NOT USE THIS IF YOU SPECIFY ANY OF
#                  SRCD, OBJD or EXED AS ".", "./" or "".  THIS WILL
#                  DELETE THE FILES IN THE DIRECTORY HOLDING THE MAKEFILE!
#                  #######################################################
#
#
# ............................................................................
# NOTE:    Currently, it is assumed that include files are included via 
#	   the cpp "#include ..." statement and NOT via a Fortran include
#	   statement!  Also, the include files are kept in the CPPD directory.
# ............................................................................
#
#     Edit the CPPD, OBJD, FORD, EXED, and CMD definitions as
# you like for placing things where you want them.  The directories
# can even be symbolic links if you like.
#
#
# Define a cpp source file directory, a Fortran file subdirectory, 
# an object file subdirectory and an executable file subdirectory
#
CPPD= Cpp
SRCD= Src
OBJD= Obj
EXED= Exe

#
# Define all the .cpp files which should be located
# in the directory specified by $(CPPD)
# CPPS files generate Fortran source code
#
CPPS=	h3e.cpp		initial.cpp	invert.cpp 	\
	equations.cpp	method.cpp	boundaries.cpp

# 
# Define the input parameter files located in the CPPD directory.
# If an newer version of the parameter file exists in the current
# directory, it is copied to the EXED directory. It is assumed that 
# all input parameter files have the extensiom ".par".
#
PARS=	input.par

#
# Define the preprocessor to use
#
CPP=	/lib/cpp

#
# Define the name of the executable file built
#
CMD =	h3e


##########################################################################
#
#  The rest of this Makefile is not for the weak at heart.  Be careful
#  in editting it if you decide to do so.
#
##########################################################################

SHELL = /bin/sh

# List of supported systems

SYSTEMS=        cm5vu c90 


default:
	@if test -z "$(SYSTEM)"; then\
	   if test `uname -n` = "cm5"; then\
	      gmake cm5vu MAKE="gmake";\
	    else \
	      if test `uname -n` = "mario"; then\
	        gmake c90 MAKE="gmake";\
	       else \
	         gmake ERROR;\
	      fi;\
	   fi;\
	 fi

goober:

ERROR:
	@echo
	@echo \
'Must type "gmake <system>", where <system> is one of the following:'
	@echo
	@echo  "        $(SYSTEMS)"
	@echo
	@echo \
'Otherwise set the shell variable SYSTEM to one of these and just type "gmake".'
	@echo

#
# Make rules for particular type of systems
#
cm5vu: $(CPPD) $(SRCD) $(OBJD) $(EXED)
	$(MAKE) $(CMD)	FC='cmf' \
		ARCH='cm' \
		FFLAGS='-cm5 -vu -double -extend -cont=50' \
		LDFLAGS=' ' \
		LIBS='cmsslcm5vu' \
		CPPFLAGS='-C -DCM5 -P -I$(CPPD)' \
		SUFF='fcm'

c90:  $(CPPD) $(SRCD) $(OBJD) $(EXED)
	$(MAKE) $(CMD) FC='cf77' \
		ARCH='cray' \
		FFLAGS='-Zv -F -Wf"-o aggress" -N 80' \
		LDFLAGS=' ' \
		LIBS=' ' \
		CPPFLAGS='-C -DCRAY -P -I$(CPPD)' \
		SUFF='f'


# Make sure the directories exist
#
$(SRCD):
	mkdir $(SRCD)

$(OBJD):
	mkdir $(OBJD)

$(EXED):
	mkdir $(EXED)

#
# Build the code
#

SRCS=	$(CPPS:%.cpp=$(SRCD)/%.$(SUFF)) 
OBJS=	$(CPPS:%.cpp=$(OBJD)/%.o) 

# DO not remove the fortran generated files
#.PRECIOUS: $(SRCS)

$(CMD): $(EXED)/$(CMD) $(PARS:%=$(EXED)/%)

#
# Define the make rules for the executable
#
$(EXED)/$(CMD): $(SRCD) $(OBJD) $(OBJS)
	$(FC) $(FFLAGS) $(LDFLAGS) -o $(EXED)/$(CMD) $(OBJS) \
		$(LIBDIRS:%=-L%) $(LIBS:%=-l%) 

#
# Make sure there are input files in the EXED directory.
#
$(EXED)/%.par : %.par
	/bin/cp $< $(EXED)

#
# Define the make rules for the object files.
# the cm5 creates nasty .pe.o files.
#
$(OBJD)/%.o : $(SRCD)/%.$(SUFF)
	$(FC) $(FFLAGS) -c $<
	mv -f $(@F) $(OBJD)
	@if (test -f $(@F:%.o=%.pe.o) ); then\
		mv -f $(@F:%.o=%.pe.o) $(OBJD) ;\
	fi

#
# Define the make rules for the source files built
# from the .cpp files.
#
$(SRCD)/%.$(SUFF) : $(CPPD)/%.cpp
	$(CPP) $(CPPFLAGS) $< $(SRCD)/$(@F)


clean:
	rm -fr $(OBJD) $(SRCD) $(EXED)


