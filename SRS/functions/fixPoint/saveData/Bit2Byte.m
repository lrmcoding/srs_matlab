function [Bit] = Bit2Byte(tx_RS_fixed,size)

    Bit = zeros(1,ceil(size/8));
    tx_RS_fixed = [tx_RS_fixed, zeros(1,8*ceil(size/8)-size)];
    for i=1:ceil(size/8)
        for j=1:8
            Bit(i) = Bit(i)+tx_RS_fixed((i-1)*8+j)*(2^(j-1));
        end
    
    end
end

