//=========================================================//
//                      DEMO_UBEAM                         //
//=========================================================//


//---------------------------------------------------------//
// 1. Loads                                                //
// See section 3.2.2 of the tutorial                       //
//---------------------------------------------------------//

// Volume forces
fegui();
model = femesh('test ubeam');
data  = struct('sel','GroupAll','dir',[1 0 0]);
model = fe_case(model,'AddToCase 1','FVol','Volume load',data);
Load  = fe_load(model,'case1');
feplot(model,Load);

// Surfacic forces
clear model data Load
model = femesh('testubeam');
data=struct('sel','x==-.5', ... 
   'eltsel','withnode {z>1.25}','def',1,'DOF',.19);
Case1=struct('Stack',makecell([1 1],makecell([1 3],'Fsurf','Surface load',data)));
Load = fe_load(model,Case1); 
feplot(model,Load);

// 2 loads
clear model data Load
model = femesh('test ubeam');
data  = struct('DOF',[207.01;241.01;207.03],'def',[1 0;-1 0;0 1]);
model = fe_case(model,'AddToCase 1','DOFLoad','Point load 1',data);
data  = struct('DOF',365.03,'def',1);
model = fe_case(model,'AddToCase 1','DOFLoad','Point load 2',data);
Load  = fe_load(model,'Case1');
feplot(model,Load);

Load.def=sum(Load.def,2);
medit('write visu/ubeam',model,Load,'a',[1 10 0.7]); 
// medit : increase the number of images (here 10) if the animation isn't smooth.
// if this demo doesn't work, verify the existence of the subdirectory visu and try to decrease 
// the number of images created by medit (here 10).