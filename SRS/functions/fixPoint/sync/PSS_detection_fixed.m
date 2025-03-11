function [nid2,pss_pos,PSS_detect,PAR] = PSS_detection_fixed(rx_data,PAR_ratio,pss_local_fixed,Detect_win_len)

%---------------- Correlation peak calculation ---------------------------%
rx_data_len = length(rx_data);
L_window = size(pss_local_fixed,2);
rx_len = rx_data_len - L_window + 1;
corr_out = zeros(3,rx_len);

% slide correlation
for j = 1:3
   for i = 1:rx_len
       [corr_out(j,i),~] = pss_corr_stage2_Gfixed(rx_data(i:i+L_window-1),j,pss_local_fixed); 
   end
end

%--------------------- Detection in window -------------------------------%
win_num = ceil(rx_len/Detect_win_len);
max_nid_value = zeros(1,win_num);
max_index_value = zeros(1,win_num);
noise_nid_value = zeros(1,win_num);
max_nid_index_tmp = zeros(1,win_num);
PARxNoise = zeros(1,win_num);
Detect_corr = zeros(3,win_num);

for k = 1:win_num
    for j = 1:3
        % Zero padding the correlation result to window length 
        if k<win_num
            Detect_corr(j,:) = corr_out(j,(k-1)*Detect_win_len+1:k*Detect_win_len);
        else
            Detect_corr(j,:) = [corr_out(j,(k-1)*Detect_win_len+1:end) zeros(1,k*Detect_win_len-rx_len)];
        end
    end
    
    % 16 bits of peak 12 bits of index in window 4 bits of NID2
    Detect_corr_all = limit(Detect_corr,32,+16)+limit([1:Detect_win_len;1:Detect_win_len;1:Detect_win_len],32,+4)+[ones(1,Detect_win_len);2*ones(1,Detect_win_len);3*ones(1,Detect_win_len)];
    Detect_corr_tmp = reshape(Detect_corr_all.',16,[],3);
    Detect_corr_tmp1 = permute(Detect_corr_tmp,[2 1 3]);
    pwr_max48_tmp = sort(Detect_corr_tmp1,1);
    pwr_max48 = pwr_max48_tmp(end,:,:);
    pwr_max_tmp = sort(reshape(pwr_max48,[],1));
    pwr_max = pwr_max_tmp(end);
    
    max_nid_value(k) = limit(pwr_max,16,-16);
    max_nid_index_tmp(k) = bitand(pwr_max,15);
    max_index_value(k) = limit(bitand(pwr_max,65520),16,-4);
    max_noise_index = setdiff([1 2 3],max_nid_index_tmp(k));
    noise_nid_value(k) = limit(sum(Detect_corr(max_noise_index,max_nid_index_tmp(k))),16,-1);
    if noise_nid_value(k) == 0
         noise_nid_value(k) =1;
    end
    PARxNoise(k) = PAR_ratio*noise_nid_value(k);
end

%-------------------------Judge based on PAR------------------------------%
PAR = max_nid_value./noise_nid_value;
win_index = find(max_nid_value>PARxNoise);
if isempty(win_index)
    nid2 = [];
    pss_pos = [];
    PSS_detect = [];
    return;
end
pss_max_detect = max_nid_value(win_index);
pss_pos_detect = max_index_value(win_index)+(win_index-1)*Detect_win_len;
nid2_detect = max_nid_index_tmp(win_index);
PAR_max_detect = PAR(win_index);

% Select the largest 
[corr_out_max_tmp,pss_pos_index_tmp] = sort(pss_max_detect);
corr_out_max = corr_out_max_tmp(end);
pss_pos_index = pss_pos_index_tmp(end);

pss_pos = pss_pos_detect(pss_pos_index);
nid2 = nid2_detect(pss_pos_index)-1;
PSS_detect = pss_local_fixed(nid2+1,:);

end

