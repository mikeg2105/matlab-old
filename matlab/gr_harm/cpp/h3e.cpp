*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
*
* [FILE]       h3e.cpp
*
* [VERSION]    H3expresso  (c) 1995 Joan Masso, NCSA & UIB
*
* [PURPOSE]    Main Control File
*
* [ROUTINES]   Init_H3  
*              Readinput
*              H3
*              Information Info_header  
*              time_start time_stop time_show 
*              Welcome Goodbye
*
* [COMMENTS]   The main code has been split into an initialization part
*      and an evolution part to be able to use dynamic memory allocation.
*      See Init_H3 and H3 documentation.
*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$



*==============================================================================
*         
*  [ROUTINE NAME] Init_H3
*  [AUTHOR] Joan Masso, NCSA & UIB
* 
*  [PURPOSE] Wrapper for the main code:
*     (1) Reads the parameters thru readinput
*     (2) Calls the main code H3
*     (3) Gives timing info. 
*
*  [VARIABLES]
*     These "parameters" will be set by calling readinput and passed to 
*     the main H3 code:
*        nx,ny,nz  : grid sizes of the 3d cube.
*        dx,dy,dz  : grid spacings
*        iterations: the number of iterations to evolve
*        par1,par2 : Parameters for the initial data.    
*
*     Unlike the full H version, H3expresso has a very restricted set of
*     parameters so no common block is used to store them and they are passed
*     to the main program.  The most important "parameters" of the run are the
*     grid sizes, as the main program will allocate dynamically the memory for
*     all of the arrays. This feature requires F90 style memory allocation
*     support.
*
*  [CALLED BY]  NONE: This is the program entry.
*  [CALLS  TO]  readinput
*               H3
*               time_start time_stop time_show
*               Welcome  Goodbye
*
*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
      program Init_H3
      implicit none

C     Parameters
      integer iterations,nx,ny,nz 
      real dx,dy,dz,par1,par2

      real cpu                  


      call Welcome

      call readinput(iterations,nx,ny,nz,dx,dy,dz,par1,par2)

      call time_start

      call H3(iterations,nx,ny,nz,dx,dy,dz,par1,par2)

      call time_stop(cpu)
      call time_show(cpu,iterations,nx,ny,nz)

      call Goodbye

      stop
      end
*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


*==============================================================================
*         
*  [ROUTINE NAME] Readinput
*  [AUTHOR] Joan Masso, NCSA & UIB
* 
*  [PURPOSE] Read from the text file "input.par" the control parameters. 
*            Stops if the file is not found or the format is the right one.
*            H3expresso changes the format of H3.3 to simplify the routine/
*            Now the format of the file is SHITTY but simple: one value
*            in each line and in the right order, with optional comments 
*            following all the values.
*
*  [ARGUMENTS]
*     [OUTPUT]
*        nx,ny,nz  : grid sizes of the 3d cube.
*        dx,dy,dz  : grid spacings
*        iterations: the number of iterations to evolve
*        par1,par2 : Parameters for the initial data.    
*
*  [CALLED BY]  Init_H3
*
*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

      subroutine readinput(iterations,nx,ny,nz,dx,dy,dz,par1,par2)
      
      implicit none
      
      integer iterations,nx,ny,nz
      real dx,dy,dz,par1,par2
      
      write (*,*) 'Reading input.par ...'
      open (21,file='input.par',status='old',err=8888)
      
      read(21,*,err=9999) iterations
      write(*,994) 'Iterations',iterations
            
c     h3expresso: only cubic grid allowed
      read(21,*,err=9999) nx
       ny=nx
       nz=nx
       write(*,994) 'N',nx
       if (nx.le.3) then
          write(*,*) '***> ERROR: N must be >= 3 ...be serious!'
          stop
       endif              
c     Again, h3expresso forces the same spacing...
      read(21,*,err=9999) dx
       write(*,996) 'dx =',dx
       dy=dx
       dz=dx
      
c     read amplitude and mvalue : the meaning comes from 
c     the Initial routine. 
      read(21,*,err=9999) par1
      write(*,996) 'amplitude',par1

      read(21,*,err=9999) par2
      write(*,996) 'shape',par2
      if (abs(par2).gt.2) then
         write(*,*) '***> ERROR: -2 < shape < 2'
         stop 
      endif

 994  format (5x,A15,' = ',I5)
 996  format (5x,A15,' = ',3x,F8.5)

      close(21,err=8889)

      return

c     Error handling.
 8888 write(*,*) 'Error trying to open input.par. Check that it is'
      write(*,*) 'in this directory. Make some popcorn.'
      stop
 8889 write(*,*) 'Error trying to close input.par. That IS strange.'
      stop

 9999 write(*,*) 'Error reading input.par file. Check format.'
      stop

      end
*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>



*==============================================================================
*
*  [ROUTINE NAME] H3
*  [AUTHOR] Joan Masso, NCSA & UIB
* 
*  [PURPOSE] Main code: it does the evolution by calling the routines
*     to set the initial data at iteration 0 (H3expresso restriction)
*     and then calling the method (H3expresso only implements Macormack) 
*     and the boundaries at every time step. H3expresso does not
*     have I/O so no output routine is called. Instead, some minimal
*     information is given at every iteration.
*
*  [ARGUMENTS] All the parameters from Init_H3 
*     [INPUT]
*        nx,ny,nz  : grid sizes of the 3d cube.
*        dx,dy,dz  : grid spacings
*        iterations: the number of iterations to evolve
*        par1,par2 : Parameters for the initial data.    
*
*  [INCLUDES]  metric.h  declares all the grid and metric arrays.
*
*  [VARIABLES] The whole grid and metric structure is allocated here. 
*     See the documentation of the header file metric.h. 
*
*  [CALLED BY]  Init_H3
*  [CALLS  TO]  Initial
*               Information Info_header
*               Method
*               Boundaries
*  
*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

      subroutine H3(iterations,nx,ny,nz,dx,dy,dz,par1,par2)
      implicit none

c     Input Arguments
      integer iterations,nx,ny,nz
      real dx,dy,dz,par1,par2

C     Current iteration, time and time step
      integer currentiter       
      real time,dt              

c     Metric data structure 
#include "metric.h"

      write(*,*) 'Evolution started...'

C     H3expresso always starts with Iteration 0
      currentiter=0
      call Initial(
     &     nx,ny,nz,dx,dy,dz,par1,par2,
     &     time,dt,
     &     x,y,z,r,psi,
     &     alp,cux,cuy,cuz,rg,
     &     uxx,uxy,uxz,uyy,uyz,uzz,
     &     gxx,gxy,gxz,gyy,gyz,gzz,
     &     qxx,qxy,qxz,qyy,qyz,qzz,
     &     dxuxx,dxuxy,dxuxz,dxuyy,dxuyz,dxuzz,
     &     dyuxx,dyuxy,dyuxz,dyuyy,dyuyz,dyuzz,
     &     dzuxx,dzuxy,dzuxz,dzuyy,dzuyz,dzuzz
     &     )

c     Initialize the header (sending the name of the variable that
c     is going to be used) and show info about the first iteration.
      call Info_header('gxx')
      call Information(nx,ny,nz,currentiter,time,gxx)

C     MAIN LOOP : perform evolution
      do currentiter=1,iterations

c        The evolved level will be at the new time
         time = time+dt
         
c        H3expresso: only 1 method (Macormack)
         call Method(
     &        nx,ny,nz,
     &        dt,dx,dy,dz,
     &        x,y,z,r,psi,
     &        alp,cux,cuy,cuz,rg,
     &        uxx,uxy,uxz,uyy,uyz,uzz,
     &        gxx,gxy,gxz,gyy,gyz,gzz,
     &        qxx,qxy,qxz,qyy,qyz,qzz,
     &        dxuxx,dxuxy,dxuxz,dxuyy,dxuyz,dxuzz,
     &        dyuxx,dyuxy,dyuxz,dyuyy,dyuyz,dyuzz,
     &        dzuxx,dzuxy,dzuxz,dzuyy,dzuyz,dzuzz
     &        )

c        Boundary conditions
         call Boundaries(
     &        nx,ny,nz,time,dt,dx,dy,dz,
     &        x,y,z,r,psi,
     &        alp,cux,cuy,cuz,rg,
     &        uxx,uxy,uxz,uyy,uyz,uzz,
     &        gxx,gxy,gxz,gyy,gyz,gzz,
     &        qxx,qxy,qxz,qyy,qyz,qzz,
     &        dxuxx,dxuxy,dxuxz,dxuyy,dxuyz,dxuzz,
     &        dyuxx,dyuxy,dyuxz,dyuyy,dyuyz,dyuzz,
     &        dzuxx,dzuxy,dzuxz,dzuyy,dzuyz,dzuzz
     &        )

c        Show information 
         call Information(nx,ny,nz,currentiter,time,gxx)         
      end do

      return
      end
*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>



*==============================================================================
*
*  [ROUTINE NAME] Information
*  [AUTHOR] Joan Masso, NCSA & UIB
* 
*  [PURPOSE] Provide some info on the evolution as it runs.
*     H3expresso only shows the current iteration, the time and
*     the minimum and maximum values of the variable sent as an argument.
*
*     If the architecture does not support the MAXVAL and MINVAL
*     intrinsics, the search of max/min values is done thru loops.
*
*  [ARGUMENTS] 
*     [INPUT]
*        nx,ny,nz  : grid sizes of the 3d cube.
*        iter,time : Current iteration and time
*        var       : The 3d variable
*  [VARIABLES]
*     maxvar,minvar: Min and Max of the variable.
*
*  [CALLED BY]  H3
*
*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

      subroutine Information(nx,ny,nz,iter,time,var)
      implicit none
      integer nx,ny,nz
      integer iter
      real time
      real var(nx,ny,nz)

      real maxvar,minvar
      integer i,j,k

#ifdef CM5
      maxvar = maxval(var)
      minvar = minval(var)
#else
      maxvar=var(1,1,1)
      minvar=var(1,1,1)
      do k=1,nz
         do j=1,ny
            do i=1,nx
               if (var(i,j,k).gt.maxvar) then
                  maxvar = var(i,j,k)
               endif
               if (var(i,j,k).lt.minvar) then
                  minvar = var(i,j,k)
               endif
            end do
         end do
      end do
#endif
      
      write (*,883) iter,time,minvar,maxvar
 883  format (2x,i6,2x,f7.3,2x,f12.8,2x,f12.8)

      return
      end
*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

*==============================================================================
*  [ROUTINE NAME] Info_header 
*  [AUTHOR] Joan Masso, NCSA & UIB
*  [PURPOSE] Display a header for the Information routine output
*  [ARGUMENTS]
*     [INPUT]  varname : the name of the variable
*  [CALLED BY]  H3   
*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
      subroutine Info_header(varname)
      character*8 varname
      write(*,884) ' Iter.','  Time', 'min ',varname,'max ',varname
      write(*,884) '======','=======', '====','========', '====','========'
 884  format (2x,a6,2x,a7,2x,a4,a8,2x,a4,a8)
      return
      end
*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>



*==============================================================================
*  [ROUTINE NAME] time_start 
*  [AUTHOR] Joan Masso, NCSA & UIB
*  [PURPOSE] Start the timer 
*  [CALLED BY]  Init_H3   
*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
      subroutine time_start
#ifdef CM5
#include '/usr/include/cm/timer-fort.h'
      call cm_timer_start(0)
#endif
      return
      end
*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


*==============================================================================
*  [ROUTINE NAME] time_stop
*  [AUTHOR] Joan Masso, NCSA & UIB
*  [PURPOSE] Stop the timer and put the elapsed cpu time in argument cpu
*  [CALLED BY]  Init_H3   
*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
      subroutine time_stop(cpu)
      real cpu
#ifdef CM5
#include '/usr/include/cm/timer-fort.h'
#endif
c     Initialize to something... just in case none of the cpp macros
c     has been defined.
      cpu = 999999.99
#ifdef CM5
      call cm_timer_stop(0)
      call cm_timer_print(0)
      cpu= cm_timer_read_cm_busy(0)
#endif
#ifdef CRAY
      call second(cpu)
#endif
      return
      end
*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


*==============================================================================
*  [ROUTINE NAME] time_show
*  [AUTHOR] Joan Masso, NCSA & UIB
*  [PURPOSE] Show some statistics based on the cpu time and the spacetime grid
*  [CALLED BY]  Init_H3   
*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
      subroutine time_show(cpu,iterations,nx,ny,nz)
      real cpu
      integer iterations,nx,ny,nz

      write(*,996) 
      write(*,998) ' Execution time:', cpu,' secs'
      write(*,998) ' ',cpu/(iterations+1),' secs per timestep'
      write(*,998) ' ',(iterations+1)/cpu,' timesteps per second'
      write(*,999) ' ',nx*ny*nz,' grid points'
      write(*,998) ' ',cpu/(iterations+1)/nx/ny/nz*1.e6,
     .     ' microsecs/timestep/grid point '
      write(*,997) ' ',nx*ny*nz*(iterations+1.)/(cpu*1.e3),
     .     'e3 zone-cycles/sec'
 996  format (x,75('-'))
 997  format (x,A25,F8.1,A)
 998  format (x,A25,F10.3,A)
 999  format (x,A21,i10,4x,A)
      write(*,996) 
      return
      end
*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


*==============================================================================
*  [ROUTINE NAME] Welcome
*  [AUTHOR] Joan Masso, NCSA & UIB
*  [PURPOSE] Just that...
*  [CALLED BY]  Init_H3   
*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
      subroutine Welcome
      write(*,*) '  ____________________________________________________ '
      write(*,*) ' |                                                    |'
      write(*,*) ' |                     H3expresso                     |'
      write(*,*) ' |____________________________________________________|'
      write(*,*) ' |                                                    |'
      write(*,*) ' |   Simplified version of H3.3: A harmonic code for  |'
      write(*,*) ' |   solving the full Einstein Equations casted as a  |'
      write(*,*) ' |   First Order Flux Conservative Hyperbolic system  |'
      write(*,*) ' |   using Advanced Numerical Methods on a cartesian  |'
      write(*,*) ' |   3d grid.                                         |'
      write(*,*) ' |                              (c) Joan Masso. 1995  |'
      write(*,*) ' |                              jmasso@ncsa.uiuc.edu  |'
      write(*,*) ' |____________________________________________________|'
      write(*,*) ' '
      return
      end
*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


*==============================================================================
*  [ROUTINE NAME] Goodbye
*  [AUTHOR] Joan Masso, NCSA & UIB  
*           (should I claim copyright? I could sue Microsoft...)
*  [PURPOSE] Just that...
*  [CALLED BY]  Init_H3   
*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
      subroutine Goodbye
      write(*,*) 'Bye.'
      return
      end
*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>



