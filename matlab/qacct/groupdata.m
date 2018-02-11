function [groupdata,userdata]=groupdata(data,userdetails,usergroups)
% file to generate user group data fromo the acct data the user details and the user groups

   [nusers,nucols]=size(userdetails);
   [ngroups,ngcols]=size(usergroups);
   [ndata,ndcols]=size(data);
   
   %in addition to existing data will generate the follwoing 4
   %wall time in hours
   %cpu time in hour
   %utilisation(%)
   %memory=memory/cputime
   
   groupdata=zeros(ngroups,ndcols+4);
   userdata=data;
   
   totalwallclock=sum(data(:,1));
   for i=1:nusers
      userdata(i,8)=data(i,1)/3600;
      userdata(i,9)=100*userdata(i,1)/totalwallclock;
      
      if data(i,4)>0
        userdata(i,10)=data(i,5)/data(i,4);
      else
        userdata(i,10)=0; 
      end
      userdata(i,11)=i;

   end
   
   for i=1:ngroups
      currentgroup=sprintf('%s',usergroups{i});
      ningroup(i)=0;
      for j=1:nusers
          if strcmp(currentgroup, userdetails{j,2})==1
              
              for k=1:7
                groupdata(i,k)=groupdata(i,k)+data(j,k);
              end
              ningroup(i)=ningroup(i)+1;
          end          
      end
      
   end
   
   
   
   for i=1:ngroups
      nuing=ningroup(i);
      
      if nuing>0    
          groupdata(i,8)=groupdata(i,1)/3600;
          groupdata(i,9)=100*groupdata(i,1)/totalwallclock;

          if groupdata(i,4)>0
            groupdata(i,10)=groupdata(i,5)/groupdata(i,4);
          else
            groupdata(i,10)=0; 
          end
      end
      groupdata(i,11)=i;
   end

%endfunction