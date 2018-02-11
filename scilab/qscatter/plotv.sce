exec('v.sce');

start=3.1;   //sigma
step=0.005;
finish=start*2;

evr=start:step:finish;
potsize=size(evr);

for i=1:potsize(1,2); pot(i)=v(evr(i)); end;

plot(pot);
