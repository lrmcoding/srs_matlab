clc
clear
% load('2048mSSBsyn_36cfo_1')

% errorTimeTotal1 = errorTimeTotal;
% ratioNoDecSSS1 = ratioNoDecSSS;
% ratioNoDecPSS1 = ratioNoDecPSS;
% EstCFO_RMSE1 = EstCFO_RMSE;
% snrList1 = snrList;
% 
% load('2048mSSBsyn_36cfo_2')
% 
% errorTimeTotal1 = [errorTimeTotal1,errorTimeTotal];
% ratioNoDecSSS1 = [ratioNoDecSSS1;ratioNoDecSSS];
% ratioNoDecPSS1 = [ratioNoDecPSS1;ratioNoDecPSS];
% EstCFO_RMSE1 = [EstCFO_RMSE1,EstCFO_RMSE];
% snrList1 = [snrList1,snrList];
% 
% load('2048mSSBsyn_36cfo_3')
% 
% errorTimeTotal1 = [errorTimeTotal1,errorTimeTotal];
% ratioNoDecSSS1 = [ratioNoDecSSS1;ratioNoDecSSS];
% ratioNoDecPSS1 = [ratioNoDecPSS1;ratioNoDecPSS];
% EstCFO_RMSE1 = [EstCFO_RMSE1,EstCFO_RMSE];
% snrList1 = [snrList1,snrList];
% 
% errorTimeTotal = errorTimeTotal1;
% ratioNoDecSSS = ratioNoDecSSS1;
% ratioNoDecPSS = ratioNoDecPSS1;
% EstCFO_RMSE = EstCFO_RMSE1;
% snrList = snrList1;

%% Simulation result display
load('2048mSSBsyn_36cfo')
subplot(2,2,1)
plot(snrList,errorTimeTotal,'-*')
xlabel('SNR(dB)');
ylabel('定时误差(6.25us采样点数)');
xlim([-10 10])
ylim([0 600])
grid on

subplot(2,2,2)
semilogy(snrList,ratioNoDecPSS,'-*','Color','r')
xlabel('SNR(dB)');
ylabel('PSS漏检概率');
xlim([-10 0])
ylim([1e-4 1])
grid on

subplot(2,2,3)
semilogy(snrList,EstCFO_RMSE,'-*','Color','b')
xlabel('SNR(dB)');
ylabel('频偏估计RMSE');
xlim([-10 10])
ylim([1e-3 1e-1])
grid on

subplot(2,2,4)
semilogy(snrList,ratioNoDecSSS,'-*','Color','K')
xlabel('SNR(dB)');
ylabel('SSS漏检概率');
xlim([-10 -6])
ylim([1e-3 1])
grid on

%%
load('160kSSBsyn_36cfo')

figure
subplot(2,2,1)
plot(snrList,errorTimeTotal,'-*')
xlabel('SNR(dB)');
ylabel('定时误差(6.25us采样点数)');
xlim([-10 10])
ylim([0 600])
grid on

subplot(2,2,2)
semilogy(snrList,ratioNoDecPSS,'-*','Color','r')
xlabel('SNR(dB)');
ylabel('PSS漏检概率');
xlim([-10 0])
ylim([1e-4 1])
grid on

subplot(2,2,3)
semilogy(snrList,EstCFO_RMSE,'-*','Color','b')
xlabel('SNR(dB)');
ylabel('频偏估计RMSE');
xlim([-10 10])
ylim([1e-3 1e-1])
grid on

subplot(2,2,4)
semilogy(snrList,ratioNoDecSSS,'-*','Color','K')
xlabel('SNR(dB)');
ylabel('SSS漏检概率');
xlim([-10 -6])
ylim([1e-3 1])
grid on
