function filteredSig = DUC(filtTrans,hbFilter,cicCompFilter,CICUpsampRate,cicFilter)
% -------------------------------------------------------------------------
% Function: Upsample the original data to 20.48MHz baseband signal 
%
%    Input:	filtTrans：Subband filtered signal
%           hbFilter：A halfband filter object 
%           cicCompFilter：A CIC compensation filter object 
%           CICUpsampRate：Upsample rate of CIC interpolation filter
%           cicCompFilter：A CIC interpolation filter object 
%
%   Output:	filteredSig: 20.48MHz baseband signal
% -------------------------------------------------------------------------
    % HB filter
    Upsampe1 = upsample(filtTrans,2);
    UpsampeFilt1 = conv(Upsampe1,hbFilter.Coefficients);
    hbCompLen = hbFilter.FilterOrder/2+1;
    UpsampeFilt1 = UpsampeFilt1(hbCompLen:hbCompLen+length(Upsampe1)-1);

    % CIC compensation filter
    Upsampe2 = upsample(UpsampeFilt1,2);
    UpsampeFilt2 = conv(Upsampe2,cicCompFilter.Coefficients);
    cicCompCompLen = cicCompFilter.FilterOrder/2+1;
    UpsampeFilt2 = UpsampeFilt2(cicCompCompLen:cicCompCompLen+length(Upsampe2)-1);

    % CIC filter
    combParam = [1,-1];                                                     % Comb filter parameter 
    intParam = [1,-1];                                                      % Integrate filter parameter 
    cicGain = CICUpsampRate^(cicFilter.Order-1);
    cicDelay = ceil((cicFilter.Order/2)*(CICUpsampRate+1));
    filteredSigLen = CICUpsampRate*length(UpsampeFilt2);
    filteredSig = [UpsampeFilt2;zeros(cicFilter.Order,1)];
    for combidx = 1:cicFilter.Order
        filteredSig = filter(combParam,1,filteredSig);
    end
    
    Upsampe3 = upsample(filteredSig,CICUpsampRate);

    filteredSig = Upsampe3;
    for intidx = 1:cicFilter.Order
        filteredSig = filter(1,intParam,filteredSig);
    end
    filteredSig = filteredSig/cicGain;
    filteredSig = filteredSig(cicDelay+1:cicDelay+filteredSigLen);

end

