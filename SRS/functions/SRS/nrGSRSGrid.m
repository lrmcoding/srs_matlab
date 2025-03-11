function [a_klp,k_range,l_range] = nrGSRSGrid(sys)
carrier=sys.SRSCarrier;
srs = sys.SRS;
srs.N_PORT_SUBB

k_range=carrier.NSubband*carrier.NSubcarrier;
l_range=carrier.N_cycle*(carrier.UwSymbolsFirstSlot+carrier.UwSymbolsSecondfSlot)*2;
a_klp=zeros(40,l_range);
l=5;
for k_bar=0:4*srs.N_PORT_SUBB/4*srs.portNum*carrier.NSubcarrier:(carrier.NSubband-4)*carrier.NSubcarrier
    for i=0:srs.portNum-1
        for Lambda=0:srs.N_PORT_SUBB-1
            r_Lambda_v=nrGSRS(Lambda,srs.v);
            for k_pie=0:(carrier.NSubcarrier-2)
                k=mod(k_bar+(Lambda+srs.N_PORT_SUBB*i)*carrier.NSubcarrier+k_pie,40);
                if srs.N_PORT_SUBB/4*srs.portNum==1
                    l_bar=0*22;
                elseif srs.N_PORT_SUBB/4*srs.portNum==2&&srs.portNum==4
                    l_bar=floor(i/2)*22;
                elseif srs.N_PORT_SUBB/4*srs.portNum==2&&srs.portNum==2
                    l_bar=i*22;
                elseif srs.N_PORT_SUBB/4*srs.portNum==4
                    l_bar=i*22;
                end
                a_klp(k+1,l+l_bar+1)=r_Lambda_v(k_pie+1);
            end
        end
    end
    l=l+(carrier.UwSymbolsFirstSlot+carrier.UwSymbolsSecondfSlot)*2*srs.N_PORT_SUBB/4*srs.portNum;
end
%加偏置
new_order = [srs.SUB_offset*2*(carrier.UwSymbolsFirstSlot+carrier.UwSymbolsSecondfSlot)+1:l_range, 1:srs.SUB_offset*2*(carrier.UwSymbolsFirstSlot+carrier.UwSymbolsSecondfSlot)];
a_klp=a_klp(:,new_order);
end

