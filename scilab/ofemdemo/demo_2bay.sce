//=========================================================//
//                      DEMO_2BAY                          //
//=========================================================//


//---------------------------------------------------------//
// 1. Boundary conditions and constraints                  //
// See section 3.2.1 of the tutorial                       //
//---------------------------------------------------------//
model=femesh('test 2bay');
mdof = feutil('getdof group1:2',model);
i1 = femesh('findnode x==0');
adof1 = fe_c(mdof,i1,'dof',1);             // clamp edge
adof2 = fe_c(mdof,[.01 .02 .06]','dof',2); // 2-D motion
adof = [adof1;adof2];
model=fe_case(model,'SetCase1', ...        // defines a new case
    'FixDof','fixed DOF list',adof);     

//---------------------------------------------------------//
// 2. Assembly                                             //
// See section 3.3.1 of the tutorial                       //
//---------------------------------------------------------//
model = fe_mk(model);

model2 = femesh('test 2bay');
model2 = fe_mk(model2,'FixDof','2-D motion',[.03 .04 .05],'FixDof','clamp edge',[1 2]);

[m,k,mdof] = fe_mk(model2,'FixDof','2-D motion',[.03 .04 .05],'FixDof','clamp edge',[1 2]);
max(abs(m-model2.K(1).entries))
max(abs(k-model2.K(2).entries))