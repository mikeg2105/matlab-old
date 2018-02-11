// this example illustrates the use of the FEMESH preprocessor to build a
// solid model of a U-beam, compute the associated modes, and display strain
// energy levels

FEnode=[1 0 0 0  -.5 -.5 0;2  0 0 0  -.5+1/6 -.5 0;3 0 0 0  -.5 .5-1/6 0
        4 0 0 0  -.5+1/6 .5-1/6 0;5 0 0 0  -.5 .5 0;6 0 0 0 -.5+1/6 .5 0
        7 0 0 0 .5-1/6 .5 0;8 0 0 0 .5 .5 0;9 0 0 0 .5-1/6 .5-1/6 0
        10 0 0 0 .5 .5-1/6 0;11 0 0 0 .5-1/6 -.5 0;12 0 0 0 .5 -.5 0];

FEelt=[%inf ascii('quad4');4 6 5 3 1 1;9 10 8 7 1 1];
FEel0=[%inf ascii('quad4');1 2 4 3 1 1];
femesh(';divide 5 1;addsel;');
FEel0=[%inf ascii('quad4');11 12 10 9 1 1];
femesh(';divide 5 1;addsel;');
FEel0=[%inf ascii('quad4');4 6 7 9 1 1];
femesh(';divide 4 1;addsel;');
femesh('join group 1:4');
femesh(';selgroup1;extrude 10 0 0 .25;orientel0');

// This section is to impose a cantilevered boundary condition
pl = [1 1 2e11 .30 7800 (190e9/2/(1+.29))];
mdof = femesh('finddof group1',FEel0);
i1 = femesh('findnode z==0');
[mdof] = fe_c(mdof,i1,'dof',2);

// This section is to assemble, compute modes and show the result
[m,k,mdof] = fe_mk(FEnode,FEel0,pl,[],[],mdof,[0 1]);
[md1,f1] = fe_eig(m,k,[1 10 0 11]);
StrainEnergy = fe_stres('ener',FEnode,FEel0,pl,[],md1,mdof);
feplot(FEnode,FEel0,md1,mdof,[],StrainEnergy);


// Now we will apply a load on the edge

model=struct('Node',FEnode,'Elt',FEel0,'pl',pl,'il',[],'DOF',mdof);

data=struct('sel','x==-.5', ... 
    'eltsel','withnode {z>1.25}','def',1,'DOF',.19);
Case1=struct('Stack',makecell([1 1],makecell([1 3],'Fsurf','Surface load',data)));

// view load
Load = fe_load(model,Case1); 
feplot(FEnode,FEel0,Load.def,Load.DOF,2);

// view response
def = k\Load.def;
Stress = fe_stres('stress mises',FEnode,FEel0,pl,[],def,mdof);
feplot(FEnode,FEel0,def,mdof,1,Stress);

//       Etienne Balmes
//       Copyright (c) 1996-2002 by SDTools
//       All Rights Reserved.

