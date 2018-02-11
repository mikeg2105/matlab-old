function [usergrouplist]=usergrouplist(userdetails)
%generate list of usergroups from userdetails cell array

    [nus,ncol]=size(userdetails);
    tempusergrouplist=cell(nus);
    nusergroups=0;
    for i=1:nus

        currentusergroup=sprintf('%s',userdetails{i,2});
        %is currentusergroup in the user group list
        if nusergroups>0
            notfound=1;
            for j=1:nusergroups
              groupcomp= strcmp(currentusergroup, tempusergrouplist{j});
              if groupcomp==1
                 notfound=0;
                 break;
              end
            end
            if notfound>0
                nusergroups=nusergroups+1;
                tempusergrouplist{nusergroups}=sprintf('%s',currentusergroup);                         
            end
            
        else
            nusergroups=1;
            tempusergrouplist{nusergroups}=sprintf('%s',currentusergroup);         
        end
        
        
    end
    
    usergrouplist=cell(nusergroups,1);
    for i=1:nusergroups
      usergrouplist{i}=sprintf('%s',tempusergrouplist{i});
    end


%endfunction