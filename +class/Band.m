classdef Band < handle

    properties
        %-----------------------------------------------------------------%
        DataPoints
        FreqStart   % in MHz
        FreqStop    % in MHz

        xArray      % in MHz

%       xFreq = aCoef * xIndex + bCoef
        aCoef
        bCoef
    end


    methods
        %-----------------------------------------------------------------%
        function update(obj, DataPoints, FreqStart, FreqStop)

            obj.DataPoints = DataPoints;
            obj.FreqStart  = FreqStart;
            obj.FreqStop   = FreqStop;

            obj.xArray     = round(linspace(FreqStart, FreqStop, DataPoints), class.Constants.xDecimals);

            obj.aCoef      = (FreqStop - FreqStart)*1e+6 ./ (DataPoints - 1);
            obj.bCoef      = FreqStart*1e+6 - obj.aCoef;            
        end


        %-----------------------------------------------------------------%
        function FrequencyInHertz = idx2freq(obj, idx)
            FrequencyInHertz = obj.aCoef * idx + obj.bCoef;
        end


        %-----------------------------------------------------------------%
        function idx = freq2idx(obj, FrequencyInHertz)
            idx = round((FrequencyInHertz - obj.bCoef) / obj.aCoef);
            
            if idx < 1
                idx = 1;
            elseif idx > obj.DataPoints
                idx = obj.DataPoints;
            end
        end
    end
end