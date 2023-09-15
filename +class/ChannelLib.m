classdef ChannelLib < handle

    properties
        %-----------------------------------------------------------------%
        Channel     = table('Size', [0,5],                                                 ...
                            'VariableTypes', {'cell', 'double', 'double', 'cell', 'cell'}, ...
                            'VariableNames', {'Name', 'FreqStart', 'FreqStop', 'FindPeaks', 'Channels'})

        Exception   = table('Size', [0,2],                       ...
                            'VariableTypes', {'double', 'cell'}, ...
                            'VariableNames', {'FreqCenter', 'Description'})

        ChannelStep
        BandSpan
    end


    methods
        %-----------------------------------------------------------------%
        function obj = ChannelLib(RootFolder)

            channelTempLib = jsondecode(fileread(fullfile(RootFolder, 'Settings', 'ChannelLib.json')));

            obj.Channel     = struct2table(channelTempLib.Channel);
            obj.Exception   = struct2table(channelTempLib.Exception);            
            obj.ChannelStep = channelTempLib.ChannelStep;
            obj.BandSpan    = channelTempLib.BandSpan;
        end


        %-----------------------------------------------------------------%
        function TruncatedList = Misc_TruncatedFrequency(obj, Data, FreqList)
        
            idx1 = FindBand(obj, Data);
            
            TruncatedList = [];
            for ii = numel(FreqList):-1:1
                if ~isempty(idx1) && FreqList(ii) >= peaksReference(idx1).Band(1)/1e+6 && FreqList(ii) <= peaksReference(idx1).Band(2)/1e+6
                    Channels  = peaksReference(idx1).Channels;
        
                else
                    FreqStart = Data.MetaData.FreqStart ./ 1e+6;            % Hz >> MHz
                    FreqStop  = Data.MetaData.FreqStop  ./ 1e+6;            % Hz >> MHz
                    Channels  = FreqStart:obj.ChannelStep:FreqStop;
                end
        
                [~, idx2]       = min(abs(Channels - FreqList(ii)));
                TruncatedList(ii,1) = Channels(idx2);
            end
        end


        %-----------------------------------------------------------------%
        function [idx, Band] = FindBand(obj, Data)
        
            CF   = (Data.MetaData.FreqStart + Data.MetaData.FreqStop)/2;
            Span =  Data.MetaData.FreqStop  - Data.MetaData.FreqStart;
        
            idx  = [];
            Band = '';
        
            for ii = 1:height(obj.Channel)
                if (CF > obj.Channel.FreqStart(ii)) && (CF < peaksReference(ii).Band(2)) && (Span >= obj.refSpan)
                    idx  = ii;
                    Band = peaksReference(ii).Description;
                    break
                end
            end        
        end
    end
end