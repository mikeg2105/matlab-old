# generated by builder.sce : Please do not edit this file
# ------------------------------------------------------
SCIDIR =C:/PROGRA~1/scilab-4.0
SCIDIR1 =C:\PROGRA~1\scilab-4.0
# name of the dll to be built
LIBRARY = libfooc
# list of objects file
OBJS = fooc.obj
# added libraries 
OTHERLIBS = 
!include $(SCIDIR1)\Makefile.incl.mak
CFLAGS = $(CC_OPTIONS) -DFORDLL -I"$(SCIDIR)/routines" -Dmexfunction_=mex$*_  -DmexFunction=mex_$*  
FFLAGS = $(FC_OPTIONS) -DFORDLL -I"$(SCIDIR)/routines" -Dmexfunction=mex$* 
EXTRA_LDFLAGS = 
!include $(SCIDIR1)\config\Makedll.incl 
