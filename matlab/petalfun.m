function petalfun
% A Matlab Function which plots flower petals
% Used as an example to the Introduction to Matlab Course
% 
% 
alpha = -pi:0.01:pi;
ro(1,:) = 2*sin(5*alpha).^2 ;
ro(2,:) =cos(10*alpha).^3 ;
ro(3,:) = sin( alpha).^2 ;
ro(4,:) = 5*cos(3.5*alpha).^3;
% uncomment the two hold lines below to experiment with 
% graphics output on the same graph
% hold on
for i = 1:4
   polar(alpha,ro(i,:) )
   pause
end
% hold off