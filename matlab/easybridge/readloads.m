function [loadvector]=readloads(inputfile)

    loadfile=fopen(inputfile, 'r');
    
    %read number of points
    np=fscanf(loadfile, '%d',1);
    display(np)
    filevecs=zeros(np,2);
    for i=1:np
       filevecs(i,1)=fscanf(loadfile, '%f',1);
       filevecs(i,2)=fscanf(loadfile, '%f',1); 
    end

    loadvector=filevecs;
%endfunction
