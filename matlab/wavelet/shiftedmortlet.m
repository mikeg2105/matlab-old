function [shiftedmortlet]=shiftedmortlet(n, ndash, deltat, s, omega0)

	shiftedmortlet= sqrt(deltat/s)*mortlet((ndash-n)*deltat/s, omega0);

%endfunction