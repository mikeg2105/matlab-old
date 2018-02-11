//
//  Test2 de la doc Modulef
//  web('http://www-rocq.inria.fr/modulef/Doc/GB/Guide1-14/node19.html')
fegui();

// geometrie importee test.nopo maillage 2d

model=nopo('read -p 2d T2');

// proprietes E=10^5 nu=.3

model.pl=[1 fe_mat('m_elastic',1,1) 1.e5 .3 .1];

//  conditions aux limites

model = fe_case(model,'fixdof','uy','GID 1 -DOF 2');

// No normal displacement on Set 1
n1=feutil('getnode inelt{set3}',model);
map=struct('normal',[n1(:,5) n1(:,6)*[1 0]],'ID',n1(:,1));
map.normal=map.normal./(sqrt(sum(map.normal.^2,2))*[1 1 1])

model=fe_case(model,'un=0','Normal motion',map);

//   7 pour load!
ref7=find(model.Node (:,4)==7);

// Second membre utilise ref7!

data=struct('DOF',ref7+.01,'def',-100);
model=fe_case(model,'DOFload','fponct',data);
force = fe_load(model);

// Matrice 

[Case,tmp]=fe_mknl('init',model); model.DOF = tmp;
k=fe_mknl('assemble',model,Case,1);

// Calcul de reponse statique
kd=ofact(k);
def=struct('def',Case.T*(kd\force.def),'DOF',model.DOF);
ofact('clear',kd)

//---------------------------------------------------------//
// 7. Visualization of deformed structure                  //
//
//---------------------------------------------------------//
if sp_util('issdt');  feplot(model,def);
else; medit('write visu/def',model,def);
end