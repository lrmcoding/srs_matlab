function [] = COMPLEX2DM_newIDE(filename,rx_RS_fixed)

    aaa = fopen(filename,'a+');
    a_R = mod(int32(real(rx_RS_fixed))+2^16,2^16);
    a_I = mod(int32(imag(rx_RS_fixed))+2^16,2^16);
    a_R = reshape(a_R',[],1);
    a_I = reshape(a_I',[],1);
    b = [bitshift(a_I,-8) bitand(a_I,255) bitshift(a_R,-8) bitand(a_R,255)];
    fprintf(aaa,'0x%02x%02x%02x%02x,\n',b');
    fclose(aaa);

end

