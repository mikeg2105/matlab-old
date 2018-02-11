

figure(1)

%Animation of H wave propogating
for index=1:length(t)
    mesh(x,y,h(:,:,index))
    axis ([0 100000 0 100000 4990 5010])
    title ('AERSP 423 Computer Project Part II')
    xlabel('X Domain [m]')
    ylabel('Y Domain [m]')
    zlabel('Height [m]')
    pause(0.02)
end

