classdef (Abstract) StackingOrder

    properties (Constant)
        %-----------------------------------------------------------------%
        winAppAnalise     = {'mkrLabels', 'occTHR', 'mkrROI', 'ROI', 'Average', 'ClearWrite', 'MaxHold', 'mkrLine', 'Channels', 'BandLimits', 'Persistance', 'MinHold', 'WaterfallTime', 'Waterfall'}
        winSignalAnalysis = {'ROI', 'Average', 'MaxHold', 'MinHold'}
        RFLink            = {'Station', 'Link', 'Fresnel', 'FirstObstruction', 'Terrain'}
        winRFDataHub      = {}
        winDriveTest      = {'ROI', 'Car', 'Points', 'Distortion', 'Density', 'InRoute', 'OutRoute', 'ClearWrite', 'Persistance', 'WaterfallTime', 'Waterfall'}
    end


    methods (Static = true)
        %-----------------------------------------------------------------%
        function execute(hAxes, clientID)
            switch clientID
                case 'appAnalise:PLAYBACK'
                    refStackingOrder = plot.axes.StackingOrder.winAppAnalise;
                case 'appAnalise:REPORT'
                    refStackingOrder = plot.axes.StackingOrder.winAppAnalise;
                case 'appAnalise:RFDataHub'
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
            % newOrderIndex    = [];
            % for ii = 1:numel(refStackingOrder)
            %     idx = find(strcmp(stackingOrderTag, refStackingOrder{ii}));
            %     newOrderIndex = [newOrderIndex, idx];
            % end

            [~, newOrderMemberIndex] = ismember(stackingOrderTag, refStackingOrder);
            [~, newOrderIndex]       = sort(newOrderMemberIndex);
        
            hAxes.Children = hAxes.Children(newOrderIndex);
        end
    end
end