//1d wave
//return a 1d vector of wave amplitudes
function [wavepacket1d]=wavepacket1d(time, wavetype, maxamplitude, wavenumber, wavefreq, pwavnum, pwavfreq, np, delta, n)

  wavepacket1d=zeros(n);
  wavetempp=zeros(n);
  wavetempm=zeros(n);
  wavtemp=zeros(n);
  wavold=zeros(n);
  k=wavenumber;
  //np=nfreq;
  
  //stationary/standing wave 
  if wavetype == 0 then
  
      for i=1:np
          wavetempp=wave1d(time, wavetype, maxamplitude, i*wavenumber/np, i*wavefreq/np, delta,nmax);
          wavetempm=wave1d(time, wavetype, maxamplitude, -i*wavenumber/np, -i*wavefreq/np, delta,nmax);
          for j=1:n
            wavtemp(j)=sin(j*pwavnum*delta)*sin(time*pwavfreq)*(wavetempp(j)+wavetempm(j));
          end
          wavepacket1d=wavold+wavtemp;
          wavold=wavepacket1d;
      end
      
  
  //travelling/progressive wave
  elseif wavetype == 1 then
      for i=1:np
          wavetempp=wave1d(time, wavetype, maxamplitude, i*wavenumber/np, i*wavefreq/np, delta,nmax);
          //wavetempm=wave1d(time, wavetype, maxamplitude, -i*wavenumber/np, -i*wavefreq/np, delta,nmax);
          for j=1:n
            wavtemp(j)=sin(j*pwavnum*delta-time*pwavfreq)*(wavetempp(j));//+wavetempm(j));
          end
          wavepacket1d=wavold+wavtemp;
          wavold=wavepacket1d;
      end
  
  end
  
endfunction
