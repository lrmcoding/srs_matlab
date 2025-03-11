function filterOutput = transFilter(transWaveform, lpFilter)
% -------------------------------------------------------------------------
% Function: Filter the transmission data through subband filter 
%
%    Input:	transWaveform£ºInput data of the filter
%           lpFilter£ºA filter configuration object
%                    Only these object properties are relevant for this function:
%                    Coefficients: Coefficients of the filter
%                    Compensation: Compensation length of filter
%
%   Output:	filterOutput: Output of the filter
% -------------------------------------------------------------------------

    filterCoefficients = lpFilter.Coefficients; 
    filteLen = length(filterCoefficients);
    compLen = ceil((filteLen-1)/2);                                         % Compensate for filter delay
    extraComp = -lpFilter.Compensation;                                     % Compensate for filter power
    filterInput = reshape(transWaveform,[],1);           
    totalOutput = conv(filterInput,filterCoefficients);
    filterOutput = totalOutput(compLen+1+extraComp:compLen+1+extraComp+length(filterInput)-1); 

end

