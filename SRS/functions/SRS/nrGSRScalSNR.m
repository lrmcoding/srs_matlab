function [SNR_est,z_r_p_bar] = nrGSRScalSNR(sys,h_r_p_bar,txestsignal,rxestsignal)
carrier=sys.SRSCarrier;
srs=sys.SRS;

y_t_r_p_bar=zeros(1,srs.portNum,srs.N_PORT_SUBB*carrier.NSubcarrier);
y_r_p=zeros(1,srs.portNum,srs.N_PORT_SUBB*carrier.NSubcarrier);
z_r_p_bar=zeros(1,srs.portNum,srs.N_PORT_SUBB*carrier.NSubcarrier);
X_t_p=zeros(srs.portNum,srs.N_PORT_SUBB*carrier.NSubcarrier,srs.N_PORT_SUBB*carrier.NSubcarrier);
P_s_bar=zeros(srs.portNum,1);
derta_r_bar=zeros(srs.portNum,1);
SNR_est=zeros(srs.portNum,1);
for p=1:srs.portNum
    X_t_p(p,:,:)=diag(txestsignal((p-1)*srs.N_PORT_SUBB*carrier.NSubcarrier+1:p*srs.N_PORT_SUBB*carrier.NSubcarrier));
    h_t_r_p_bar=squeeze(h_r_p_bar(1,:,:)).';
    if srs.portNum==1%这里是因为matlab的squeeze对于1*1*40的矩阵没用
        y_t_r_p_bar(1,p,1:srs.N_PORT_SUBB*carrier.NSubcarrier)=        squeeze(X_t_p(p,:,:))*(h_t_r_p_bar(p,:).');
    else
        y_t_r_p_bar(1,p,1:srs.N_PORT_SUBB*carrier.NSubcarrier)=        squeeze(X_t_p(p,:,:))*(h_t_r_p_bar(:,p));
    end
    y_r_p(1,p,:)=rxestsignal(1+srs.N_PORT_SUBB*carrier.NSubcarrier*(p-1):srs.N_PORT_SUBB*carrier.NSubcarrier*p);
    z_r_p_bar(1,p,:)=y_r_p(1,p,:)-y_t_r_p_bar(1,p,:);


    P_s_bar(p)=sum(abs(y_t_r_p_bar(1,p,1:srs.N_PORT_SUBB*carrier.NSubcarrier)).^2);
    derta_r_bar(p)=sqrt(sum(abs(z_r_p_bar(1,p,:)).^2));
    SNR_est(p)=10*log10(P_s_bar(p)/(derta_r_bar(p)^2));
end

end


