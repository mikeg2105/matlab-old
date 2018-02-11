//=========================================================//
//                       DEMO_FE                           //
//=========================================================//


//---------------------------------------------------------//
// 1. Geometry declaration with femesh                     //
// See section 3.1.2 of the tutorial                       //
//---------------------------------------------------------//
clear model FEnode FEelt FEel0
fegui(); 

FEnode=[1 0 0 0  0 0 0;2 0 0 0    0 1 0;
        3 0 0 0  1 0 0;4 0 0 0    1 1 0];
femesh('objectbeamline 1 3 0 2 4 0 3 4 0 1 4')

femesh(';addsel;transsel 1 0 0;addsel;info');
// export FEnode and FEelt geometry in model
model=femesh('model');  
