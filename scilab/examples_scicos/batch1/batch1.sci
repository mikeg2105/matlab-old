///withoutPrompt 
//function void() /// @@prerequisite  ( trick here I do not want scilab to execute the f code)
load batch1.cos
freq_list=[.1 1 2 4]; /// \sleftarrow{\normalfont  list of frequencies to consider}
k=find(%cpr.sim.labels=='toto');  /// \sleftarrow{\normalfont  block number}
idx=%cpr.sim.rpptr(k):%cpr.sim.rpptr(k+1)-1;
tf=100; /// \sleftarrow{\normalfont simulation parameters}
tol=[1.d-4,1.d-6,1.d-10,tf+1,0,0];
for i=1:size(freq_list,2) /// \sleftarrow{\normalfont  main loop over the list of frequencies}
  %cpr.sim.rpar(idx(2))=freq_list(i);
  state=%cpr.state;
  [state,t]=scicosim(state,0,tf,%cpr.sim,'start',tol);
  [state,t]=scicosim(state,t,tf,%cpr.sim,'run',tol);
  [state,t]=scicosim(state,t,tf,%cpr.sim,'finish',tol);
  // renaming o_file o_file1, o_file2,.... 
  if MSDOS then
    host('move o_file o_file'+string(i));
  else
    host('mv o_file o_file'+string(i));
  end
end
// and plotting on a single graph
xbasc()
for i=1:size(freq_list,2)
  tx=read('o_file'+string(i),-1,2); /// \sleftarrow{\normalfont reading back the results of the simulation}

  plot2d(tx(:,1),tx(:,2),i)/// \sleftarrow{\normalfont and plotting on a single graph}
end
//endfunction /// @@prerequisite  ( trick here I do not want scilab to execute the f code) ///\withPrompt{}

