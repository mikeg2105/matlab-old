
exec('diffuse_utils.sce');

exec('diffuse.sce');
exec('diffuse_multi.sce');
exec('diffuse_drv.sce');
mkdir('results2');
mkdir('tmp');
//exec('diffuse_analysis.sce');
directory=sprintf('resultsm1');
chdir(directory);
  nspec=2;
  nsteps=100;
  nsubsteps=1;
  dt=0.0001;
  n1=20;
  n2=20;
  n3=1;

	//in(1)=5;  //d
  in(1)=n1;   //n1
  in(2)=n2;    //n2
  in(3)=n3;  //n3
  in(4)=0.05;    //h
  in(5)=nspec;
  dif=ones(2,1);
  dif(1,1)=0.5;
  //For each species
  //create
  //1. Initial concentration
  //2. Sources
  //3. Sinkss
  //4. species
  //concsin=rand(n1,n2,n3);
  inconsts=ones(nspec,nspec);
     concsin=zeros(n1,n2,n3,nspec);
     //concsin( :, :, :,1)=ones(n1,n2,n3);
     //concsin( :, :, :,2)=ones(n1,n2,n3)/2;
     //a=concsin( :, :, :,1)
     //b=concsin( :, :, :,2)
    sources=zeros(n1,n2,n3,nspec);
    sinks=zeros(n1,n2,n3,nspec);
  
    concsin(5,5,1,1)=3;
    concsin(15,15,1,2)=1.5;
  
  //sources(n1/2,n2/2,1,1)=0.5;
  //sources(5,5,1,2)=0.5;
  
  //sinks(n1,n2,n3,2)=0.1;
  //read initial configuration from an old one
  jobname=sprintf('mdifruneasa1');
  sirout=mymultidiffuse(jobname,nsteps, nsubsteps, dt, dif, in, concsin, sources, sinks,inconsts);
	//sirout=mydiffuse(jobname,nsteps,1,0.0001, in,concsin,sources,sinks);
	mgendxgen(directory,jobname,nsteps,n1,n2,n3,nspec);
	//t=(1:1:2000);
	//X=[sirout(4, :);sirout(4, :);sirout(4, :)];
	//Y=[sirout(1, :);sirout(2, :);sirout(3, :)];
	//plot2d(X',Y',style=[-1 -2 -3]',leg="x@y@y")
	//plotmodel=sirout
	
	//exit;
