function [freq_offset, dfAng_PerSymb, sss_demod] = SSS_cfo_estimation(carrier,SSS_detect,SSS_rcv,Nsss)

    %% 求频偏
    Nfft = carrier.NFFT;
    Ncp = carrier.CyclicPrefixLength(1);
    SubcarrierSpacing = carrier.SubcarrierSpacing;
    
    sss_demod = SSS_rcv.*conj(SSS_detect);
    sss_demod_mtx = reshape(sss_demod, Nsss,[]);
    tmp_mul_mtx = conj(sss_demod_mtx(:,1:end-1)).*sss_demod_mtx(:,2:end);
    tmp_mul = reshape(tmp_mul_mtx,1,[]);
    nAnt = 1;
    nParal = ceil(length(tmp_mul)/16);
    tmp_mul_add = [tmp_mul,zeros(nAnt,nParal*16-length(tmp_mul))];
    len = length(tmp_mul_add);
    s_tmp = zeros(nAnt, 16, nParal);
    
    for iAnt = 1:nAnt
        for iParal= 1:16
            index = iParal:16:len;
            s_tmp(iAnt, iParal,:)= tmp_mul_add(iAnt, index);    
        end
    end
    
    
    s_f=sum(s_tmp,3);%组内点和
    tmp=sum(s_f,2);%16点求和
    dfAng = angle(sum(tmp));
    dfAng_PerSymb= dfAng; %求出频偏引起的每个符号的相位累积量，这里面也包括了发端的相位补偿的部
    freq_offset = dfAng*(Nfft*SubcarrierSpacing)/(2*pi*(Nfft+Ncp));
end
