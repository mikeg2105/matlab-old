BASEDIR="/home1/cs/cs1mkg/proj/math/scilab/pvm_tutorial/";
getf(BASEDIR + "estimate_pvm.sci");

lambdas=[0:0.1:0.5 1:10 100:100:1000];
n = length(lambdas);

// ------------ Code for the master process ------------
function [b_bias, b_variance] = master()
    // Spawn child processes
    [tids, nt] = pvm_spawn(BASEDIR + "example_pvm.sce", n, "nw");
    
    if n <> nt then
        printf("Error\n"); return; // Failed
    end

    // Distribute tasks
    for i=1:n
        pvm_send(tids(i), [i, lambdas(i)], 1);
    end

    // Collect results
    for i=1:n
        b = pvm_recv(-1, -1);
        b_bias(b(1)) = b(2);
        b_variance(b(1)) = b(3);
    end
endfunction

// ------------ Code for the slave process ------------
function slave()
   // Receive task
   task = pvm_recv(pvm_parent(), -1);
   
   // Calculate
   [b, v] = estimate(task(2));

   // Send result
   pvm_send(pvm_parent(), [task(1), b, v], 1);
endfunction

// ------------ Main ------------
tic();
if pvm_parent() == -23 then
    [b_bias, b_variance] = master();
else
    slave();
end
printf("Time: %f\n", toc());
pvm_exit();
quit();
