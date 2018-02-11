getf("estimate.sci");
rand("seed", 1);

// Evaluate bias and variance for these lambdas 
lambdas=[0:0.1:0.5 1:10 100:100:1000];

b_bias = []; b_variance = []; // Store results here

tic();
for lambda=lambdas // For each lambda
  [b_bias($+1) b_variance($+1)] = estimate(lambda);
  printf(".");
end

printf("\n Time: %f\n", toc());
