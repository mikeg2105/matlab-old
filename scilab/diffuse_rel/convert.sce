jobname='mrdifrun2_4';
exec("../mrdifrun1/diffuse/diffuse_utils.sce");
exec("../mrdifrun1/diffuse/mymultireactdiffuse.sce");
exec("../mrdifrun1/diffuse/newtempmultireactconc.sce");
exec("../mrdifrun1/diffuse/mconcupdate.sce");
exec("../mrdifrun1/diffuse/getconcsub.sce");
exec("../mrdifrun1/diffuse/lap3d.sce");
exec("../mrdifrun1/diffuse/cmdott.sce");
exec("../mrdifrun1/diffuse/compfunc.sce");
stacksize(64000000);
dt=0.002000;
h=0.100000;
ralpha=80.8000;
rbeta=.400000;

dif(1)=0.400000;
dif(2)=0.010000;
dif(3)=0.600000;
inconsts(1)=ralpha;
inconsts(2)=rbeta;

rootdirectory='/scratch/cs1mkg/results/diffuse_rel';
 nspec=3; nsteps=100;nsubsteps=1;n1=20;n2=20;n3=1;
 in(1)=n1; in(2)=n2; in(3)=n3;in(4)=h; in(5)=nspec;
//concsin=0.05*ones(n1,n2,n3,nspec); 
//concsin(10,10,1,3)=0.00000001;concsin(14,14,1,1)=0.00000001; concsin(8,8,1,2)=0.000000001;
//sources=zeros(n1,n2,n3,nspec);sinks=zeros(n1,n2,n3,nspec);
allconcs=difreadmat(rootdirectory+'/'+jobname+'.dat');

for i=1:nsteps
  concs=matrix(allconcs(i,:,:,:,:),n1,n2,n3,nspec);
  savemconcs(rootdirectory,jobname+'mod',i,n1,n2,n3,nspec,concs);
end

mgendxgenmod(rootdirectory,jobname+'mod',nsteps,n1,n2,n3,nspec);

//exit;
