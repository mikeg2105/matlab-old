//main routines for calling solvers









//case 3 generate a config file
//saves the recovered and susceptible populations
//saves total population
function [runepigen2]=runepigen2(nr,nc,beta,b,d,g, srange, ci,cr,cs,si,sr,ss, simname, nsteps, savefreq)
	steps=0
	status=0
	sm=createmat(nr, nc, cs, ss)
	im=createmat(nr, nc, ci, si)
	rm=createmat(nr, nc, cr, sr)
	
	icfgname=simname+'_i.cfg'
	rcfgname=simname+'_r.cfg'
	scfgname=simname+'_s.cfg'
	tcfgname=simname+'_t.cfg'
	im(2,3)=2
	for i=1:nsteps
	  sav=avgelem(im, nr, nc, srange)
	  
		news=solves(nr, nc, sm, sav , im, rm, beta, b, d, g, i/savefreq, (i+1)/savefreq);
	  newi=solvei(nr, nc, sm, sav , im, rm, beta, b, d, g, i/savefreq, (i+1)/savefreq);
	  newr=solver(nr, nc, sm, sav , im, rm, beta, b, d, g, i/savefreq, (i+1)/savefreq);
	  
	  sm=news
	  im=newi
	  rm=newr
	  
	  savecfg=modulo(i, savefreq);
	  if savecfg==0 then	  
	  	//cfgname=simname+string(i)+'.cfg'
	   //saveconfig(cfgname, nr, nc, sm, im, rm, beta,b,d,g);
	   appendconfigi(icfgname, nr, nc, sm, im, rm, beta,b,d,g,i);
	   appendconfigs(scfgname, nr, nc, sm, im, rm, beta,b,d,g,i);
	   appendconfigr(rcfgname, nr, nc, sm, im, rm, beta,b,d,g,i);
	   appendconfigt(tcfgname, nr, nc, sm, im, rm, beta,b,d,g,i);
	  end
	end
	

  runepigen2=status
endfunction

