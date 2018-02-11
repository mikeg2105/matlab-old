function [xdata,ydata] = CreateSVMlightFile(data,classcolumn,target,svmlightfile)

    indi = data(:,classcolumn)==target;
    data(indi,classcolumn) = 1;          % assign target class as 1
    indj = ~indi;
    data(indj,classcolumn) = -1;         % assign non-target class as -1
    xdata = data;
	ydata = xdata(:,classcolumn);        % ytdata keeps target(class) field
	xdata(:,classcolumn) = [];           % xdata consists of only features 
	svmlwrite(svmlightfile,xdata,ydata); % generate svmlight-format training data 
    





