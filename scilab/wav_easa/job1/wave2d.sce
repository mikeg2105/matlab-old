//2d wave
//return a 2d matrix of wave amplitudes
function [wave2d]=wave2d(time, wavetype, maxamplitude, wavenumber, wavefreq, delta, n)

  nx=n(1);
  ny=n(2);

  wave2d=zeros(nx,ny);
  dx=delta(1);
  dy=delta(2);

  
  k1=wavenumber(1);
  k2=wavenumber(2);
  
  //stationary/standing wave 
  if wavetype == 0 then
  
      for i=1:nx
        for j=1:ny
          wave2d(i,j)=sin((k1*i*dx)+(k2*j*dy))*sin(wavefreq*time);
        end
      end
  
  
  //travelling/progressive wave
  elseif wavetype == 1 then
    for i=1:nx
      for j=1:ny
        wave2d(i,j)=sin(((k1*i*dx)+(k2*j*dy))-(wavefreq*time));
      end
    end
  
  end

endfunction
