function [recvSig, noisePow, timeOffset, freqOffset] = nrGAWGNChannel(carrier, tranSig, snrLinear,syn)
% -------------------------------------------------------------------------
% Function: Add AWGN to signal
%
%    Input:	carrier: A carrier configuration object
%                    Only these object properties are relevant for this function:
%                    SubbandSpacing: Subcarrier space
%                    SampleRate: Sample rate of a single subband
%                    Nsubband: Number of subband
%           tranSig: Transmitting signal
%           snrLinear£ºLinear SNR
%           syn: MaxFreqOffset: Maximum frequency offset of the channel
%
%   Output:	recvSig: Noised signal
%           noisePow: Noise power
%           timeOffset£ºChannel time offset
%           freqOffset£ºChannel frequency offset
% -------------------------------------------------------------------------

global simParameters
fs = carrier.SampleRate;
validFreq = simParameters.validFreq;                                        % Valid signal frequency range
transPow = mean(abs(tranSig(tranSig~=0)).^2);                               % Transmitting signal power
compFactor = fs/validFreq;                                                  % Compensation factor
noisePow = compFactor*transPow/snrLinear;  

timeDelayMax = simParameters.delayMax;
timeOffset = randi([0,timeDelayMax]);
% timeOffset = 20;

recvSig = zeros(simParameters.rxLen,1);
recvSig(timeOffset+1:timeOffset+length(tranSig)) = tranSig;
recvSig = recvSig.';

maxFreqOffset = ceil(syn.MaxFreqOffset); 
freqOffset = maxFreqOffset-rand()*2*maxFreqOffset;
% freqOffset = 0;
recvSig = recvSig.*exp(1i*2*pi*freqOffset*(0:length(recvSig)-1)/fs);

noise = ...
    sqrt(noisePow/2)*complex(randn(size(recvSig.')),randn(size(recvSig.')));

recvSig = recvSig.' + noise;
end

