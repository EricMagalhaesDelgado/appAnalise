classdef (Abstract) StackingOrder

    properties (Constant)
        %-----------------------------------------------------------------%
        winAppAnalise     = {'mkrLabels', 'occTHR', 'mkrROI', 'ROI', 'Average', 'ClearWrite', 'MaxHold', 'mkrLine', 'Channels', 'BandLimits', 'Persistance', 'MinHold', 'WaterfallTime', 'Waterfall'}
        
        winDriveTest      = {'FilterROI', 'Car', 'Points', 'Distortion', 'Density', 'InRoute', 'OutRoute', ...    % app.UIAxes1   (GeographicAxes)
                             'ChannelROI', 'ClearWrite', 'Persistance', 'Timeline', 'Waterfall', 'ChannelPower'}  % app.UIAxes2-4 (CartesianAxes)
        winSignalAnalysis = {'EmissionROI', 'Average', 'MaxHold', 'MinHold'}                                      % app.UIAxes2   (CartesianAxes)
        winRFDataHub      = {'FilterROI', 'RFLink', 'TX', 'RX', 'Stations'}                                       % app.UIAxes1   (GeographicAxes)

        RFLink            = {'StationLabel', 'Station', 'Link', 'Fresnel', 'FirstObstruction', 'Footnote', 'Terrain'}
    end


    methods (Static = true)
        %-----------------------------------------------------------------%
        function execute(hAxes, clientID)
            switch clientID
                case 'appAnalise:PLAYBACK'
                    refStackingOrder = plot.axes.StackingOrder.winAppAnalise;
                case 'appAnalise:REPORT'
                    refStackingOrder = plot.axes.StackingOrder.winAppAnalise;
                case 'appAnalise:RFDATAHUB'
                    refStackingOrder = plot.axes.StackingOrder.winRFDataHub;
                case 'appAnalise:DRIVETEST'
                    refStackingOrder = plot.axes.StackingOrder.winDriveTest;
                case 'appAnalise:SIGNALANALYSIS'
                    refStackingOrder = plot.axes.StackingOrder.winSignalAnalysis;
                case 'RFLink'
                    refStackingOrder = plot.axes.StackingOrder.RFLink;
                otherwise
                    error('Unexpected option.')
            end
            
            stackingOrderTag = arrayfun(@(x) x.Tag, hAxes.Children, 'UniformOutput', false)';

            [~, newOrderMemberIndex] = ismember(stackingOrderTag, refStackingOrder);
            [~, newOrderIndex]       = sort(newOrderMemberIndex);
        
            hAxes.Children = hAxes.Children(newOrderIndex);
        end
    end
end