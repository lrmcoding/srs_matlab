function modSymb = nrGSymbolModulate(modOrder, inputBit)
% -------------------------------------------------------------------------
% Function: Symbol QAM Modulation
% 
%    Input:	modOrder: Modulation order, i.e. number of bits per symbol.
%           inputBit: Input bits sequence.
% 
%   Output:	modSymb: Modulated complex symbols sequence.
% -------------------------------------------------------------------------

    modTab = nrGGenQamModulationTable(modOrder);
    bitMat = reshape(inputBit, modOrder, []).';
    bitDecimal = bi2de(bitMat, 'left-msb');
    modSymb = modTab(bitDecimal + 1);
    modSymb = reshape(modSymb,[],1);
end