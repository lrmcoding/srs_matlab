function [zc_seq_final] = nrGSRS(Lambda,v)
%ZC_GEN 此处显示有关此函数的摘要
%   此处显示详细说明
srs_zc_para=[
    1,2,2,10;...
    4,1,1,9;...
    7,2,1,9;
    8,0,3,11;
    1,3,2,10;
    3,8,2,10;
    4,8,2,10;
    5,8,2,10;
    1,6,2,10;
    2,0,1,9;
    3,1,3,11;
    4,2,3,11;
    1,7,1,9;
    5,1,2,10;
    6,8,2,10;
    7,8,2,10
    ];
temp=srs_zc_para((Lambda)*4+(1:4),:,:,:);
temp=temp(v+1,:,:,:);
u=temp(1,1);
shift_num=temp(1,2);
star_idx=temp(1,3);
end_idx=temp(1,4);
zc_seq=zadoffChuSeq(u,11);
zc_seq_cutoff=zc_seq(star_idx:end_idx);
zc_seq_final=circshift(zc_seq_cutoff,shift_num);
end

