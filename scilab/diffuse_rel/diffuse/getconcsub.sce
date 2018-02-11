
//Calculates 3x3x£ matrix of nearest neighbour elements for a value
function [getconcsub]=getconcsub(conc, i1,i2,i3, n1, n2, n3)
                                                
                                                if n3<2
						  nsub3=1;
						else
					          nsub3=3;
						end;

      						testconcsub=zeros(3,3,3);
	      						for j1=-1:1
	      							for j2=-1:1
	      								for j3=-1:1
	      									si1=i1+j1
	      									si2=i2+j2
	      									si3=i3+j3
	      									
	      									if si1<1
	      									  si1=n1;
	      									end
	      									if si2 <1
	      									  si2=n2;
	      									end
	      									if si3 < 1
	      									  si3=n3;
	      									end
	      									if si1 > n1
	                   si1=1;      									
	      									end
	      									if si2 > n2
	      									  si2=1;
	      									end
	      									if si3 > n3
	      									  si3=1;
	      									end
	      									
	      									if si1>0 
	      										if si1<=n1
	      									  		if si2>0
	      									  			if si2<=n2
                                                            if si3>0
                                                                if si3<=n3
	      																		testconcsub(j1+2, j2+2, j3+2)=conc(si1,si2,si3);
	      									        			end
                                                            end
                                                        end
	      											end
	      										end		
	      									end
	      									//finished checking bcs
	      											
	      								end
	      							end
                                end
                                getconcsub=testconcsub;
endfunction



