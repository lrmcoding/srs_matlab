function h_r_p_bar = nrGSTOAntiComp(sys,h_r_p_denoise_bar,tao_p_mean)
carrier=sys.SRSCarrier;
srs=sys.SRS;
h_r_p_bar=zeros(1,srs.portNum,srs.N_PORT_SUBB*carrier.NSubcarrier);%时偏反补偿后的h_r_p
for p=1:srs.portNum
    for subb=1:srs.N_PORT_SUBB
        for k=0:9
            h_r_p_bar(1,p,k+1+(subb-1)*carrier.NSubcarrier)=h_r_p_denoise_bar(1,p,subb)*exp(complex(0,-1)*2*pi*tao_p_mean(p)*k/carrier.NFFT);
        end
    end
end
end

