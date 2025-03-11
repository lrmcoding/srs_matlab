function [tao_p_mean,h_r_p] = nrGSRSCalTA(sys,H_ls)
carrier=sys.SRSCarrier;
srs = sys.SRS;

derta=3;
xita_r_p=zeros(1,srs.portNum,srs.N_PORT_SUBB);%3个维度分别是r,p,子带
tao_p=zeros(srs.portNum,srs.N_PORT_SUBB);%2个维度分别是p,子带
tao_p_mean=zeros(srs.portNum,1);

h_r_p=zeros(1,srs.portNum,srs.N_PORT_SUBB*carrier.NSubcarrier);%3个维度分别是r,p,信道测量值


for p=1:srs.portNum
    h_r_p(1,p,:)=H_ls(1+srs.N_PORT_SUBB*carrier.NSubcarrier*(p-1):srs.N_PORT_SUBB*carrier.NSubcarrier*p);
    for subb=1:srs.N_PORT_SUBB      %对于每个子带
        for k=0:9-derta-1
            xita_r_p(1,p,subb)=xita_r_p(1,p,subb)+h_r_p(k+1+(subb-1)*carrier.NSubcarrier)*ctranspose(h_r_p(k+1+(subb-1)*carrier.NSubcarrier+derta));
        end
        xita_r_p(1,p,subb)= complex(0, -1)*xita_r_p(1,p,subb);%式3.14
        tao_p(p,subb)=angle(complex(0, 1)*xita_r_p(1,p,subb))*carrier.NFFT/(2*pi*derta);%式3.15
    end
    tao_p_mean(p)=mean(tao_p(p,:));
end

end

