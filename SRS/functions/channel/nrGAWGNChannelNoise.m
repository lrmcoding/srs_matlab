function [recvSig, noisePow] = nrGAWGNChannelNoise(tranSig, snrLinear)
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
transPow = 1;
compFactor = 1;                                                  % Compensation factor
noisePow = compFactor*transPow/snrLinear;  
noise = ...
    sqrt(noisePow/2)*complex(randn(size(tranSig)),randn(size(tranSig)));
recvSig = noise;

end

