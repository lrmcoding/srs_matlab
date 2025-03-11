function [C] = mac(A,B,WordSize,shift)

% 复数定点乘法
if WordSize == 8
    A = int8(A);
    B = int8(B);
elseif WordSize == 16
    A = int16(A);
    B = int16(B);
elseif WordSize == 32
    A = int32(A);
    B = int32(B);
elseif WordSize == 64
    A = int64(A);
    B = int64(B);
end

a = double(real(A));
b = double(imag(A));
c = double(real(B));
d = double(imag(B));

R = limit(a.*c-b.*d,WordSize,shift);
I = limit(a.*d+b.*c,WordSize,shift);

C = double(R)+1i*double(I);


