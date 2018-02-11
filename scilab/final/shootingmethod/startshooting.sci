//  THIS PROVIDES A SOLUTION FOR A BOUNDARY-VALUE PROBLEM FOR A
// FIRST-ORDER ODE WITH ONE UNKNOWN PARAMETER TO BE DETERMINED.
//  THE ODE IS OF THE FORM     Dy/Dx = f(x,Q)  WHERE Q IS THE 
//  UNKNOWN PARAMETER.   THE BOUNDARY CONDITIONS ARE y = Ya FOR
//  x = a AND y = Yb FOR X = b.   
//  THE FUNCTION f(x,Q) IS PROVIDED AS A myfunc1(q,x) in SCILAB 
//  FILE myfunc.sci.

exec('myfunc.sci');
      y(1:1000)=zeros(1000);
      w(1:4)=zeros(4);
      dy(1:4)=zeros(4);
      dat.d1=0;
      dat.d2=0.5;
      dat.d3=0.5;
      dat.d4=1.0;
      //REAL Y(0:1000),W(4),DY(4)
      //CHARACTER ANS*1
      //DATA W/0.0,0.5,0.5,1.0/
      //FUN(X,Q)=-15.915494*Q/(2-X)**2
      //INPUT THE FIRST BOUNDARY CONDITION AS a,Ya
      xi=0;
      y(1)=500;
 
      //INPUT THE FINAL BOUNDARY CONDITION AS b,Yb
      //WHERE y = Yb WHEN x = b.'')')
      xf=1.0;
      yf=300.0;
          
      //INPUT THE INTEGRATION STEP LENGTH h IN THE 
      //FORM OF AN INTEGER N WHERE h = [b - a]/N.
      //IF YOU WANT OUTPUT OF Y AT INTERVALS OF [B-A]/M
      //THEN MAKE N A MULTIPLE OF M.
      n=1000;
      h=(xf-xi)/n;      
      
      //INPUT ESTIMATE OF THE UNKNOWN PARAMETER, Q.
      q=30.0;  //too high
      q=20;   //too low
      
      //q=25.1325;
      
      
      //THE RUNGE-KUTTA INTEGRATION NOW BEGINS.F
      for i=2:n
       x=(i-1)*h;
          for j=1:4
              xx=x+w(j).*h;
              dy(j)=h*myfunc1(xx,q);
          end
       y(i)=y(i-1)+(dy(1)+dy(4)+2*(dy(2)+dy(3)))/6.0;
      end
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      