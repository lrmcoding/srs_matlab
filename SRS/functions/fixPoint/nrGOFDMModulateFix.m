function waveform = nrGOFDMModulateFix(carrier, resGrid)
% -------------------------------------------------------------------------
% Function: Fixed point OFDM modulation
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
    waveform = zeros(1,NSamps);
    
    path = 'D:\BaiduSyncdisk\毕业设计\codes\SSB\SSB0522\results\IFFT\1.txt';
    sampInd = 0;    % Indice of time-domain samples in a slot
    for symbInd = 1 : SymbolsPerSlot 
        % Fixed OFDM modulate
        fixedModedSymb = ifft_4096_16bit_rsig(ifftshift(resGrid(:,symbInd)),NFFT);
%         modedSymb = sqrt(NFFT)*ifft(ifftshift(resGrid(:,symbInd)));

        % Add CP for each symbol 
        CPsamps = fixedModedSymb(end-CPLen(symbInd)+1:end);
        waveform(sampInd+1:sampInd+CPLen(symbInd)+NFFT) = [CPsamps,fixedModedSymb];
        sampInd = sampInd+NFFT+CPLen(symbInd);
    end
    waveform = reshape(waveform,[],1);
end

