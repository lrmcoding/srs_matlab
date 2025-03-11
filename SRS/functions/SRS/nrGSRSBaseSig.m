function [SRSTransWaveform,SRS,k_range,l_range]= nrGSRSBaseSig(sys)
carrier=sys.SRSCarrier;
[SRS,k_range,l_range]=nrGSRSGrid(sys);
% figure();
% imagesc([0.5 l_range-0.5],[0 k_range-1],abs(SRS));%这里设置为0.5是为了画图好看
% axis xy;
SRStxGrid=zeros(carrier.NFFT,l_range);
SRStxGrid((carrier.NFFT/2 - floor(40/2) + 1):(carrier.NFFT/2 + ceil(40/2)),1:l_range) = SRS;
NFFT = carrier.NFFT;
SymbolsFirstSlot = carrier.UwSymbolsFirstSlot;
SymbolsSecondSlot = carrier.UwSymbolsSecondfSlot;
CPLen = carrier.CyclicPrefixLength;
NSamps = sum(CPLen) + 2*NFFT * (SymbolsFirstSlot+SymbolsSecondSlot)*carrier.N_cycle;    % Number of time-domain samples in a slot
SRSTransWaveform = zeros(NSamps,1);
sampInd = 0;    % Indice of time-domain samples in a slot
for symbInd = 1 : 2*(SymbolsFirstSlot+SymbolsSecondSlot) *carrier.N_cycle
    % OFDM modulate
    modedSymb = sqrt(NFFT)*ifft(ifftshift(SRStxGrid(:,symbInd)));

    % Add CP for each symbol
    CPsamps = modedSymb(end-CPLen(symbInd)+1:end);
    SRSTransWaveform(sampInd+1:sampInd+CPLen(symbInd)+NFFT) = [CPsamps;modedSymb];
    sampInd = sampInd+NFFT+CPLen(symbInd);
end
end

