

//figure(1)
//mesh(x,y,h(:,:,index))
//plot3d(x,y,h(:,:,1),alpha=34,theta=21,flag=[2,2,3]);
mesh(x,y,h(:,:,1),h(:,:,index));
f=gcf();

f.color_flag=3;
f.children.color_mode=2;

//Animation of H wave propogating
//for index=2:length(t)
for index=2:10
    //mesh(x,y,h(:,:,index))

 //plot3d(x,y,h(:,:,index),alpha=34,theta=21,flag=[2,2,3]); 
mesh(x,y,h(:,:,index),h(:,:,index));

    f=gcf();

f.children.color_flag=3;
f.children.color_mode=2;

    //axis ([0 100000 0 100000 4990 5010])
    //title ('AERSP 423 Computer Project Part II')
    //xlabel('X Domain [m]')
    //ylabel('Y Domain [m]')
    //zlabel('Height [m]')
    //pause(0.02)
end

