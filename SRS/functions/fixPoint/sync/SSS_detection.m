function [nid1,SSS_detect] = SSS_detection(rx_sss,sss_ref,nid2)


corr = zeros(1,36);
nParal = ceil(90/16);
for i=1:36
    ncellid = (3*(i-1)) + nid2;
    tmp0 = rx_sss.*conj(sss_ref(ncellid+1,:));
    tmp0_add = [tmp0, zeros(1,nParal*16-length(tmp0))]; 
    len =  size(tmp0_add,2);
    s_tmp = zeros(1,16,nParal);
    for iParal = 1:16
        index = iParal:16:len;
        s_tmp(1, iParal, :) = tmp0_add(1, index);
    end
    s_f=sum(s_tmp,3);
    s=sum(s_f,2); 
    corr(i)=sum(s.*conj(s));
end
[~,nid1_tmp]= max(corr);
nid1=nid1_tmp-1;
nid = (3*(nid1)) + nid2;
SSS_detect = sss_ref(nid+1,:);
end

