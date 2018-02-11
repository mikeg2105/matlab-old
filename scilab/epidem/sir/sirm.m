

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

function [sirm]=sirm(nsteps, dt, in)

  //population initial values
  s0=in(1)
  i0=in(2)
  r0=in(3)
  c0=in(4)
 t0=in(5)
  
  betaics=in(6)
  betasc=in(7)
  betais=in(8)
 betaic=in(9)
  beta1=in(10)
  bc=in(11)
  bs=in(12)
  iav=in(13)
  inf=in(14)
  car=in(15)
  cav=in(16)
  d=in(17)
  g=in(18)
  
 
  
  t=t0
  
  smat=zeros(5,nsteps)
	total=c0+r0+s0+i0
	for ii=1:1000
	      //for kk=1:1000
	      t=t0+dt
	      //susceptible 
				jj=1
				s=ode(s0,t0,t,list(sdotr,betaics,betasc,betais,betaic, beta1,bc,bs,iav,inf,car,cav,d))
				
				//infected
				jj=2
				inf=ode(i0,t0,t,list(idotr,betaics, betasc, betais, betaic,beta1,s,iav,car,cav,g,d))
				
				//recovered
				jj=3
				
				rec=ode(r0,t0,t,list(rdotr,g,inf,d))
				//rec=smat(jj,ii)
				
				//carriers
				jj=4
		  		car=ode(c0,t0,t,list(cdot,betaics, betasc, betais, betaic, beta1,bc,bs ,iav,inf,s,cav,d))
		  			
	  			//smat(5, ii)=total
	  			
	  			c0=car
	  			r0=rec
	  			s0=s
	  			i0=inf
	  			
	  			t0=t
	  			//end
	  			
	end
	total=c0+r0+s0+i0
	for ii=1:nsteps
	      //for kk=1:1000
	      t=t0+dt
	      //susceptible 
				jj=1
				smat(jj,ii)=ode(s0,t0,t,list(sdotr,betaics,betasc,betais,betaic, beta1,bc,bs,iav,inf,car,cav,d))
				s=smat(jj,ii)
				//infected
				jj=2
				smat(jj,ii)=ode(i0,t0,t,list(idotr,betaics, betasc, betais, betaic,beta1,s,iav,car,cav,g,d))
				inf=smat(jj,ii)
				//recovered
				jj=3
				
				smat(jj,ii)=ode(r0,t0,t,list(rdotr,g,inf,d))
				rec=smat(jj,ii)
				
				//carriers
				jj=4
		  		smat(jj,ii)=ode(c0,t0,t,list(cdot,betaics, betasc, betais, betaic, beta1,bc,bs ,iav,inf,s,cav,d))
	  			car=smat(jj,ii)
	  			
	  			smat(5, ii)=total
	  			
	  			c0=smat(4,ii)
	  			r0=smat(3,ii)
	  			s0=smat(1,ii)
	  			i0=smat(2,ii)
	  			total=c0+r0+s0+i0
	  			t0=t
	  			//end
	  			
	end	
	
  sirm=smat
 
endfunction


//sir equations for epidemiology
//s=susceptible population
//i=infected population
//r=recovered population


//constants
//betasc contact rate susceptible carrier
//betais contact rate infected susceptible
//beteaic contact rate infected carrier
//betaics contact rate carrier infecting susceptible
//b    birth rate
//d    death rate

//R0   = beta/g


//The contact parameters for infection and carrying
//are assumed to vary according to the same rate
//according to the follwoing reference
//beta(t)=beta(0)(1+beta1*cos(2*pi*t))
//Although different contacts may have different contact values
//it is assumed that they will have the sam etime dependence
//thus there is a single beta1 parameter

//Ref Differential Systems in ecology and epidemiology
//W.M.Schaffer and M.Kot
//in
//Chaos
//ed. A.V.Holden
//Published Manchester University Press 1986
//See also
//Aron, J.L. and Schwartz, I.B. "Seasonality and period-doubling bifurcations i an epidemic model"
//J.Theor.Biol. 110, 665-80 (1984)
//
//
//Grossman, Z. "Oscillatory phenomena in a model for infectious disease"
//J.Theor.Biol. 18, 204-43 (1980)


//to use the following function with the
//ode solver
//-->y=ode(y0,t0,t,list(f,0.03))

//-->s=ode(s0,t0,t,list(sdotr,betaics,betasc,betais,betaic, beta1,bc,bs,iav,inf,car,cav,d))
function [sdotr]=sdotr(t,s,betaics, betasc, betais, betaic, beta1,bc,bs ,iav,i,c,cav,d)


 
	//bs=b(2)
	//betaics=beta(1)
	//betasc=beta(2)
	//betais=beta(3)
	//betaic=beta(4)
	
	sdotr=bs-betais*(1+beta1*cos(2*%pi*t))*s*(i+iav)-betasc*(1+beta1*cos(2*%pi*t))*s*(c+cav)-(d*s)
endfunction

//-->i=ode(i0,t0,t,list(idotr,betaics, betasc, betais, betaic, beta1,s,iav,c,cav,g,d))
function [idotr]=idotr(t,i,betaics,betasc,betais,betaic,beta1,s,iav,c,cav,g,d)

  //betaics=beta(1)
	//betasc=beta(2)
	//betais=beta(3)
	//betaic=beta(4)

	idotr=betais*(1+beta1*cos(2*%pi*t))*s*(i+iav)+betaic*(1+beta1*cos(2*%pi*t))*c*(i+iav)+betaics*(1+beta1*cos(2*%pi*t))*s*(c+cav)-(g*i)-(d*i)
endfunction

//-->
function [rdotr]=rdotr(t,r,g,i,d)

	rdotr=g*i-d*r
endfunction

//-->
//rate of change of carriers
function [cdotr]=cdot(t,c,betaics, betasc, betais, betaic, beta1,bc,bs ,iav,i,s,cav,d)
	cdotr=bc*c+(betasc-betaics)*(1+beta1*cos(2*%pi*t))*s*(c+cav)-betaic*(1+beta1*cos(2*%pi*t))*c*(i+iav)-(d*c)
endfunction

function [slinapp]=slinapp(t,betaics, betasc, betais, betaic, beta1,bc,bs ,iav,i,c,cav,d)
   slinapp=bs-betais*(1+beta1*cos(2*%pi*t))*s*(i+iav)-betasc*(1+beta1*cos(2*%pi*t))*s*(c+cav)-(d*s)
endfunction



