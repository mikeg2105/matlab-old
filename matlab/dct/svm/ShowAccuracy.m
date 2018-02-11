function [accuracy,precision,recall] = ShowAccuracy(actual,predict)

	temp = (predict>=0);
	ntp = sum(actual==temp); 
	
	temp = (predict<0)*(-1);
	ntn = sum(actual==temp);
	
	nfn = sum(actual>=0)-ntp;
	nfp = sum(actual<0)-ntn;
	
	recall = ntp/(ntp+nfn);
	precision = ntp/(ntp+nfp);
    tp_rate = recall;         fp_rate = nfp/(nfp+ntn);
    fn_rate = nfn/(ntp+nfn);   tn_rate = ntn/(nfp+ntn);
	accuracy = (ntp+ntn)/(ntp+nfp+nfn+ntn);

 