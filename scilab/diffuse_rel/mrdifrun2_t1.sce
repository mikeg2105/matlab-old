jobname='mrdifrun2_2';
exec("../mrdifrun1/diffuse/diffuse_utils.sce");
exec("../mrdifrun1/diffuse/mymultireactdiffuse.sce");
exec("../mrdifrun1/diffuse/newtempmultireactconc.sce");
exec("../mrdifrun1/diffuse/mconcupdate.sce");
exec("../mrdifrun1/diffuse/getconcsub.sce");
exec("../mrdifrun1/diffuse/lap3d.sce");
exec("../mrdifrun1/diffuse/cmdott.sce");
exec("../mrdifrun1/diffuse/compfunc.sce");
dt=0.002000;
h=0.100000;
ralpha=.2000;
rbeta=.100000;

dif(1)=0.500000;
dif(2)=0.60000;
dif(3)=0.800000;
inconsts(1)=ralpha;
inconsts(2)=rbeta;

rootdirectory='/scratch/cs1mkg/results/diffuse_rel';
 nspec=3; nsteps=10;nsubsteps=1;n1=20;n2=20;n3=1;
 in(1)=n1; in(2)=n2; in(3)=n3;in(4)=h; in(5)=nspec;
concsin=zeros(n1,n2,n3,nspec); concsin(10,8,1,1)=1; concsin(10,12,1,2)=1;sources=zeros(n1,n2,n3,nspec);sinks=zeros(n1,n2,n3,nspec);
sirout=mymultireactdiffuse(rootdirectory,jobname,nsteps, nsubsteps, dt, dif, in, concsin, sources, sinks,inconsts);
mgendxgen(rootdirectory,jobname,nsteps,n1,n2,n3,nspec);
//exit;
