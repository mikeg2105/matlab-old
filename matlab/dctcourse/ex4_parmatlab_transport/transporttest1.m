filelist='filelist.txt'

fromlocation='/scratch/cs1mkg/temp/MS_865';
tolocation='/scratch/cs1mkg/temp/ms865';
scale=0.1;
%filelist=textread(filename,'%s');
filecount=size(filelist);
filecount=filecount(1,1);

  %filelistname='filelist.txt'
filelist=textread(filelist,'%s');
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
 
  tic;
  for i=startf:finishf
     %process the files
     inputimfile=[fromlocation,'/',filelist{i}];
     image=imread(inputimfile);
     imsize=size(image)
     imsect=image(:,1:imsize(1,2)/2,:);
     imsectsize=size(imsect)
     modimage=imadjust(imsect, [0 1 ], [0.5 1]);
     image(:,1:imsize(1,2)/2,:)=modimage;
     newim=imresize(image,scale);
     newfile=[tolocation,'/',filelist{i}];
     imwrite(newim,newfile,'TIFF');
  end
  
  
 
myruntime=toc

