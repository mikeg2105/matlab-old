%
% Given a nickname for a grid node
% Returns information about that node
%
%

function [GLOBUSSERVER, JOBMANAGER, SCIHOME]=nodeinfo(nodenickname)


    if (strcmp(nodenickname,'ice') || strcmp(nodenickname,'iceberg') || strcmp(nodenickname,'sn1'))
        % The name of the directory on the Globus server
        GLOBUSSERVER = 'iceberg.shef.ac.uk';
        SCIHOME = '/usr/local/packages/scilab-3.1.1';
        JOBMANAGER = [GLOBUSSERVER, '/jobmanager-sge']
        {GLOBUSSERVER, JOBMANAGER, SCIHOME}
    elseif (strcmp(nodenickname,'ngs-c1') || strcmp(nodenickname,'ngs-leeds1') || strcmp(nodenickname,'ngs-comp1'))
        GLOBUSSERVER = 'grid-compute.leeds.ac.uk';
        SCIHOME = '/home/data01_a/ngs0244/tools/scilab/scilab-3.1.1';
        JOBMANAGER = [GLOBUSSERVER, '/jobmanager-pbs']
    elseif (strcmp(nodenickname,'ngs-c2') || strcmp(nodenickname,'ngs-ox1') || strcmp(nodenickname,'ngs-comp2'))
        GLOBUSSERVER = 'grid-compute.oesc.ox.ac.uk';
        SCIHOME = '/home/ngs0176/tools/scilab/scilab-3.1.1';
        JOBMANAGER = [GLOBUSSERVER, '/jobmanager-pbs']
    elseif (strcmp(nodenickname,'max') || strcmp(nodenickname,'maxima') || strcmp(nodenickname,'ln1'))
        GLOBUSSERVER = 'maxima.leeds.ac.uk';
        SCIHOME = '/home/ufaserv2_wrga/wrsmg/tools/scilab_solaris/scilab-3.1.1';
        JOBMANAGER = [GLOBUSSERVER, '/jobmanager-sge']
    elseif (strcmp(nodenickname,'sno') || strcmp(nodenickname,'snowdon') || strcmp(nodenickname,'ln2'))
        GLOBUSSERVER = 'snowdon.leeds.ac.uk';
        SCIHOME = '/home/ufaserv2_wrga/wrsmg/tools/scilab/scilab-3.1.1';
        JOBMANAGER = [GLOBUSSERVER, '/jobmanager-sge']
    end
    
    



   
