function [recvSig, noisePow, timeOffset, freqOffset] = nrGAWGNChannelnotf(carrier, tranSig, snrLinear,syn)
% -------------------------------------------------------------------------
% Function: Add AWGN to signal
%
%    Input:	carrier: A carrier configuration object
%                    Only these object properties are relevant for this function:
%                    SubbandSpacing: Subcarrier space
%                    SampleRate: Sample rate of a single subband
%                    Nsubband: Number of subband
%           tranSig: Transmitting signal
%           snrLinear：Linear SNR
%           syn: MaxFreqOffset: Maximum frequency offset of the channel
%
%   Output:	recvSig: Noised signal
%           noisePow: Noise power
%           timeOffset：Channel time offset
%           freqOffset：Channel frequency offset
% -------------------------------------------------------------------------

scs = carrier.SubcarrierSpacing;
fs = carrier.SampleRate;
NSubcarrier = carrier.NSubcarrier;
validFreq = (NSubcarrier)*scs;                                                 % Valid signal frequency range
transPow = mean(bandpower(tranSig.',fs,[-validFreq/2 validFreq/2]));        % Transmitting signal power
compFactor = fs/validFreq;                                                  % Compensation factor
noisePow = compFactor*transPow/snrLinear;  

timeDelayMax = 200;
timeOffset = randi([1,timeDelayMax]);
timeOffset = 0;

xQPSK = ((2*randi(2,1,1000)-3) + 1i*(2*randi(2,1,1000)-3))/sqrt(2);
recvSig = [xQPSK(:,end-timeOffset+1:end) tranSig.' xQPSK(:,1:timeDelayMax-timeOffset)];

maxFreqOffset = ceil(syn.MaxFreqOffset); 
freqOffset = maxFreqOffset-rand()*2*maxFreqOffset;
freqOffset = 0;
recvSig = recvSig.*exp(1i*2*pi*freqOffset*(0:length(recvSig)-1)/fs);

noise = ...
    sqrt(noisePow/2)*complex(randn(size(recvSig.')),randn(size(recvSig.')));

recvSig = recvSig.' + noise;
end

