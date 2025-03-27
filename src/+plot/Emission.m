classdef (Abstract) Emission

    methods (Static = true)
        %-----------------------------------------------------------------%
        function TStyle(hAxes, bandObj, idx, plotTag, varargin)
            specData       = bandObj.callingApp.specData(idx);

            emissionsTable = specData.UserData.Emissions;
            emissionsTable.FreqStart = emissionsTable.Frequency - emissionsTable.BW_kHz/2000;
            emissionsTable.FreqStop  = emissionsTable.Frequency + emissionsTable.BW_kHz/2000;

            delete(findobj(hAxes, 'Tag', plotTag))
            
            if ~isempty(emissionsTable)
                defaultProp  = bandObj.callingApp.General_I;

                [plotConfig,     ...
                 YLimOffsetMode, ...
                 YLimOffset,     ...
                 StepEffect] = plot.Config(plotTag, defaultProp, []);

                switch YLimOffsetMode
                    case 'bottom'
                        YLimOffset = 0;
                        yLevel = hAxes.YLim(1)+YLimOffset;
                    otherwise % 'top'
                        yLevel = hAxes.YLim(2)-YLimOffset;                        
                end
            
                for ii = 1:height(emissionsTable)
                    FreqCenter = emissionsTable.Frequency(ii);
                    FreqStart  = emissionsTable.FreqStart(ii);
                    FreqStop   = emissionsTable.FreqStop(ii);

                    if StepEffect
                        switch YLimOffsetMode
                            case 'bottom'
                                yLevel2Plot = yLevel + mod(ii+1,2);
                            otherwise
                                yLevel2Plot = yLevel - mod(ii+1,2);
                        end
                    else
                        yLevel2Plot = yLevel;
                    end

                    % ToDo:
                    % Deixar configuráveis os parâmetros...
                    % Editar "GeneralSettings.json"

                    line(hAxes, [FreqStart, FreqStop], [yLevel2Plot, yLevel2Plot], 'Color', '#ffff12', 'LineWidth', 1, 'LineStyle', ':', 'Marker', '.', 'MarkerSize', 8, 'PickableParts', 'none', 'Tag', 'Emission');
                    line(hAxes, [FreqCenter, FreqCenter], [-1000, 1000], 'Color', '#ffff12', 'LineWidth', 1, 'LineStyle', ':', 'PickableParts', 'none', 'Tag', 'Emission');
                    text(hAxes, FreqCenter, yLevel2Plot, sprintf(' %d', ii), Color='#ffff12', FontSize=10, FontWeight='bold', FontName='Helvetica', VerticalAlignment='bottom', Tag='EmissionTag');
                end

                plot.axes.StackingOrder.execute(hAxes, bandObj.Context)
            end
        end
    end
end