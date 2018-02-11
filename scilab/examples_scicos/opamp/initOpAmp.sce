host(SCI+'/bin/modelicac -c IdealOpAmp3Pin.mo')
getf('IdealOpAmp3Pin.sci')
scicos test.cos;
