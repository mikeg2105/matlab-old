
	%in(1)=10  %p
    %in(2)=160   %r
    %in(3)=2.66667    %b
    %in(4)=0  %x
    %in(5)=1    %y
    %in(6)=0    %z
 

	%sirout=lorenz(400,5,0.01, in);
    sirout=load('-ascii','rlorenzout.mat');
	%t=(1:1:400);
	%X=[sirout(4, :);sirout(4, :);sirout(4, :)];
	%Y=[sirout(1, :);sirout(2, :);sirout(3, :)];
    plot(sirout(4, :), sirout(1, :),  sirout(4, :), sirout(2, :), sirout(4, :), sirout(3, :));
	%plot2d(X',Y',style=[-1 -2 -3]',leg="x@y@y")
	

