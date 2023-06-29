classdef (Abstract) Constants

    properties (Constant)
        windowSize    = [1016, 696]
        windowMinSize = [ 440, 696]

        gps2locAPI    = 'https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=<Latitude>&longitude=<Longitude>&localityLanguage=pt'
        gps2loc_City  = 'city'
        gps2loc_Unit  = 'principalSubdivisionCode'

        yMinLimRange  = 80                                                  % Minimum y-Axis limit range
        yMaxLimRange  = 100                                                 % Maximum y-Axis limit range
        
        channelStep   = 0.025                                               % MHz (Channel Step)
    end

    methods (Static = true)
        function [upYLim, strUnit] = yAxisUpLimit(Unit)
            switch lower(Unit)
                case 'dbm';                    upYLim = -20; strUnit = 'dBm';
                case {'dbµv', 'dbμv', 'dbuv'}; upYLim =  87; strUnit = 'dBµV';
                case {'dbµv/m', 'dbμv/m'};     upYLim = 100; strUnit = 'dBµV/m';
            end
        end
    end

end