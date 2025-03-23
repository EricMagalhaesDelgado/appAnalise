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

                    horLine = line(hAxes, [FreqStart, FreqStop], [yLevel2Plot, yLevel2Plot], plotConfig{:});
                    verLine = line(hAxes, [FreqCenter, FreqCenter], [-inf, inf], plotConfig{:});
                    text(hAxes, FreqCenter, yLevel2Plot, sprintf(' %d', ii), Color=horLine.Color, FontSize=10, FontWeight='bold', FontName='Helvetica', VerticalAlignment='bottom', FontSmoothing='on', Tag='EmissionTag');
                end

                plot.axes.StackingOrder.execute(hAxes, bandObj.Context)
            end
        end
    end
end