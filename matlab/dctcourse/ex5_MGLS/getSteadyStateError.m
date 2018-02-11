function ss_error = getSteadyStateError(y, final)

% the steady state error is the absolute value of the final control signal
% minus the input value
ss_error = abs(y(end) - final);