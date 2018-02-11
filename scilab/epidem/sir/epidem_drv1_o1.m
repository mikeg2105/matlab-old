
//solve sirm equations for a range of values 
//otput the results in a matrix
//called using sirout=sirm(50,0.05);
//input parameters
	//s0=500
  //i0=5
  //r0=1
  //c0=20
  //t0=0
  
  //betaics=0.5
  //betasc=0.9
  //betais=0.2
  //betaic=0.5
  //beta1=0.4
  //bc=0.8
  //bs=0.8
  //iav=0
  //inf=0.3
  //car=0.4
  //cav=0
  //d=0.9
  //g=50 


  
function plotmodel()

		in(1)=500
  in(2)=50
  in(3)=1
  in(4)=20
  in(5)=0
  
  in(6)=4
  in(7)=4
  in(8)=7
  in(9)=0.5
  in(10)=3.5
  in(11)=12
  in(12)=6
  in(13)=0
  in(14)=5
  in(15)=7
  in(16)=0
  in(17)=4.0
  in(18)=5

	sirout=sirm(2000,0.00005, in);
	t=(1:1:2000);
	X=[t;t;t;t;t];
	Y=[sirout(1, :);sirout(2, :);sirout(3, :);sirout(4, :);sirout(5, :)];
	plot2d(X',Y',style=[-1 -2 -3 -4 -5]',leg="susceptible@infected@recovered@carriers@total")

endfunction

function mplotmodel()

		in(1)=500
  in(2)=50
  in(3)=1
  in(4)=20
  in(5)=0
  
  in(6)=4
  in(7)=4
  in(8)=7
  in(9)=0.5
  in(10)=3.5
  in(11)=12
  in(12)=6
  in(13)=0
  in(14)=5
  in(15)=7
  in(16)=0
  in(17)=4.0
  in(18)=5
  //Cycle through each variable and vary in turn
  ns=50
  t=(1:1:ns);
  
	x1=(1:1:ns);
	x2=(1:1:ns);
	
	
  //Y=zeros(1,ns);
  //driver('GIF');
  driver('Rec');
  ii=10
      //sfile='temp'+string(ii)+'.gif'
      //sfile='gfile'
      //sfile=sfile+string(ii)
      //sfile=sfile+'.gif'
      //xinit(sfile)
      Y=zeros(1,ns);
      inold=in(ii)
      resm1=zeros(ns,ns)
      resm2=zeros(ns,ns)
      resm3=zeros(ns,ns)
      resm4=zeros(ns,ns)
      for jj=1:ns
         in(ii)=in(ii)+0.2
         y(jj)=in(ii);
				sirout=sirm(ns,0.00005, in);
				sirdout=sirout'
				for kk=1:ns
					resm1( kk , jj )= sirdout( kk , 1 )
					resm1( kk , jj )= sirdout( kk , 2 )
					resm1( kk , jj )= sirdout( kk , 3 )
					resm1( kk , jj )= sirdout( kk , 4 )
				end
				//fill
				
			end
			subplot(2,2,1);
			plot3d(x1,x2,resm1);
			subplot(2,2,2);
			plot3d(x1,x2,resm2);
			subplot(2,2,3);
			plot3d(x1,x2,resm3);
			subplot(2,2,4);
			plot3d(x1,x2,resm4);
			//resm
			in(ii)=inold;
			//xend()
			
	//end

endfunction

//Case 1 interesting 25/11/04
function case1plotmodel()

		in(1)=500
  in(2)=50
  in(3)=1
  in(4)=20
  in(5)=0
  
  in(6)=4
  in(7)=4
  in(8)=7
  in(9)=0.5
  in(10)=3.5
  in(11)=12
  in(12)=6
  in(13)=0
  in(14)=5
  in(15)=7
  in(16)=0
  in(17)=4.0
  in(18)=5

	sirout=sirm(2000,0.00005, in);
	t=(1:1:2000);
	X=[t;t;t;t;t];
	Y=[sirout(1, :);sirout(2, :);sirout(3, :);sirout(4, :);sirout(5, :)];
	plot2d(X',Y',style=[-1 -2 -3 -4 -5]',leg="susceptible@infected@recovered@carriers@total")

endfunction
