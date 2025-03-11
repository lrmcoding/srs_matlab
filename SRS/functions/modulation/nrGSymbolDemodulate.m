function demodLLR = nrGSymbolDemodulate(modOrder, rxSymb, sigma2)
% -------------------------------------------------------------------------
% Function: Soft demodulation for PSK/APSK.
% 
%    Input: modOrder: Modulation order.
%           rxSymb: Received modulated complex symbols.
%           sigma2: Estimated noise variance of each symbol.
% 
%   Output: demodLLR: Output Log-Likelihood Ratio after demodulation.
% -------------------------------------------------------------------------

    if numel(sigma2) == 1   % Hard input sigma2
         sigma2 = ones(size(rxSymb)) * sigma2;
    end
    
    modTab = nrGGenQamModulationTable(modOrder);
    demodLLR = zeros(1, numel(rxSymb) * modOrder);
    
    demodTabLen = 2 ^ modOrder;
    S0 = zeros(modOrder, demodTabLen / 2);
    S1 = zeros(modOrder, demodTabLen / 2);
    
    for bitIdx = 1 : modOrder
        S0(modOrder - bitIdx + 1, :) = find(bitand(0 : demodTabLen - 1, 2^(bitIdx - 1)) == 0);
        S1(modOrder - bitIdx + 1, :) = find(bitand(0 : demodTabLen - 1, 2^(bitIdx - 1)) ~= 0);
    end
    
    %%
    % Approximate LLR
    for symbIdx = 1 : numel(rxSymb)
        for bitIdx = 1 : modOrder
            D0 = min(abs(rxSymb(symbIdx) - modTab(S0(bitIdx, :))).^2);
            D1 = min(abs(rxSymb(symbIdx) - modTab(S1(bitIdx, :))).^2);
            demodLLR(bitIdx + modOrder * (symbIdx - 1)) = (1 / sigma2(symbIdx)) * (D1 - D0);
        end    
    end
    
    demodLLR = (demodLLR).';

end