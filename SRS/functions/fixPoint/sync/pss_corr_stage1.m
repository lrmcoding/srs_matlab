function [data,avg]=pss_corr_stage1(rx_data,pss_sym_type,pss_local)
    nParal = ceil(length(rx_data)/16);
    tmp0 = rx_data.*conj(pss_local(pss_sym_type,:));
    tmp0_add = [tmp0,zeros(1,nParal*16-length(tmp0))];
    len = length(tmp0_add);
    tmp = zeros(nParal,16);
    for iParal = 1:16
        index = iParal:16:len;
        tmp(:,iParal) = tmp0_add(index);
    end
    s_tmp = sum(tmp);
    s = sum(s_tmp);
    data = s.*conj(s); 

    % Autocorrelation calculation
    tmp1 = rx_data.*conj(rx_data);
    s1 = sum(tmp1);
    avg = s1.* conj(s1);
end

