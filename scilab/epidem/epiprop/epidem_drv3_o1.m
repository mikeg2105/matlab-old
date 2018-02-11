//main routines for calling solvers


//case 1 starting configuration is a config file
function [numsteps]=runepidem(startconfig, simname, nsteps, savefreq)
		steps=0
		
		fd=mopen(startconfig, 'r')
		
		parmat=loadparam(fd)
		beta=parmat(1,1)
    b=parmat(1,2)
    d=parmat(1,3)
    g=parmat(1,4)
    
    matprops=loadmatprops(fd)
    nr=matprops(1,1)
    nc=matprops(1,2)
    
    s=loadmat(fd, nr, nc)
    matprops=loadmatprops(fd)
    i=loadmat(fd, nr, nc)
    matprops=loadmatprops(fd)
    r=loadmat(fd, nr, nc)
    
    
		
		mclose(fd)
	
	
	//cfgname=simname+'.cfg'
	for i=1:nsteps
	  iav=avgelem(i, nr, nc, range)
		ns=solves(nr, nc, s, iav , i, r, beta, b, d, g, i, i+1)
	  ni=solvei(nr, nc, s, iav , i, r, beta, b, d, g, i, i+1)
	  nr=solver(nr, nc, s, iav , i, r, beta, b, d, g, i, i+1)
	  
	  s=ns
	  i=ni
	  r=nr
	  
	  savcfg=modulo(i, savefreq)
	  if savecfg==0 then	  
	  	cfgname=simname+string(i)+'.cfg'
	   //appendconfig(cfgname, nr, nc, s, i, r, beta,b,d,g)  
	  end
	end
	

  numsteps=steps
endfunction



//case 2 generate a config file
function [numsteps]=rungenepidem1(nr,nc,beta,b,d,g, srange, ci,cr,cs,si,sr,ss, simname, nsteps, savefreq)
	steps=0
	sm=createmat(nr, nc, cs, ss)
	im=createmat(nr, nc, ci, si)
	rm=createmat(nr, nc, cr, sr)
	cfgname=simname+'.cfg'
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
	   appendconfigi(cfgname, nr, nc, sm, im, rm, beta,b,d,g,i); 
	  end
	end
	

  numsteps=steps
endfunction



//case 3 generate a config file
//saves the recovered and susceptible populations
//saves total population
function [numsteps]=rungenepidem2(nr,nc,beta,b,d,g, srange, ci,cr,cs,si,sr,ss, simname, nsteps, savefreq)
	steps=0
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
	

  numsteps=steps
endfunction

