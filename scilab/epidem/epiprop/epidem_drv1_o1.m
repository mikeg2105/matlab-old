//sir equations for epidemiology
//s=susceptible population
//i=infected population
//r=recovered population


//constants
//beta contact rate
//b    birth rate
//d    death rate

//R0   = beta/g



//to use the following function with the
//ode solver
//-->y=ode(y0,t0,t,list(f,0.03))

//-->s=ode(s0,t0,t,list(sdot,b,beta,sav,i,d))
function [sdot]=sdot(t,s,b,beta,iav,i,d)
	sdot=b-beta*s*(i+iav)-(d*s)
endfunction

//-->i=ode(i0,t0,t,list(idot,beta,s,sav,g,d))
function [idot]=idot(t,i,beta,s,iav,g,d)
	idot=beta*s*(i+iav)-(g*i)-(d*i)
endfunction

//-->r=ode(r0,t0,t,list(rdot,g,i,d))
function [rdot]=rdot(t,r,g,i,d)
	rdot=g*i-d*r
endfunction
