function resGrid = nrGOFDMDemodulate(carrier,waveform)
% -------------------------------------------------------------------------
% Function: OFDM modulation
%
%    Input:	carrier: A carrier configuration object
%                    Only these object properties are relevant for this function:
%                    NFFT: Number of IFFT points used in the OFDM modulator
%                    DwSymbolsPerSlot: Number of OFDM symbols in a slot
%                    CyclicPrefixLength: Cyclic prefix length (in samples) of each OFDM symbol in a slot
%                    CyclicSuffixLength: Cyclic suffix length (in samples) of OFDM symbol
%           waveform: Time-domain samples in the waveform.
%
%   Output:	resGrid: Resource grid
% -------------------------------------------------------------------------

    global simParameters

    OFDMSymbols = simParameters.OFDMSymbols;
    NFFT = carrier.NFFT;   
    CPLen = carrier.CyclicPrefixLength;
    postCP = carrier.CyclicSuffixLength;
    resGrid = zeros(NFFT,OFDMSymbols);
    
    sampInd = 0;    % Indice of time-domain samples in a slot
    for symbInd = 1 : OFDMSymbols 
        % Remove CP for each symbol 
        symbSamps = waveform(sampInd+1:sampInd+CPLen(symbInd)+NFFT); 
        dataRemoveCP = symbSamps(CPLen(symbInd)+1:end);                    
        CSSamps = dataRemoveCP(1:postCP);   % Cyclic suffix samples
        dataSymbSamps = [dataRemoveCP(postCP+1:end);CSSamps];   % Time delay compensation
        sampInd = sampInd+NFFT+CPLen(symbInd);

        % OFDM modulate
        resGrid(:,symbInd) = 1/sqrt(NFFT)*fftshift(fft(dataSymbSamps));
    end
end


