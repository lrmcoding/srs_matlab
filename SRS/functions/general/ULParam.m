function sysParameters = ULParam()
% -------------------------------------------------------------------------
% Function: Generate uplink system parameters
%
%    Input:
%
%   Output:	sysParameters: System parameters struct
% -------------------------------------------------------------------------

sysParameters                           = struct();                         % Create ssysParameters variable to contain all key system parameters
sysParameters.modOrder                  = 2;
sysParameters.NCellID                   = 15;                               % Cell identity
sysParameters.NUe                       = 1;                                % Number of UE in the cell
sysParameters.NAntPerUe                 = 1;                                % Number of antennas per UE
sysParameters.NBsAnt                    = 1;                                % Number of antennas of basestation
sysParameters.NSubcarrierPerSubband     = 10;                               % Number of subcarriers in a subband
sysParameters.block                     =3;                                 %频段分区

% Synchronization parameters
sysParameters.Syn.Knoise                = 7.66;
sysParameters.Syn.C                     = 3e8;
sysParameters.Syn.PPM                   = 0;
sysParameters.Syn.CarrierFreq           = 230e6;
sysParameters.Syn.PPMFreqOffset         = sysParameters.Syn.PPM ...
    *sysParameters.Syn.CarrierFreq;
sysParameters.Syn.Velocity              = 60;                               %km/h
sysParameters.Syn.DopperFreqOffset      = sysParameters.Syn.Velocity./3.6 ...
    * sysParameters.Syn.CarrierFreq ...
    ./sysParameters.Syn.C;
% sysParameters.Syn.MaxFreqOffset         = sysParameters.Syn.DopperFreqOffset ...
%     + sysParameters.Syn.PPMFreqOffset;
sysParameters.Syn.MaxFreqOffset         = 0;

sysParameters.Syn.NID2                  = mod(sysParameters.NCellID,3);
sysParameters.Syn.NID1                  = fix(sysParameters.NCellID/3);
sysParameters.Syn.DetectWinLen          = 3072;

%% SRS waveform parameters
sysParameters.SRSCarrier.SubcarrierSpacing = 2.5e3;                         % 2.5kHz Subcarrier space
sysParameters.SRSCarrier.SubbandSpacing    = 25e3;                          % 25kHz Subband space
switch sysParameters.block
    case 1
        sysParameters.SRSCarrier.NSubband          = 120;                   % Number of subband
        
    case 2

        sysParameters.SRSCarrier.NSubband          = 120;                   % Number of subband

    case 3
        sysParameters.SRSCarrier.NSubband          = 160;                   % Number of subband

    case 4
        sysParameters.SRSCarrier.NSubband          = 80;                    % Number of subband
end
sysParameters.SRSCarrier.NFFT              = 64;                          % FFT point
sysParameters.SRSCarrier.NSubcarrier       = 10;                            % Number of subcarrier
sysParameters.SRSCarrier.N_cycle=sysParameters.SRSCarrier.NSubband/4;
sysParameters.SRSCarrier.SampleRate        = sysParameters.SRSCarrier.SubcarrierSpacing*sysParameters.SRSCarrier.NFFT;                         % Sample rate of a single subband
sysParameters.SRSCarrier.UwSymbolsFirstSlot  = 6;                           % Number of uplink symbols in first slot
sysParameters.SRSCarrier.UwSymbolsSecondfSlot  = 5;                         % Number of uplink symbols in second slot
sysParameters.SRSCarrier.UwSlotsPerFrame   = 2;                             % Number of uplink slots in a frame
sysParameters.SRSCarrier.CyclicPrefixLength= 62.5e-6*sysParameters.SRSCarrier.SampleRate*ones(1,22*sysParameters.SRSCarrier.N_cycle);                  % Cyclic prefix length (in samples) of each OFDM symbol in a slot
sysParameters.SRSCarrier.CyclicSuffixLength= 1/2*sysParameters.SRSCarrier.CyclicPrefixLength;
% sysParameters.SRSCarrier.CyclicSuffixLength= 0*sysParameters.SRSCarrier.CyclicPrefixLength;


% Baseband waveform parameters
sysParameters.BasebandCarrier.SubcarrierSpacing = 2.5e3;                    % 2.5kHz Subcarrier space
sysParameters.BasebandCarrier.SubbandSpacing    = 25e3;                     % 25kHz Subband space
sysParameters.BasebandCarrier.NSubband          = 1;                        % Number of subband
sysParameters.BasebandCarrier.NSubcarrier       = 10;                        % Number of subcarrier
sysParameters.BasebandCarrier.NFFT              = 8192;                     % FFT point
sysParameters.BasebandCarrier.SampleRate        = 20.48e6;                  % Sample rate of a single subband
sysParameters.BasebandCarrier.UwSymbolsFirstSlot  = 6;                        % Number of downlink symbols in a slot
sysParameters.BasebandCarrier.UwSymbolsSecondfSlot   = 5;                        % Number of downlink slots in a frame
sysParameters.BasebandCarrier.CyclicPrefixLength= 128*10*ones(1,10);         % Cyclic prefix length (in samples) of each OFDM symbol in a slot
sysParameters.BasebandCarrier.CyclicSuffixLength= 0*128;                        % Cyclic suffix length (in samples) of OFDM symbol
sysParameters.BasebandCarrier.DwSamplesPerSlot  = 370*128;



%SRS parameters
sysParameters.SRS.v = 0;                                                    
sysParameters.SRS.N_UE = 4;                                                 %每4个SRS子带复用的UE个数
sysParameters.SRS.N_PORT_SUBB = 4;                                          %分配给端口的子带数
sysParameters.SRS.portNum = 1;                                               %端口数
sysParameters.SRS.SUB_offset = mod(sysParameters.NCellID,3);                %子带偏置

% % Subband filter parameters 
% % SRS

load('srs4subband.mat');
sysParameters.SRSFilter.Coefficients    = lpFilt;
sysParameters.SRSFilter.FilterOrder     = length(sysParameters.SRSFilter.Coefficients);
sysParameters.SRSFilter.Compensation    = ...
sysParameters.SRSCarrier.CyclicSuffixLength;                                % Compensation length of filter

end

