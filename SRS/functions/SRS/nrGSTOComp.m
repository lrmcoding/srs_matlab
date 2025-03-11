function [h_r_p_denoise_bar] = nrGSTOComp(sys,h_r_p,tao_p_mean)
carrier=sys.SRSCarrier;
srs=sys.SRS;
h_r_p_denoise_bar=zeros(1,srs.portNum,srs.N_PORT_SUBB);%3个维度分别是r,p,子带上的信道测量值均值

for p=1:srs.portNum
    for subb=1:srs.N_PORT_SUBB
        for k=0:9-1
            h_r_p_denoise_bar(1,p,subb)=h_r_p_denoise_bar(1,p,subb)+h_r_p(1,p,k+1+(subb-1)*carrier.NSubcarrier)*exp(complex(0,1)*2*pi*tao_p_mean(p)*k/carrier.NFFT);
        end
    end
end
h_r_p_denoise_bar=h_r_p_denoise_bar./9;
end

