function [plotmodel]=plotmodel()

	in(1)=10  //p
  in(2)=160   //r
  in(3)=2.66667    //b
  in(4)=0  //x
  in(5)=1    //y
  in(6)=0    //z
 

	sirout=lorenz(2000,10,0.001, in);
	t=(1:1:2000);
	X=[sirout(4, :);sirout(4, :);sirout(4, :)];
	Y=[sirout(1, :);sirout(2, :);sirout(3, :)];
	plot2d(X',Y',style=[-1 -2 -3]',leg="x@y@y")
	plotmodel=sirout

endfunction
