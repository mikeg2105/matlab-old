Differential Evolution for Scilab

Modified by Helmut Jarausch <jarausch@igpm.rwth-aachen.de> 2006/03/01

Installation:

0) prepare your cost function

   function  v = my_cost(x,USERDATA)

   where x are the independent variables and
   USERDATA is passed transparently by DiffEvol
   Constraints can be incorparated by an L1-penalty term
   see the example DiffEvolT2.sce for more details

1) load the functions (DiffEvol.sci and your my_cost.sci) with getf

2) modify one of the script files  (DiffEvolT.sce, DiffEvolT2.sce,
   run1.sce or run2.sce)
   If the optimal value of the cost function is known (like in a 
   constraint satisfaction problem (DiffEvol.sci)) set the parameter
   VTR to a value slightly larger than that to terminate the iteration.
   Otherwise select the parameter 'itermax' carefully.
   Possibly do a 'restart' like in DiffEvolT2.sce

3) execute it using the command exec


___ previous readme ___

16.03.1999

Conversion by Walter Di Carlo
Please for any comment send me an email <walter.dicarlo@jrc.it>

Notes and authors of the source code are listed in the corresponding files.


Installation:

0) modify the cost function rosen
1) load all functions (randperm, rosen, devec3) with getf
2) modify one of the executable (run1, run2)
3) execute it using the command exec
