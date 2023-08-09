function Truncated = Misc_TruncatedFrequency(Data, Frequency)

    arguments
        Data        struct
        Frequency   double
    end

    global peaksReference
    ChannelStep = class.Constants.channelStep;

    idx1 = Misc_Band(Data);
    
    Truncated = [];
    for ii = numel(Frequency):-1:1
        if ~isempty(idx1) && Frequency(ii) >= peaksReference(idx1).Band(1)/1e+6 && Frequency(ii) <= peaksReference(idx1).Band(2)/1e+6
            Channels  = peaksReference(idx1).Channels;

        else
            FreqStart = Data.MetaData.FreqStart ./ 1e+6;        % Hz >> MHz
            FreqStop  = Data.MetaData.FreqStop  ./ 1e+6;        % Hz >> MHz
            Channels  = FreqStart:ChannelStep:FreqStop;
        end

        [~, idx2]       = min(abs(Channels - Frequency(ii)));
        Truncated(ii,1) = Channels(idx2);
    end
end