function data_out = ifft_4096_16bit_rsig(datain,size)

    shift=[1 0 0 0 1 1 0 0 0 0 0 0];
    
    % to invert the order
    data_temp0 = zeros(1,size);
    idx = zeros(1,size);
    prog = log2(size);
    
    for i=0:size-1
        bit_inverse = 0;
        for j = 0:prog-1
            if (bitand(i,2^j))
                bit_inverse =bit_inverse+2^(prog-1-j);
            end
        end
        idx(i+1)= bit_inverse;
        data_temp0(i+1) = datain(bit_inverse+1);
    end
    
    i = 0:size/2-1;
    w2_in1 = double(int16((cos(2*pi*i/size)+1i*sin(2*pi*i/size))*2^15));
    
    data_out = data_temp0;
    data_temp1 = zeros(1,size);
    for iprog = 1:prog
        wn = w2_in1(1:size/(2^iprog):end);
    
        for i = 1:size/(2^iprog)
            for i1 = 0:2^(iprog-1)-1
                k1 = (i-1)*2^iprog+1+i1;
                k2 = (i-1)*2^iprog+1+2^(iprog-1)+i1;
                k3 = i1+1;
                [data_temp1(k1),data_temp1(k2)] = IDFT2(data_out(k1),data_out(k2),wn(k3),shift(iprog));
            end
        end
        data_out = data_temp1;
    end

end



function [C,D] = IDFT2(A,B,W,shift)
    C = limit(2^15*A+W*B,16,-15-shift);
    D = limit(2^15*A-W*B,16,-15-shift);
end


