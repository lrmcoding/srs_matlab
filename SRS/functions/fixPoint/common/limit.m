function [output] = limit(input,WordSize,shift)
% Limit the data according to wordsize

    max_tmp = bitshift(1,WordSize-1);
    Po_max = max_tmp-1;
    Ne_max = -max_tmp;
    
    
    input = double(input);
    out_tmp = floor(input*2^shift);
    
    for i=1:size(out_tmp,1)
        for j=1:size(out_tmp,2)
            I = real(out_tmp(i,j));
            Q = imag(out_tmp(i,j));
            if(I>Po_max)
                I = Po_max;
            end
    
            if(Q>Po_max)
                Q = Po_max;
            end
    
            if(I<Ne_max)
                I = Ne_max;
            end
    
            if(Q<Ne_max)
                Q = Ne_max;
            end
            out_tmp(i,j) = I+1j*Q;
        end
    end
    
    if WordSize == 8
        out_tmp = int8(out_tmp);
    elseif WordSize == 16
        out_tmp = int16(out_tmp);
    elseif WordSize == 32
        out_tmp = int32(out_tmp);
    elseif WordSize == 64
        out_tmp = int64(out_tmp);
    end
    
    output = double(out_tmp);

end

