function [RIbest,PMIbest] = nrGSRScalRITPMI(sys,h_r_p_bar,z_r_p_bar)

carrier=sys.SRSCarrier;
srs = sys.SRS;
switch srs.portNum
    case 1
        PMIbest=0;
        RIbest=0;
    case 2
        for p=1:srs.portNum
            for RI=1:2
                if RI==1
                    Mutual_I_total_1_2=zeros(1,6);
                    load("precodematrix1_2.mat");
                    for TPMI=0:5
                        W=W_all(:,TPMI+1);
                        for k=1:srs.N_PORT_SUBB*carrier.NSubcarrier
                            H_r_p = h_r_p_bar(:,:,k);
                            %derta_z2=abs(z_r_p_bar(1,p,k))^2/abs(y_r_p(1,p,k))^2;
                            derta_z2=abs(z_r_p_bar(1,p,k))^2;
                            G=inv((H_r_p*W)'*H_r_p*W+derta_z2*eye(RI))*(H_r_p*W)';
                            K=G*H_r_p*W;
                            SINR=zeros(RI,1);
                            for l=1:RI
                                SINR(l)=abs(K(l,l))^2/((sum(abs(K(l,:)).^2)-abs(K(l,l))^2)+derta_z2*sum(abs(G(l,:)).^2));

                            end
                            Mutual_I=sum(log2(1+SINR(:)));
                            Mutual_I_total_1_2(RI,TPMI+1)=Mutual_I_total_1_2(RI,TPMI+1)+Mutual_I;
                        end
                    end


                elseif RI==2
                    Mutual_I_total_2_2=zeros(2,3);%为了直接把互信息矩阵最大值的下标拿来当作最优的PMI和RI，这里第一行空出来
                    load("precodematrix2_2.mat");
                    for TPMI=0:2
                        W=W_all(:,2*TPMI+1:2*TPMI+2);
                        for k=1:srs.N_PORT_SUBB*carrier.NSubcarrier
                            H_r_p = h_r_p_bar(:,:,k);
                            derta_z2=abs(z_r_p_bar(1,p,k))^2;
                            G=inv((H_r_p*W)'*H_r_p*W+derta_z2*eye(RI))*(H_r_p*W)';
                            K=G*H_r_p*W;
                            SINR=zeros(RI,1);
                            for l=1:RI
                                SINR(l)=abs(K(l,l))^2/((sum(abs(K(l,:)).^2)-abs(K(l,l))^2)+derta_z2*sum(abs(G(l,:)).^2));

                            end
                            Mutual_I=sum(log2(1+SINR(:)));
                            Mutual_I_total_2_2(RI,TPMI+1)=Mutual_I_total_2_2(RI,TPMI+1)+Mutual_I;
                        end
                    end
                end


            end
        end
        Mutual_I_total_1_2_vec = Mutual_I_total_1_2(:);
        Mutual_I_total_2_2_vec = Mutual_I_total_2_2(:);

        all_Mutual_I = [Mutual_I_total_1_2_vec; Mutual_I_total_2_2_vec];
        [max_Mutual_I_total, linear_index] = max(all_Mutual_I);
        matrix_idx = find([length(Mutual_I_total_1_2_vec), length(Mutual_I_total_2_2_vec)] >= linear_index, 1);
        switch matrix_idx
            case 1
                [RIbest, PMIbest] = ind2sub(size(Mutual_I_total_1_2), linear_index);
            case 2
                [RIbest, PMIbest] = ind2sub(size(Mutual_I_total_2_2), linear_index);

        end
    case 4
        for p=1:srs.portNum
            for RI=1:4
                if RI==1
                    Mutual_I_total_1_4=zeros(1,28);
                    load("precodematrix1_4.mat");
                    for TPMI=0:27
                        W=W_all(:,TPMI+1);
                        for k=1:srs.N_PORT_SUBB*carrier.NSubcarrier
                            H_r_p = h_r_p_bar(:,:,k);
                            %derta_z2=abs(z_r_p_bar(1,p,k))^2/abs(y_r_p(1,p,k))^2;
                            derta_z2=abs(z_r_p_bar(1,p,k))^2;
                            G=inv((H_r_p*W)'*H_r_p*W+derta_z2*eye(RI))*(H_r_p*W)';
                            K=G*H_r_p*W;
                            SINR=zeros(RI,1);
                            for l=1:RI
                                SINR(l)=abs(K(l,l))^2/((sum(abs(K(l,:)).^2)-abs(K(l,l))^2)+derta_z2*sum(abs(G(l,:)).^2));

                            end
                            Mutual_I=sum(log2(1+SINR(:)));
                            Mutual_I_total_1_4(RI,TPMI+1)=Mutual_I_total_1_4(RI,TPMI+1)+Mutual_I;
                        end
                    end


                elseif RI==2
                    Mutual_I_total_2_4=zeros(2,22);%为了直接把互信息矩阵最大值的下标拿来当作最优的PMI和RI，这里第一行空出来
                    load("precodematrix2_4.mat");
                    for TPMI=0:21
                        W=W_all(:,2*TPMI+1:2*TPMI+2);
                        for k=1:srs.N_PORT_SUBB*carrier.NSubcarrier
                            H_r_p = h_r_p_bar(:,:,k);
                            derta_z2=abs(z_r_p_bar(1,p,k))^2;
                            G=inv((H_r_p*W)'*H_r_p*W+derta_z2*eye(RI))*(H_r_p*W)';
                            K=G*H_r_p*W;
                            SINR=zeros(RI,1);
                            for l=1:RI
                                SINR(l)=abs(K(l,l))^2/((sum(abs(K(l,:)).^2)-abs(K(l,l))^2)+derta_z2*sum(abs(G(l,:)).^2));

                            end
                            Mutual_I=sum(log2(1+SINR(:)));
                            Mutual_I_total_2_4(RI,TPMI+1)=Mutual_I_total_2_4(RI,TPMI+1)+Mutual_I;
                        end
                    end
                elseif RI==3
                    Mutual_I_total_3_4=zeros(3,7);%为了直接把互信息矩阵最大值的下标拿来当作最优的PMI和RI，这里第一行空出来
                    load("precodematrix3_4.mat");
                    for TPMI=0:6
                        W=W_all(:,3*TPMI+1:3*TPMI+3);
                        for k=1:srs.N_PORT_SUBB*carrier.NSubcarrier
                            H_r_p = h_r_p_bar(:,:,k);
                            derta_z2=abs(z_r_p_bar(1,p,k))^2;
                            G=inv((H_r_p*W)'*H_r_p*W+derta_z2*eye(RI))*(H_r_p*W)';
                            K=G*H_r_p*W;
                            SINR=zeros(RI,1);
                            for l=1:RI
                                SINR(l)=abs(K(l,l))^2/((sum(abs(K(l,:)).^2)-abs(K(l,l))^2)+derta_z2*sum(abs(G(l,:)).^2));

                            end
                            Mutual_I=sum(log2(1+SINR(:)));
                            Mutual_I_total_3_4(RI,TPMI+1)=Mutual_I_total_3_4(RI,TPMI+1)+Mutual_I;
                        end
                    end
                elseif RI==4
                    Mutual_I_total_4_4=zeros(4,5);%为了直接把互信息矩阵最大值的下标拿来当作最优的PMI和RI，这里第一行空出来
                    load("precodematrix4_4.mat");
                    for TPMI=0:4
                        W=W_all(:,4*TPMI+1:4*TPMI+4);
                        for k=1:srs.N_PORT_SUBB*carrier.NSubcarrier
                            H_r_p = h_r_p_bar(:,:,k);
                            derta_z2=abs(z_r_p_bar(1,p,k))^2;
                            G=inv((H_r_p*W)'*H_r_p*W+derta_z2*eye(RI))*(H_r_p*W)';
                            K=G*H_r_p*W;
                            SINR=zeros(RI,1);
                            for l=1:RI
                                SINR(l)=abs(K(l,l))^2/((sum(abs(K(l,:)).^2)-abs(K(l,l))^2)+derta_z2*sum(abs(G(l,:)).^2));

                            end
                            Mutual_I=sum(log2(1+SINR(:)));
                            Mutual_I_total_4_4(RI,TPMI+1)=Mutual_I_total_4_4(RI,TPMI+1)+Mutual_I;
                        end
                    end
                end


            end
        end
        Mutual_I_total_1_4_vec = Mutual_I_total_1_4(:);
        Mutual_I_total_2_4_vec = Mutual_I_total_2_4(:);
        Mutual_I_total_3_4_vec = Mutual_I_total_3_4(:);
        Mutual_I_total_4_4_vec = Mutual_I_total_4_4(:);
        all_Mutual_I = [Mutual_I_total_1_4_vec; Mutual_I_total_2_4_vec; Mutual_I_total_3_4_vec; Mutual_I_total_4_4_vec];
        [max_Mutual_I_total, linear_index] = max(all_Mutual_I);
        matrix_idx = find([length(Mutual_I_total_1_4_vec), length(Mutual_I_total_2_4_vec), ...
            length(Mutual_I_total_3_4_vec), length(Mutual_I_total_4_4_vec)] >= linear_index, 1);
        switch matrix_idx
            case 1
                [RIbest, PMIbest] = ind2sub(size(Mutual_I_total_1_4_vec), linear_index);
            case 2
                [RIbest, PMIbest] = ind2sub(size(Mutual_I_total_2_4_vec), linear_index);
            case 3
                [RIbest, PMIbest] = ind2sub(size(Mutual_I_total_3_4_vec), linear_index);
            case 4
                [RIbest, PMIbest] = ind2sub(size(Mutual_I_total_4_4_vec), linear_index);
        end
end

end


