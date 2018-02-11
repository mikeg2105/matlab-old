function [mortlet]=mortlet(eta, omega0)

	mortlet= pi^(-0.25)*exp(i*omega0*eta)*exp(-eta^2/2);

%endfunction