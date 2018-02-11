%
% Given a nickname for a grid node
% Returns information about that node
%
%

function [GLOBUSSERVER, JOBMANAGER, MYHOME]=nodeinfo(nodenickname)


    if (strcmp(nodenickname,'ice') || strcmp(nodenickname,'iceberg') || strcmp(nodenickname,'sn1'))
        % The name of the directory on the Globus server
        GLOBUSSERVER = 'iceberg.shef.ac.uk';
        MYHOME = '/home1/cs/cs1mkg';
        JOBMANAGER = [GLOBUSSERVER, '/jobmanager-sge']
        {GLOBUSSERVER, JOBMANAGER, MYHOME}
    elseif (strcmp(nodenickname,'ngs-c1') || strcmp(nodenickname,'ngs-leeds1') || strcmp(nodenickname,'ngs-comp1'))
        GLOBUSSERVER = 'grid-compute.leeds.ac.uk';
        MYHOME = '/home/data01_a/ngs0244';
        JOBMANAGER = [GLOBUSSERVER, '/jobmanager-pbs']
    elseif (strcmp(nodenickname,'ngs-c2') || strcmp(nodenickname,'ngs-ox1') || strcmp(nodenickname,'ngs-comp2'))
        GLOBUSSERVER = 'grid-compute.oesc.ox.ac.uk';
        MYHOME = '/home/ngs0176';
        JOBMANAGER = [GLOBUSSERVER, '/jobmanager-pbs']
    elseif (strcmp(nodenickname,'max') || strcmp(nodenickname,'maxima') || strcmp(nodenickname,'ln1'))
        GLOBUSSERVER = 'maxima.leeds.ac.uk';
        MYHOME = '/home/ufaserv2_wrga/wrsmg';
        JOBMANAGER = [GLOBUSSERVER, '/jobmanager-sge']
    elseif (strcmp(nodenickname,'sno') || strcmp(nodenickname,'snowdon') || strcmp(nodenickname,'ln2'))
        GLOBUSSERVER = 'snowdon.leeds.ac.uk';
        MYHOME = '/home/ufaserv2_wrga/wrsmg';
        JOBMANAGER = [GLOBUSSERVER, '/jobmanager-sge']
   elseif (strcmp(nodenickname,'ngs-d1') || strcmp(nodenickname,'ngs-ral') || strcmp(nodenickname,'ral'))
        GLOBUSSERVER = 'grid-data.rl.ac.uk';
        MYHOME = '/home/ngs0245';
        JOBMANAGER = [GLOBUSSERVER, '/jobmanager-pbs']
   elseif (strcmp(nodenickname,'ngs-d2') || strcmp(nodenickname,'ngs-man') || strcmp(nodenickname,'man'))
        GLOBUSSERVER = 'grid-data.man.ac.uk';
        MYHOME = '/home/ngs0244';
        JOBMANAGER = [GLOBUSSERVER, '/jobmanager-pbs']	
    end
    
    



   
