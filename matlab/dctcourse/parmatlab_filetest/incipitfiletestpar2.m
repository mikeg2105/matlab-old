%function [myruntime]=incipitfilespar1(filelistname,fromlocation,tolocation,scale)
filelistname='filelist.txt'

fromlocation='/scratch/cs1mkg/temp/MS_865';
tolocation='/scratch/cs1mkg/temp/ms865';
scale=0.1;
  
  %filelistname='filelist.txt'
%filelist=textread(filelistname,'%s');
%filecount=size(filelist);
%filecount=filecount(1,1);


%filelist='filelist.txt'

%fromlocation='/scratch/cs1mkg/temp/MS_865';
%tolocation='/scratch/cs1mkg/temp/ms865';
%scale=0.1;
%filelist=textread(filename,'%s');
%filecount=size(filelist);
%filecount=filecount(1,1);

  %filelistname='filelist.txt'
filelist=textread(filelistname,'%s');
filecount=size(filelist);
filecount=filecount(1,1);

 % nfilespp=  filecount/numlabs
 % startf=1+(labindex-1)*nfilespp
  
 % if labindex==numlabs
 %   finishf=filecount;  
 % else
 %   finishf=startf+nfilespp;
 % end
 startf=1;
 finishf=filecount;
 
  
  for i=startf:finishf
     %process the files
     
     if labindex==1
        inputimfile=[fromlocation,'/',filelist{i}];
        image=imread(inputimfile);
        imsize=size(image)
        tic;
        if numlabs>1
            for j=2:numlabs
               remmod=mod(imsize(1,2),numlabs);
               npp=int16(imsize(1,2)/numlabs);
               startp=1+(j-1)*npp;
  
               if j==numlabs
                   ep=int16(imsize(1,2)); 
               else
                  ep=startp+npp-1;
               end 
                
             imsect=image(:,startp:ep,:);  
             labSend(imsect,j);
             %rimsect = labSendReceive(j, 1, imsect);
            end
        end
        remmod=mod(imsize(1,2),numlabs);
        npp=int16(imsize(1,2)/numlabs);
        startp=1;
  
        if 1==numlabs
                   ep=int16(imsize(1,2));
        else
              
                  ep=startp+npp-1;
        end
        imsect=image(:,startp:ep,:); 
        
     else
         
         imsect=labReceive(1);
     end
     
     modimage=imadjust(imsect, [0 1 ], [0.5 1]);
     
     
     if labindex==1
        modimagesize=size(modimage)
        imsectsize=size(imsect)
        npp=int16(imsize(1,2)/numlabs);
        startp=1
        remmod=mod(imsize(1,2),numlabs)
        if 1==numlabs
                   ep=int16(imsize(1,2))  
        else
                  ep=startp+npp-1
        end
        %image(:,startp:ep,:)=modimage;
        image(:,startp:ep,:)=modimage;
        if numlabs>1
            for j=2:numlabs           
             modimage=labReceive(j);
             %rimsect = labSendReceive(1, j, imsect);
             remmod=mod(imsize(1,2),numlabs);
               npp=int16(imsize(1,2)/numlabs);
               startp=1+(j-1)*npp;
  
               if j==numlabs
                   ep=int16(imsize(1,2));  
               else
                  ep=startp+npp-1;
               end         
             
             
             image(:,startp:ep,:)=modimage;
            end
        end
        myruntime=toc

     else
        labSend(modimage,1); 
     end

     if labindex==1
        newim=imresize(image,scale);
        newfile=[tolocation,'/',filelist{i}];
        imwrite(newim,newfile,'TIFF');
     end
  end
  
  
 

