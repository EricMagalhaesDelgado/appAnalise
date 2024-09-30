classdef (Abstract) DriveTest

    methods (Static = true)
        %-----------------------------------------------------------------%
        function Filters(app)
            % Migrar para essa classe funções de auxApp.DriveTest:
            % - plot_FiltersController(app)
            % - hROI = plot_FilterROIObject(app, callingFcn, FilterSubtype, hAxes, varargin)

            % Organizar código de forma a ser consumido pelo modo RELATÓRIO,
            % atualmente em:
            % - plot.old_axesDraw.DriveTestFilterPlot(hAxes, Parameters, plotType)
            % 
        end

        %-----------------------------------------------------------------%
        function Points(hAxes, pointsTable, MarkerStyle, MarkerColor, MarkerSize)
            for ii = 1:height(pointsTable)
                if ~pointsTable.visible(ii)
                    continue
                end
            
                switch pointsTable.type{ii}
                    case 'RFDataHub'
                        Coordinates = [pointsTable.value(ii).Data.Latitude, pointsTable.value(ii).Data.Longitude];
                        hStation    = geoplot(hAxes, Coordinates(:,1), Coordinates(:,2), 'LineStyle',       'none',       ...
                            'Color',           MarkerColor,  ...
                            'Marker',          MarkerStyle,  ...
                            'MarkerSize',      MarkerSize,   ...
                            'MarkerFaceColor', MarkerColor,  ...
                            'MarkerEdgeColor', MarkerColor,  ...
                            'DisplayName',     'Pontos de interesse (RFDataHub)', ...
                            'Tag',             'Points');
                        plot.datatip.Template(hStation, 'Coordinates+Frequency', pointsTable.value(ii).Data)
            
                    case 'FindPeaks'
                        Coordinates = pointsTable.value(ii).Data;
                        hFindPeaks  = geoplot(hAxes, Coordinates(:,1), Coordinates(:,2), 'LineStyle',       'none',      ...
                            'Color',           MarkerColor, ...
                            'Marker',          MarkerStyle, ...
                            'MarkerSize',      MarkerSize,  ...
                            'MarkerFaceColor', 'none',      ...
                            'MarkerEdgeColor', MarkerColor, ...
                            'PickableParts',   'none',      ...
                            'DisplayName',     'Pontos de interesse (FindPeaks)', ...
                            'Tag',             'Points');
                        % plot.datatip.Template(hFindPeaks, 'Coordinates', pointsTable.value(ii).Data)
                end
            end
        end
    end
end