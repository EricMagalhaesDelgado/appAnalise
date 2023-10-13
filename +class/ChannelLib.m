classdef ChannelLib < handle

    properties
        %-----------------------------------------------------------------%
        Channel   = table('Size', [0,7],                                                                       ...
                          'VariableTypes', {'cell', 'double', 'double', 'double', 'double', 'cell', 'struct'}, ...
                          'VariableNames', {'Name', 'FreqStart', 'FreqStop', 'StepWidth', 'ChannelBW', 'FreqList', 'FindPeaks'})

        Exception = table('Size', [0,2],                       ...
                          'VariableTypes', {'double', 'cell'}, ...
                          'VariableNames', {'FreqCenter', 'Description'})

        DefaultChannelStep
        DefaultMinBandSpan
    end


    methods
        %-----------------------------------------------------------------%
        function obj = ChannelLib(RootFolder)

            channelTempLib = jsondecode(fileread(fullfile(RootFolder, 'Settings', 'ChannelLib.json')));

            obj.Channel     = struct2table(channelTempLib.Channel);
            obj.Exception   = struct2table(channelTempLib.Exception);

            obj.DefaultChannelStep = channelTempLib.DefaultChannelStep;
            obj.DefaultMinBandSpan = channelTempLib.DefaultMinBandSpan;
        end


        %-----------------------------------------------------------------%
        function TruncatedList = TruncatedFrequency(obj, specData, FreqList)
        
            idx1 = FindBand(obj, specData);
            
            TruncatedList = [];
            for ii = numel(FreqList):-1:1
                if ~isempty(idx1) && FreqList(ii) >= obj.Channel.FreqStart(idx1)/1e+6 && FreqList(ii) <= obj.Channel.FreqStart(idx1)/1e+6
                    Channels  = obj.Channel.Channels{idx1};
        
                else
                    FreqStart = specData.MetaData.FreqStart ./ 1e+6;            % Hz >> MHz
                    FreqStop  = specData.MetaData.FreqStop  ./ 1e+6;            % Hz >> MHz
                    Channels  = FreqStart:obj.DefaultChannelStep:FreqStop;
                end
        
                [~, idx2] = min(abs(Channels - FreqList(ii)));
                TruncatedList(ii,1) = Channels(idx2);
            end
        end


        %-----------------------------------------------------------------%
        function idx = FindBand(obj, specData)
        
            FreqStart = specData.MetaData.FreqStart/1e+6;
            FreqStop  = specData.MetaData.FreqStop /1e+6;
        
            idx = find(((FreqStart >= obj.Channel.FreqStart) & (FreqStart <= obj.Channel.FreqStop)) | ...
                       ((FreqStart <= obj.Channel.FreqStart) & (FreqStop  >= obj.Channel.FreqStop)) | ...
                       ((FreqStop  >= obj.Channel.FreqStart) & (FreqStop  <= obj.Channel.FreqStop)));
        end
    end
end