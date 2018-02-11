//2d wavepacket
//return a 2d matrix of wave amplitudes
function [wavepacket2d]=wavepacket2d(time, wavetype, maxamplitude, wavenumber, wavefreq, pwavnum, pwavfreq, np, delta, n)

  wavepacket2d=zeros(nx,ny);
  dx=delta(1);
  dy=delta(2);
  nx=n(1);
  ny=n(2);
  
  wavetempp=zeros(nx,ny);
  wavetempm=zeros(nx,ny);
  wavtemp=zeros(nx,ny);
  wavold=zeros(nx,ny);
  
  k1=pwavnum(1);
  k2=pwavnum(2);
  
  //stationary/standing wave 
  if wavetype == 0 then
  
      for i=1:np
          wavetempp=wave2d(time, wavetype, maxamplitude, i*wavenumber/np, i*wavefreq/np, delta,nmax);
          wavetempm=wave2d(time, wavetype, maxamplitude, -i*wavenumber/np, -i*wavefreq/np, delta,nmax);
               
          for i1=1:nx
            for i2=1:ny
              wavtemp(i1,i2)=sin((k1*i*dx)+(k2*j*dy))*sin(pwavfreq*time)*(wavetempp(i1,i2)+wavetempm(i1,i2));
            end
          end       
          
          
          wavepacket2d=wavold+wavtemp;
          wavold=wavepacket1d;
      end
  
   
  
  
  //travelling/progressive wave
  elseif wavetype == 1 then
      for i=1:np
          wavetempp=wave2d(time, wavetype, maxamplitude, i*wavenumber/np, i*wavefreq/np, delta,nmax);
          wavetempm=wave2d(time, wavetype, maxamplitude, -i*wavenumber/np, -i*wavefreq/np, delta,nmax);
               
          for i1=1:nx
            for i2=1:ny
              wavtemp(i1,i2)=sin((k1*i*dx)+(k2*j*dy)-pwavfreq*time)*(wavetempp(i1,i2)+wavetempm(i1,i2));
            end
          end       
          
          
          wavepacket2d=wavold+wavtemp;
          wavold=wavepacket1d;
      end
  
  end

endfunction

