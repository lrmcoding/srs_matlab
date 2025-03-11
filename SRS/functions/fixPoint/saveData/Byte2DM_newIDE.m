function [] = Byte2DM_newIDE(filename,rx_RS_fixed)

    aaa = fopen(filename,'a');
    rx_RS_fixed = reshape(rx_RS_fixed,1,[]);
    rx_RS_fixed = [rx_RS_fixed zeros(1,ceil(length(rx_RS_fixed)/4)*4-length(rx_RS_fixed))];
    tmp0 = reshape(rx_RS_fixed,4,[]);
    tmp2 = reshape([tmp0(4,:);tmp0(3,:);tmp0(2,:);tmp0(1,:)],1,[]);
    a_R = mod(int32(tmp2)+2^8,2^8);
    a_R = reshape(a_R',[],1);
    b = bitand(a_R,255);
    fprintf(aaa,'0x%02x%02x%02x%02x,\n',b');
    fclose(aaa);
end

