function [nid2,pss_pos,PSS_detect,PAR,max_nid_value]=PSS_detection(rx_data,PAR_ratio,pss_flocal,Detect_win_len)


%----- step1 Correlation peak calculation ---------------%
rx_data_len = length(rx_data);
L_window = size(pss_flocal,2);
rx_len =rx_data_len-L_window+1;
corr_out = zeros(3,rx_len);

for j= 1:3
    for i = 1:rx_len
        [corr_out(j,i),~]=pss_corr_stage1(rx_data(i:i+L_window-1),j,pss_flocal);
    end
end

%----- step2 Detection inside window ---------------%
win_num = ceil(rx_len/Detect_win_len);
max_value = zeros(1,3);
max_index = zeros(1,3);
max_nid_value = zeros(1,win_num);
max_index_value = zeros(1,win_num);
noise_nid_value = zeros(1,win_num);
max_nid_index_tmp=zeros(1,win_num);
PARxNoise = zeros(1,win_num);
Detect_corr = zeros(3,Detect_win_len);

for k = 1:win_num
    for j = 1:3
        if k < win_num  % Correlation of current window
            Detect_corr(j,:)=corr_out(j,(k-1)*Detect_win_len+1:k*Detect_win_len);
        else
            Detect_corr(j,:) = [corr_out(j,(k-1)*Detect_win_len+1:end) zeros(1,Detect_win_len-rx_len+(k-1)*Detect_win_len)];
        end
        [max_valuej,max_indexj] = sort(Detect_corr(j,:));% Positon of the correlation peak:
        max_value(j)= max_valuej(end);
        max_index(j)= max_indexj(end);
    end
    [max_nid_valuek, max_nid_index_tmpk]=sort(max_value);
    max_nid_value(k)= max_nid_valuek(end);
    max_nid_index_tmp(k)= max_nid_index_tmpk(end);
    max_index_value(k)=max_index(max_nid_index_tmp(k));% Max correlation peak of the 3 NID(2)
    max_noise_index=setdiff([1 2 3],max_nid_index_tmp(k));
    noise_nid_value(k)=mean(Detect_corr(max_noise_index, max_index_value(k))); 
    PARxNoise(k)=PAR_ratio*noise_nid_value(k);
end
PAR = max_nid_value./noise_nid_value;

%-------------------- Judge based on PAR ---------------------%
win_index = find(max_nid_value>PARxNoise); 
if isempty(win_index)% 漏检 低SNR下需要从这里退出，否则会异常中断
    nid2 = 4;
    pss_pos = 1;
    PSS_detect =[];
    return;
end
pss_max_detect = max_nid_value(win_index); % for debug
pss_pos_detect = max_index_value(win_index)+(win_index-1)*Detect_win_len;
nid2_detect = max_nid_index_tmp(win_index);
PAR_max_detect = PAR(win_index); % for debug

% Select the max in pss_max_detect
[corr_out_max_tmp,pss_pos_index_tmp]= sort(pss_max_detect); % Position of the peak:
corr_out_max=corr_out_max_tmp(end);
pss_pos_index = pss_pos_index_tmp(end);

pss_pos =pss_pos_detect(pss_pos_index);
nid2 = nid2_detect(pss_pos_index)-1;
PSS_detect = pss_flocal(nid2+1,:);



end

