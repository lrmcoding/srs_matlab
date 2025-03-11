% Main function of PBCH chain
clc
clear
close all
addpath(genpath('./functions'));
% rng(0)

%% System parameters initiallization
sysParameters = ULParam();

%% Simulation parameters initiallization
global simParameters                                                        % Create simParameters variable to contain all key simulation parameters
simParameters.NSRS                      = 1;                              % Number of SIBs
simParameters.SNRIn                     = 30;                               % SNR range (dB)
% simParameters.delayMax                  = 10*128;                            % Max delay of SRS
 simParameters.delayMax                  = 0;                            % Max delay of SRS
simParameters.PerfectChannelEstimator   = true;                             % Perfect channel estimation flag


sys = sysParameters;
srs = sys.SRS;
srscarrier = sys.SRSCarrier;
basebandcarrier = sys.BasebandCarrier;
srsFilter = sys.SRSFilter;
ncellid = sys.NCellID;
syn = sys.Syn;
SNRdB = simParameters.SNRIn;
SNR = 10^(SNRdB/10);

% SRS
[SRSTransWaveform,SRS,k_range,l_range]=nrGSRSBaseSig(sys);

%
% figure();
% imagesc([0.5 l_range-0.5],[0 40-1],abs(SRS));%这里设置为0.5是为了画图好看
% axis xy;

% transPow1 = mean(abs(SRSTransWaveform).^2);

% figure();
% plot(abs(SRSTransWaveform));

% Transmitting subband filtering
srs_samplepoint_2slot=(srscarrier.NFFT+srscarrier.CyclicPrefixLength(1))*(srscarrier.UwSymbolsFirstSlot+srscarrier.UwSymbolsSecondfSlot);
% srs_samplepoint_firstslot=(srscarrier.NFFT+srscarrier.CyclicPrefixLength(1))*(srscarrier.UwSymbolsFirstSlot);
% srs_samplepoint_secondslot=(srscarrier.NFFT+srscarrier.CyclicPrefixLength(1))*(srscarrier.UwSymbolsSecondfSlot);
srs_slot_num=length(SRSTransWaveform)/srs_samplepoint_2slot;
SRSTransWaveform_2slot=reshape(SRSTransWaveform,srs_samplepoint_2slot,srs_slot_num);
% % figure();
% % pspectrum(SRSTransWaveform_slot(:,1),160000);
% filtTransSRS_firstslot=zeros(srs_samplepoint_firstslot,srs_slot_num);
% filtTransSRS_secondslot=zeros(srs_samplepoint_secondslot,srs_slot_num);
% 
% for i=1:srs_slot_num
%     filtTransSRS_firstslot(:,i) = transFilter(SRSTransWaveform_2slot(1:srs_samplepoint_firstslot,i), srsFilter);
% end
% filtTransSRS_2slot=[filtTransSRS_firstslot;filtTransSRS_secondslot];
% figure();
% pspectrum(filtTransSRS_firstslot(:,1),160000);
% 
% filtTransSRS=reshape(filtTransSRS_2slot,srs_samplepoint_2slot*srs_slot_num,1);



% figure();
% pspectrum(SRSTransWaveform_2slot(:,1),160000);
filtTransSRS_2slot=zeros(srs_samplepoint_2slot,srs_slot_num);
for i=1:srs_slot_num
    filtTransSRS_2slot(:,i) = transFilter(SRSTransWaveform_2slot(:,i), srsFilter);
end
% figure();
% pspectrum(filtTransSRS_slot(:,1),160000);

filtTransSRS=reshape(filtTransSRS_2slot,srs_samplepoint_2slot*srs_slot_num,1);
% % figure();
% % plot(abs(filtTransSRS));
% transPow2 = mean(abs(filtTransSRS).^2);




% % figure();
% % plot(abs(filtTransSRS));
% transPow2 = mean(abs(filtTransSRS).^2);


% DUC
upFiltTransSRS = resample(filtTransSRS,basebandcarrier.SampleRate/srscarrier.SampleRate,1);
% figure();
% pspectrum(upFiltTransSRS,20480000);
% transPow3 = mean(abs(upFiltTransSRS).^2);


%mix
upFiltTransSRS_2slot=reshape(upFiltTransSRS,length(upFiltTransSRS)/srs_slot_num*2,srs_slot_num/2);
t = 0:length(upFiltTransSRS)/srs_slot_num*2-1;
for i=0:srs_slot_num/2-1

    f_carrier = i*40;
    carrier_signal = exp(1j*2*pi*f_carrier*t/basebandcarrier.NFFT);  % 载波信号
    upFiltTransSRS_2slot(:,i+1) = upFiltTransSRS_2slot(:,i+1).*(carrier_signal.');

end
upFiltTransSRS=reshape(upFiltTransSRS_2slot,length(upFiltTransSRS),1);

% transPow4 = mean(abs(upFiltTransSRS).^2);

% figure();
% pspectrum(upFiltTransSRS_2slot,20480000);



% P1 = mean(abs(upFiltTransSRS).^2);
% Go through AWGN channel
simParameters.validFreq = 22.5e3*4;

[recvSig, noisePow, timeOffset, freqOffset] = nrGAWGNChannel(basebandcarrier, upFiltTransSRS, SNR, syn);
% figure();
% plot(abs(recvSig));

% transPow5 = mean(abs(recvSig).^2);

% mix
recvSig_2slot=reshape(recvSig,length(recvSig)/srs_slot_num*2,srs_slot_num/2);
t = 0:length(recvSig)/srs_slot_num*2-1;
for i=0:srs_slot_num/2-1

    f_carrier = i*40;
    carrier_signal = exp(-1j*2*pi*f_carrier*t/basebandcarrier.NFFT);  % 载波信号
    recvSig_2slot(:,i+1) = recvSig_2slot(:,i+1).*(carrier_signal.');

end
recvSig=reshape(recvSig_2slot,length(recvSig),1);

% transPow6 = mean(abs(recvSig).^2);

% DDC
downRecvSig = resample(recvSig,1,basebandcarrier.SampleRate/srscarrier.SampleRate);

% transPow7 = mean(abs(downRecvSig).^2);
%
% figure();

% pspectrum(downRecvSig);

% % lowpass filtering
% downRecvSig_slot=reshape(downRecvSig,srs_samplepoint_slot,srs_slot_num);
% % figure();
% % pspectrum(downRecvSig_slot(:,1),160000);
% filtRecvsSRS_slot=zeros(srs_samplepoint_slot,srs_slot_num);
% for i=1:srs_slot_num
%     filtRecvsSRS_slot(:,i) = recvFilter(downRecvSig_slot(:,i), srsFilter);
% end
% % figure();
% % pspectrum(filtRecvsSRS_slot(:,1),160000);
% filtRecvsSRS=reshape(filtRecvsSRS_slot,srs_samplepoint_slot*srs_slot_num,1);
% % figure();
% % plot(abs(filtTransSRS));
%
% % P2 = mean(abs(filtRecvsSRS).^2);
% transPow8 = mean(abs(filtRecvsSRS).^2);

% OFDM demodulation
SRSGrid = nrGOFDMDemodulateSRS(srscarrier,downRecvSig);
% SRSGrid = nrGOFDMDemodulateSRS(srscarrier,filtTransSRS);

% figure();
% imagesc([0.5 l_range-0.5],[0 64-1],abs(SRSGrid));%这里设置为0.5是为了画图好看
% axis xy;



%% LS channel estimation
if(srs.portNum*srs.N_PORT_SUBB==4)
    rxestsignal=SRSGrid(13:52,6);
    txestsignal=SRS(:,6);
elseif(srs.portNum*srs.N_PORT_SUBB==8)
    rxestsignal=[SRSGrid(13:52,6);SRSGrid(13:52,28)];
    txestsignal=[SRS(:,6);SRS(:,28)];
elseif(srs.portNum*srs.N_PORT_SUBB==16)
    rxestsignal=[SRSGrid(13:52,6);SRSGrid(13:52,28);SRSGrid(13:52,50);SRSGrid(13:52,72)];
    txestsignal=[SRS(:,6);SRS(:,28);SRS(:,50);SRS(:,72)];
end
scatterplot(txestsignal);
scatterplot(rxestsignal);


H_ls=zeros(length(rxestsignal),1);
for i=1:length(rxestsignal)
    if txestsignal(i)~=0
        H_ls(i) = rxestsignal(i)/txestsignal(i);
    end
end

% Time offset estimation
[tao_p_mean,h_r_p]=nrGSRSCalTA(sys,H_ls);

% Time offset compensation
h_r_p_denoise_bar=nrGSTOComp(sys,h_r_p,tao_p_mean);

% Anti Time offset compensation
h_r_p_bar=nrGSTOAntiComp(sys,h_r_p_denoise_bar,tao_p_mean);

%SNR cal
[SNR_est,z_r_p_bar] = nrGSRScalSNR(sys,h_r_p_bar,txestsignal,rxestsignal);

%RI,TPMI cal
[RIbest,PMIbest] = nrGSRScalRITPMI(sys,h_r_p_bar,z_r_p_bar);