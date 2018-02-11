%1d wave
%return a 1d vector of wave amplitudes
function [wave1d]=wave1d(time, wavetype, maxamplitude, wavenumber, wavefreq,delta, n)

  wave1d=zeros(n); 
  k=wavenumber;
  
  %stationary/standing wave 
  if wavetype == 0
  
      for i=1:n
          wave1d(i)=maxamplitude*sin((k*i*delta))*sin(wavefreq*time);
      end
  
  
  %travelling/progressive wave
  elseif wavetype == 1
    for i=1:n
          wave1d(i)=maxamplitude*sin(((k*i*delta))-(wavefreq*time));
     end
  
  end

%endfunction
