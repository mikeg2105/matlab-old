%simple demo script for matlab dce
%test by Mike Griffiths 22nd January 2007

%The above script file can be executed as a single command using the dfeval
%function as follows
results=dfeval(@beats,{1 2 3 4},{20 20 20 20},{100 100 100 100}, 'Configuration', 'sge')



results=getAllOutputArguments(job)
save('myresults2','results');



for ic=1:4
    subplot(2,2,ic);
    surf(results{ic});
end