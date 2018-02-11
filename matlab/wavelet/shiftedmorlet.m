function [shiftedmorlet]=shiftedmorlet(n, ndash, deltat, s, omega0)

	shiftedmorlet= sqrt(deltat/s)*morlet((ndash-n)*deltat/s, omega0);

%endfunction