function [Copt,Gammaopt,acc] = FindOptCGamma(train,test,model,out,real,vs)
    classifyoption = svmlopt('Verbosity',0);
    Clist = [2^12 2^11 2^10 2^9 2^8 2^7 2^6 2^5 2^4 2^3 2^2 2 1 2^-1 2^-2 2^-3 2^-4 2^-5];    %18 values
    Gammalist = [ 16 8 4 2 1 2^-1 2^-2 2^-3 2^-4 2^-5 2^-6 2^-7 2^-8 2^-9 2^-10 ]; %15 values
    
    %Clist = [ 10 ]; Gammalist = [2.5024 ];
    %% search optimal C among Clist
    for i=1:length(Clist)
        c = Clist(i);
        for j=1:length(Gammalist)
            gamma = Gammalist(j);
            learnoption = svmlopt('C',c,'Kernel',2,'KernelParam',gamma,'Verbosity',0); 
            status = svm_learn(learnoption,train,model);
            status = svm_classify(classifyoption,test,model,out);
            svmpredict = svmlread(out);
            [accurate,precision,recall] = ShowAccuracy(real,svmpredict);
            CGaccuracy(i,j) = accurate;
        end
    end    
   [maxrow,rowind]=max(CGaccuracy);  % row
   [acc,indG] = max(max(CGaccuracy)); % column = indG
   indC = rowind(indG); % indC
   Copt = Clist(indC);
   Gammaopt = Gammalist(indG);
   SaveOptCGammaAccuracy(vs,Copt,Gammaopt,acc);
   
