function [myruntime]=transporttestpar1(nsamples)
    nsamples=1;
    msiz=[48 480 4800];  %matrix sizes to test
    %msiz=[480];
    myruntime=zeros(1,nsamples)
    k=3;
  
    for k=1:3
    tic;
    if labindex==1
        
        image=zeros(msiz(k), msiz(k));
        imsize=size(image)
        
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
     
     %matrix scattered now perform an operation
     modimage=imsect+labindex;
     
     if labindex==1
        modimagesize=size(modimage);
        imsectsize=size(imsect);
        npp=int16(imsize(1,2)/numlabs);
        startp=1
        remmod=mod(imsize(1,2),numlabs)
        if 1==numlabs
                   ep=int16(imsize(1,2))  
        else
                  ep=startp+npp-1;
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
        

     else
        labSend(modimage,1); 
     end
     myruntime(k)=toc
     
    end
     




