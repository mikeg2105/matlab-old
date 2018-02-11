//=========================================================//
//                      DEMO_STATIC                        //
//=========================================================//


fegui();
//---------------------------------------------------------//
// 1. Geometry declaration with femesh                     //
// See section 3.1.2 of the tutorial                       //
//---------------------------------------------------------//
FEnode=[1 0 0 0  -.5 -.5 0;2  0 0 0  -.5+1/6 -.5 0;3 0 0 0  -.5 .5-1/6 0
        4 0 0 0  -.5+1/6 .5-1/6 0;5 0 0 0  -.5 .5 0;6 0 0 0 -.5+1/6 .5 0
        7 0 0 0 .5-1/6 .5 0;8 0 0 0 .5 .5 0;9 0 0 0 .5-1/6 .5-1/6 0
        10 0 0 0 .5 .5-1/6 0;11 0 0 0 .5-1/6 -.5 0;12 0 0 0 .5 -.5 0];
FEelt = [%inf abs('quad4');4 6 5 3 1 1;9 10 8 7 1 1];
FEel0 = [%inf abs('quad4');1 2 4 3 1 1];
femesh(';divide 5 1;addsel;');
FEel0 = [%inf abs('quad4');11 12 10 9 1 1];
femesh(';divide 5 1;addsel;');
FEel0 = [%inf abs('quad4');4 6 7 9 1 1];
femesh(';divide 4 1;addsel;');
femesh('join group 1:4');
femesh(';selgroup1;extrude 10 0 0 .25;');
FEelt = FEel0; FEel0 = [];
FEelt(2:size(FEelt,1),1:8)=FEelt(2:size(FEelt,1),[5:8 1:4]);
model = femesh('model');


//---------------------------------------------------------//
// 2. Handling material properties                         //
// See section 3.1.4 of the tutorial                       //
//---------------------------------------------------------//
model.pl = [1 1 2e11 .30 7800 (190e9/2/(1+.29))];


//---------------------------------------------------------//
// 3. Boundary conditions and constraints                  //
// See section 3.2.1 of the tutorial                       //
//---------------------------------------------------------//
model = fe_case(model,'fixdof','base','z==0');


//---------------------------------------------------------//
// 4. Assembly                                             //
// See section 3.3.1 of the tutorial                       //
//---------------------------------------------------------//
model = fe_mk(model);
model.DOF = model.Stack(3).entries.DOF;


//---------------------------------------------------------//
// 5. Loads                                                //
// See section 3.2.2 of the tutorial                       //
//---------------------------------------------------------//
data=struct('sel','x==-.5', ... 
   'eltsel','withnode {z>1.25}','def',1,'DOF',.19);
Case1=struct('Stack',makecell([1 1],makecell([1 3],'Fsurf','Surface load',data)));
Load = fe_load(model,Case1); 


//---------------------------------------------------------//
// 6. Static response                                      //
// See section 3.3.2 of the tutorial                       //
//---------------------------------------------------------//
def = struct('def',[],'DOF',model.DOF);
kd = ofact(model.K(2).entries); // use the factor object for large matrices
def.def = kd\Load.def;
ofact('clear',kd);  // Clear the factor when done
Stress = fe_stres('stress mises',model,def);


//---------------------------------------------------------//
// 7. Visualization of deformed structure                  //
// See section 3.4 of the tutorial                         //
//---------------------------------------------------------//
medit('write visu/def',model,def,Stress,[1 1e8]);
