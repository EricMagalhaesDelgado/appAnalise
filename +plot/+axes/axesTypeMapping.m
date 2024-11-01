function [axesType, axesXLabel, axesYLabel, axesYScale] = axesTypeMapping(plotNamesPerAxes, tempBandObj)

    axesType   = {};
    axesXLabel = {};
    axesYLabel = {};
    axesYScale = {};

    for ii = 1:numel(plotNamesPerAxes)
        plotNames = strsplit(plotNamesPerAxes{ii}, '+');

        switch plotNames{1}
            case {'DriveTest', ...
                  'Stations',  ...
                  'DriveTestRoute'}
                axesType{ii}   = 'Geographic';
                axesXLabel{ii} = '';
                axesYLabel{ii} = '';
                axesYScale{ii} = '';
            
            case {'MinHold',             ...
                  'Average',             ...
                  'ClearWrite',          ...
                  'MaxHold',             ...
                  'Persistance',         ...
                  'Channel',             ...
                  'Emission',            ...
                  'EmissionROI'}
                axesType{ii}   = 'Cartesian';
                axesXLabel{ii} = 'Frequência (MHz)';
                axesYScale{ii} = '';

                switch tempBandObj.LevelUnit
                    case 'dBm'
                        axesYLabel{ii} = 'Potência (dBm)';
                    otherwise
                        axesYLabel{ii} = ['Nível ' tempBandObj.LevelUnit];
                end
            
            case {'OccupancyPerBin', ...
                  'OccupancyPerChannel'}
                axesType{ii}   = 'Cartesian';
                axesXLabel{ii} = 'Frequência (MHz)';
                axesYLabel{ii} = 'Ocupação (%)';
                axesYScale{ii} = 'log';
            
            case 'Waterfall'
                axesType{ii}   = 'Cartesian';
                axesXLabel{ii} = 'Frequência (MHz)';
                axesYLabel{ii} = 'Varredura';
                axesYScale{ii} = '';

            case {'ChannelPower', ...
                  'RFLink'}
                axesType{ii}   = 'Cartesian';
                axesXLabel{ii} = '';
                axesYLabel{ii} = '';
                axesYScale{ii} = '';
            
            otherwise
                error('Unexpected plotName %s', plotNamesPerAxes{ii})
        end
    end

end