classdef (Abstract) datatip

    methods (Static = true)
        %-----------------------------------------------------------------%
        function [ParentTag, DataIndex, XData, YData] = Search(dtParent)

            hDataTip  = findobj(dtParent, 'Type', 'datatip');

            ParentTag = arrayfun(@(x) x.Parent.Tag, hDataTip, "UniformOutput", false);
            DataIndex = arrayfun(@(x) x.DataIndex,  hDataTip, "UniformOutput", false);
            XData     = arrayfun(@(x) x.X,          hDataTip, "UniformOutput", false);
            YData     = arrayfun(@(x) x.Y,          hDataTip, "UniformOutput", false);

        end


        %-----------------------------------------------------------------%
        function Create(callingFcn, dtConfig, dtParent)
            arguments
                callingFcn char {mustBeMember(callingFcn, {'customPlayback', 'WaterfallDecimationChanged'})}
                dtConfig   struct
                dtParent
            end

            switch callingFcn
                case 'customPlayback'
                    % dtConfig = struct('ParentTag', {}, 'DataIndex', {})
                    for ii = 1:numel(dtConfig)
                        hLine = findobj(dtParent, 'Tag', dtConfig(ii).ParentTag);

                        if ~isempty(hLine)
                            datatip(hLine(1), 'DataIndex', dtConfig(ii).DataIndex);
                        end
                    end

                case 'WaterfallDecimationChanged'
                    % dtConfig = struct('XData', {}, 'YData', {})
                    for ii = 1:numel(dtConfig)
                        datatip(dtParent, dtConfig(ii).XData, dtConfig(ii).YData);
                    end
            end
        end


        %-----------------------------------------------------------------%
        function Model(dtParent, dtUnit)
            % Bloco try/catch inserido aqui pra evitar erro de algo não essencial
            % na execução do app. No caso, o erro se manifestou ao inserir uma ROI.
            % Avaliar no futuro! :)

            try
                if ~isprop(dtParent, 'DataTipTemplate')
                    dt = datatip(dtParent, 'Visible', 'off');
                end
                set(dtParent.DataTipTemplate, 'FontName', 'Calibri', 'FontSize', 10)

                switch class(dtParent)
                    case {'matlab.graphics.chart.primitive.Line', 'matlab.graphics.chart.primitive.Area'}
                        dtParent.DataTipTemplate.DataTipRows(1).Label  = '';
                        dtParent.DataTipTemplate.DataTipRows(1).Format = '%.3f MHz';

                        dtParent.DataTipTemplate.DataTipRows(2).Label  = '';
                        dtParent.DataTipTemplate.DataTipRows(2).Format = ['%.0f ' dtUnit];

                    case 'matlab.graphics.primitive.Image'
                        dtParent.DataTipTemplate.DataTipRows(1).Label  = '';
                      % dtParent.DataTipTemplate.DataTipRows(1).Value  = 'XData';
                      % dtParent.DataTipTemplate.DataTipRows(1).Format = '%.3f MHz';

                        dtParent.DataTipTemplate.DataTipRows(2).Label  = '';
                        dtParent.DataTipTemplate.DataTipRows(2).Format =  ['%.0f ' dtUnit];

                        dtParent.DataTipTemplate.DataTipRows(3)        = [];

                    case 'matlab.graphics.chart.primitive.Surface'
                        dtParent.DataTipTemplate.DataTipRows(1).Label = '';
                        dtParent.DataTipTemplate.DataTipRows(2).Label = '';
                        dtParent.DataTipTemplate.DataTipRows(3).Label = '';

                        dtParent.DataTipTemplate.DataTipRows(1).Format = '%.3f MHz';
                        dtParent.DataTipTemplate.DataTipRows(2).Format =  'dd/MM/yyyy HH:mm:ss';
                        dtParent.DataTipTemplate.DataTipRows(3).Format =  ['%.0f ' dtUnit];
                end

                if exist('dt', 'var')
                    delete(dt)
                end
            catch
            end
        end
    end
end