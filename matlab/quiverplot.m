% example quiverplot    
% define a mesh spaced 0.2 ranging from -2 to 2 for both x and y
       [x,y] = meshgrid(-2:.2:2, -2:.2:2);
% calculate z = exp(-2x-2y) over the grid.
        z = x .* exp(-x.^2 - y.^2);
% calculate the gradients and store them in px,py matrices. 
%  note that 0.2 which is dx,dy over the grid must be specified..
        [px,py] = gradient(z,.2,.2);
        contour(z)
        hold on
        quiver(px,py)
        hold off