function filterOutput = recvFilter(recvSignal, lpFilter)
% -------------------------------------------------------------------------
% Function: Filter the received data through subband filter 
%
%    Input:	recvSignal��Input data of the filter
%           lpFilter��A filter configuration object
%                    Only these object properties are relevant for this function:
%                    Coefficients: Coefficients of the filter
%
%   Output:	filterOutput: Output of the filter
% -------------------------------------------------------------------------

    filterCoefficients = lpFilter.Coefficients; 
    filteLen = length(filterCoefficients);
    compLen = ceil((filteLen-1)/2);                                         % Compensate for filter delay
    filterInput = reshape(recvSignal,[],1);           
    totalOutput = conv(filterInput,filterCoefficients);
    filterOutput = totalOutput(compLen+1:compLen+1+length(filterInput)-1); 
    filterOutput = reshape(filterOutput,[],1);

end

