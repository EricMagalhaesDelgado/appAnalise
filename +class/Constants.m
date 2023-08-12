classdef (Abstract) Constants

    properties (Constant)
        %-----------------------------------------------------------------%
        appName       = 'appAnalise'

        windowSize    = [1244, 660]
        windowMinSize = [ 526, 696]

        gps2locAPI    = 'https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=<Latitude>&longitude=<Longitude>&localityLanguage=pt'
        gps2loc_City  = 'city'
        gps2loc_Unit  = 'principalSubdivisionCode'

        yMinLimRange  = 80                                                  % Minimum y-Axis limit range
        yMaxLimRange  = 100                                                 % Maximum y-Axis limit range
        
        channelStep   = 0.025                                               % MHz (Channel Step)

        specDataTypes = [1, 2, 4, 7, 60, 61, 63, 64, 67, 68, 167, 168, 1000, 1809];
        occDataTypes  = [8, 62, 65, 69];
    end

    
    methods (Static = true)
        %-----------------------------------------------------------------%
        function [upYLim, strUnit] = yAxisUpLimit(Unit)
            switch lower(Unit)
                case 'dbm';                    upYLim = -20; strUnit = 'dBm';
                case {'dbµv', 'dbμv', 'dbuv'}; upYLim =  87; strUnit = 'dBµV';
                case {'dbµv/m', 'dbμv/m'};     upYLim = 100; strUnit = 'dBµV/m';
            end
        end
    end
end