easybridge 

Calculation for matlab/scilab
M.Griffiths 10/06/2005


Bridge is specified by a number of horizontal
sections.

Each layer has a top and bottom row of struts
some of these struts may be shared by adjacent 
layers.

The number of points specified in the program
is always the number of strut intesection points
in the bottom layer.

The inclination of struts connecting adjacent layers
is specified by angles alpha1 and alpha2.

Each point in the bridge structure has a unique identifier.
Numbering starts from 1 at bottom left hand corner
and goes incrementally from left to right.

A sample input file specifying the input load (i.e. externally
applied forces) is provided and called loadfile.dat

All parameters and input filename are specified in the
sample matlab/scilab script easybridge.m

See the diagram bridgediagram.jpg for a clear
illustration of this layout.
