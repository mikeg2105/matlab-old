
exec('diffuse_utils.sce');

exec('diffuse.sce');
exec('diffuse_drv.sce');
mkdir('results2');
mkdir('tmp');
//exec('diffuse_analysis.sce');
directory=sprintf('results2');
chdir(directory);

  nsteps=100;
  n1=20;
  n2=20;
  n3=1;

	in(1)=5;  //d
  in(2)=n1;   //n1
  in(3)=n2;    //n2
  in(4)=n3;  //n3
  in(5)=0.05;    //h
  
  //For each species
  //create
  //1. Initial concentration
  //2. Sources
  //3. Sinkss
  //4. species
  //concsin=rand(n1,n2,n3);
  concsin=zeros(n1,n2,n3);
  concsin(5,5,1)=0.6;
  sources=zeros(n1,n2,n3);
  sources(n1/2,n2/2,1)=rand();
  sources(1,1,1)=0.1;
  sinks=zeros(n1,n2,n3);
  sinks(n1,n2,n3)=0.1;
  //read initial configuration from an old one
  jobname=sprintf('difruneasa2');
  
	sirout=mydiffuse(jobname,nsteps,1,0.0001, in,concsin,sources,sinks);
	gendxgen(directory,jobname,nsteps,n1,n2,n3);
	//t=(1:1:2000);
	//X=[sirout(4, :);sirout(4, :);sirout(4, :)];
	//Y=[sirout(1, :);sirout(2, :);sirout(3, :)];
	//plot2d(X',Y',style=[-1 -2 -3]',leg="x@y@y")
	//plotmodel=sirout
	
	exit;
