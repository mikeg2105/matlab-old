
%Diffusion Automata
% Arash Azari


%*******************************
clear all
clf


% the size of cells board
%nx = input('Input the grid column size: ');

%ny = input('Input the grid row size: ');



% the number of run steps
number = uicontrol('style','text', ...
    'string','1', ...
   'fontsize',12, ...
   'position',[100,394,55,25]);

%define the Run button
plotbutton=uicontrol('style','pushbutton',...
   'string','Run', ...
   'fontsize',12, ...
   'position',[210,394,55,25], ...
   'callback', 'run=1;');

%define the Stop button
erasebutton=uicontrol('style','pushbutton',...
   'string','Stop', ...
   'fontsize',12, ...
   'position',[320,394,55,25], ...
   'callback','pausee=1;');

%define the Quit button
quitbutton=uicontrol('style','pushbutton',...
   'string','Quit', ...
   'fontsize',12, ...
   'position',[430,394,55,25], ...
   'callback','stop=1;close;');

stop=0;
run=0;
pausee=0;


nx=50; 
ny=50;
for i=1:nx
    for j=1:ny
        cell(i,j)=0;       
    end
end
y=0;
yy=0;
z=zeros(nx,ny);
diff=zeros(nx,ny);
s=zeros(1,2);
o=ones(nx,ny);
sum = z;
g = z;

cell = rand(nx,ny)<.1;

imag = image(cat(3,z,cell,g));
set(imag, 'erasemode', 'none')
axis equal
axis tight

while(stop==0)
    if(run==1)

for i=2:nx-1
    for j=2:ny-1
        if cell(i,j)==1
            sumd=cell(i-1,j)+cell(i+1,j)+cell(i,j-1)+cell(i,j+1);
            diff(i,j)=sumd/4;
            shiftx=0.2;
            shifty=0.2;
            px=diff(i,j)-shiftx*(cell(i,j-1)+cell(i,j+1));
            py=diff(i,j)-shifty*(cell(i-1,j)+cell(i+1,j));
            o(i,j)=px;
            o(i,j)=py;
            s=rand(1,2);
            
            if s(1,1)>px
                cell(i,j)=0;
                t1=rand;
                if t1>0.5
                cell(i+1,j)=1;
                else
                    cell(i-1,j)=1;
                end
            end
                
            if s(1,2)>py
                yy=yy+1;
                cell(i,j)=0;
                t2=rand;
                if t2>0.5
                cell(i,j-1)=1;
                else
                    cell(i,j+1)=1;
                end
                
            end
               
               
        end
    end
end
imag = image(cat(3,z,cell,g));
drawnow
stepnumber = 1 + str2double(get(number,'string'));
        set(number,'string',num2str(stepnumber))


    end
    if(pausee==1)
        run=0;
        pausee=0;
    end
    drawnow
    
end

