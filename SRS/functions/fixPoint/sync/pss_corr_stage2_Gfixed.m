function [data_fixed,avg_fixed] = pss_corr_stage2_Gfixed(rx_window_data_fixed,pss_sym_type,pss_local_fixed)

    temp0 = mac(rx_window_data_fixed.',conj(pss_local_fixed(pss_sym_type,:)),32,0);
    nParal = ceil(length(temp0)/16);
    temp0_add = [temp0,zeros(1, nParal-length(temp0))];
    len = length(temp0_add);
    temp = zeros(nParal,16);

    % 16 channels parallel
    for iParal = 1:16            
        index = iParal:16:len;
        temp(:,iParal) = temp0(index);
    end
    
    % Q32_29->Q16_15
    temp_fixed = limit(sum(temp),16,-14);
    % Q16_16->Q16_12
    s_fixed = limit(sum(temp_fixed),16,-3);
    % Q16_12*Q16_12->Q16_8
    data_fixed = mac(double(s_fixed),conj(double(s_fixed)),16,-16);
    data_fixed = real(data_fixed);

    % caculate mean value
    % Q16_15*Q16_15->Q32_30
    tmp1_fixed = mac(double(rx_window_data_fixed),conj(double(rx_window_data_fixed)),32,0);
    
    % Q32_30->Q16_10
    s1_fixed = limit(sum(tmp1_fixed),16,-20);
    
    % Q16_10*Q16_10->Q16_6
    avg_fixed = mac(double(s1_fixed),conj(double(s1_fixed)),16,-14);

end

