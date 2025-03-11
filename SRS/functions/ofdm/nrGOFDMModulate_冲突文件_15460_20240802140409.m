function waveform = nrGOFDMModulate(carrier, resGrid)
% -------------------------------------------------------------------------
% Function: OFDM modulation
%
%    Input:	carrier: A carrier configuration object
%                    Only these object properties are relevant for this function:
%                    NFFT: Number of IFFT points used in the OFDM modulator
%                    DwSymbolsPerSlot: Number of OFDM symbols in a slot
%                    CyclicPrefixLength: Cyclic prefix length (in samples) of each OFDM symbol in a slot
%           resGrid: Resource grid
%
%   Output:	waveform: Time-domain samples in the waveform.
% -------------------------------------------------------------------------


    NFFT = carrier.NFFT;
    SymbolsPerSlot = carrier.DwSymbolsPerSlot;
    CPLen = carrier.CyclicPrefixLength;
    NSamps = sum(CPLen) + NFFT * SymbolsPerSlot;    % Number of time-domain samples in a slot
    waveform = zeros(NSamps,1);
    
    sampInd = 0;    % Indice of time-domain samples in a slot
    for symbInd = 1 : SymbolsPerSlot 
        % OFDM modulate
        modedSymb = sqrt(NFFT)*ifft(ifftshift(resGrid(:,symbInd)));

        % Add CP for each symbol 
        CPsamps = modedSymb(end-CPLen(symbInd)+1:end);
        waveform(sampInd+1:sampInd+CPLen(symbInd)+NFFT) = [CPsamps;modedSymb];
        sampInd = sampInd+NFFT+CPLen(symbInd);
    end
end

