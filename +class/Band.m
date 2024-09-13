classdef Band < handle

    properties
        %-----------------------------------------------------------------%
        Context     char {mustBeMember(Context, {'appAnalise:PLAYBACK', 'appAnalise:SIGNALANALYSIS', 'appAnalise:DRIVETEST'})} = 'appAnalise:PLAYBACK' % 'appAnalise:REPORT:BAND', 'appAnalise:REPORT:EMISSION'
        callingApp
        
        Receiver
        nSweeps
        DataPoints
        FreqStart   % in MHz
        FreqStop    % in MHz
        LevelUnit

        xArray      % in MHz

%       xFreq = aCoef * xIndex + bCoef
        aCoef
        bCoef        
    end


    methods
        %-----------------------------------------------------------------%
        function obj = Band(Context, callingApp)
            obj.Context    = Context;
            obj.callingApp = callingApp;            
        end

        %-----------------------------------------------------------------%
        function axesLimits = update(obj, idx, varargin)
            specData       = obj.callingApp.specData(idx);

            obj.Receiver   = fcn.treeReceiverName(specData.Receiver, 'class.Band.update');
            obj.nSweeps    = numel(specData.Data{1});
            obj.DataPoints = specData.MetaData.DataPoints;
            obj.FreqStart  = specData.MetaData.FreqStart / 1e+6;
            obj.FreqStop   = specData.MetaData.FreqStop  / 1e+6;

            DataType       = specData.MetaData.DataType;
            if ismember(DataType, class.Constants.specDataTypes)
                obj.LevelUnit = specData.MetaData.LevelUnit;
            elseif ismember(DataType, class.Constants.occDataTypes)
                obj.LevelUnit = '%';
            else
                error('Band:update:UnexpectedDataType', 'UnexpectedDataType')
            end

            obj.xArray     = round(linspace(obj.FreqStart, obj.FreqStop, obj.DataPoints), class.Constants.xDecimals);
            obj.aCoef      = (obj.FreqStop - obj.FreqStart)*1e+6 ./ (obj.DataPoints - 1);
            obj.bCoef      = obj.FreqStart*1e+6 - obj.aCoef;       

            axesLimits     = Limits(obj, idx, varargin{:});
        end

        %-----------------------------------------------------------------%
        function axesLimits = Limits(obj, idx, varargin)
            % Nos contextos "appAnalise:PLAYBACK" e "appAnalise:REPORT:BAND"
            % o plot é orientado à faixa de frequência. Neste caso, os limites
            % dos eixos serão manuais - selecionados diretamente no PLAYBACK - 
            % ou automáticos.

            % Já nos contextos cujo plot é orientado à emissão, os limites serão
            % delimitados pelas características da emissão (FreqCenter e BW) e 
            % pela variável BandGuard.

            % O campo "xIndexLimits" é aplicável apenas ao plot orientado à
            % emissão. Mantido em todos os contextos para garantir uma estrutura
            % uniforme de axesLimits.

            switch obj.Context
                case {'appAnalise:PLAYBACK', 'appAnalise:REPORT:BAND'}
                    specData = obj.callingApp.specData(idx);        
                    switch specData.UserData.customPlayback.Type
                        case 'manual'
                            xLimits      = specData.UserData.customPlayback.Parameters.Controls.FrequencyLimits;
                            yLevelLimits = specData.UserData.customPlayback.Parameters.Controls.LevelLimits;
                            cLimits      = specData.UserData.customPlayback.Parameters.Waterfall.LevelLimits;

                            if isequal(cLimits, [0,0])
                                cLimits  = [0,1];
                            end
        
                            if issorted(xLimits, 'strictascend') && issorted(yLevelLimits, 'strictascend') && issorted(cLimits, 'strictascend')
                                axesLimits = struct('xLim',         xLimits,                                      ...
                                                    'xIndexLimits', freq2idx(obj, xLimits * 1e+6),                ...
                                                    'yLevelLim',    yLevelLimits,                                 ...
                                                    'yTimeLim',     [specData.Data{1}(1), specData.Data{1}(end)], ...
                                                    'cLim',         cLimits);

                                if specData.Data{1}(1) == specData.Data{1}(end)
                                    axesLimits.yTimeLim(2) = axesLimits.yTimeLim(2) + seconds(1);
                                end        
                            else
                                axesLimits = XYCLimits(obj, idx);
                            end        
                    otherwise
                        axesLimits = XYCLimits(obj, idx);
                    end

                case {'appAnalise:REPORT:EMISSION', 'appAnalise:SIGNALANALYSIS', 'appAnalise:DRIVETEST'}
                    if isempty(varargin)
                        error('Band:Limits:UnexpectedNumberOfInputArguments', 'Unexpected number of input arguments')
                    end

                  % idxEmission = varargin{1};
                  % GuardBand   = varargin{2};
                    axesLimits  = XYCLimits(obj, idx, varargin{:});
            end
        end

        %-----------------------------------------------------------------%
        function [XArray, YArray] = XYArray(obj, idx, plotTag)

            arguments
                obj
                idx
                plotTag {mustBeMember(plotTag, {'ClearWrite', 'MinHold', 'Average', 'MaxHold', 'WaterfallTime'})}
            end

            specData = obj.callingApp.specData(idx);
            if isprop(obj.callingApp, 'idxTime')
                idxTime = obj.callingApp.idxTime;
            end

            switch plotTag
                case 'ClearWrite'
                    XArray = obj.xArray;
                    YArray = specData.Data{2}(:,idxTime)';                    

                case {'MinHold', 'Average', 'MaxHold'}
                    XArray = obj.xArray;

                    switch plotTag
                        case 'MinHold'; idxFcn = 1;
                        case 'Average'; idxFcn = 2;
                        case 'MaxHold'; idxFcn = 3;
                    end
        
                    switch obj.Context
                        case 'appAnalise:PLAYBACK'
                            if ismember(plotTag, {'MinHold', 'Average', 'MaxHold'}) && isinf(str2double(obj.callingApp.play_TraceIntegration.Value))
                                YArray  = specData.Data{3}(:,idxFcn)';        
                            else
                                YArray  = specData.Data{2}(:,idxTime)';
                            end
        
                        case {'appAnalise:SIGNALANALYSIS', 'appAnalise:DRIVETEST'}
                            YArray = specData.Data{3}(:,idxFcn)';
                    end

                case 'WaterfallTime'
                     XArray = [obj.xArray(1), obj.xArray(end)];

                    switch obj.Context
                        case {'appAnalise:PLAYBACK', 'appAnalise:DRIVETEST'}
                            hAxes = obj.callingApp.UIAxes3;
                            switch class(hAxes.YAxis)
                                case 'matlab.graphics.axis.decorator.DatetimeRuler'
                                    YArray = [specData.Data{1}(idxTime), specData.Data{1}(idxTime)];
                                otherwise
                                    YArray = [idxTime, idxTime];
                            end

                        case {'appAnalise:REPORT:BAND', 'appAnalise:REPORT:EMISSION', 'appAnalise:SIGNALANALYSIS'}
                            error('Band:XYArray:UnexpectedPlotTag', 'UnexpectedPlotTag')
                    end
            end
        end

        %-----------------------------------------------------------------%
        function FrequencyInHertz = idx2freq(obj, idx)
            FrequencyInHertz = obj.aCoef * idx + obj.bCoef;
        end

        %-----------------------------------------------------------------%
        function [idx, invalidIndex] = freq2idx(obj, FrequencyInHertz, validationType, roundType)
            arguments
                obj
                FrequencyInHertz
                validationType {mustBeMember(validationType, {'CheckAndRound', 'OnlyCheck'})} = 'CheckAndRound'
                roundType      {mustBeMember(roundType,      {'round', 'fix', 'ceil'})} = 'round'
            end

            idx = (FrequencyInHertz - obj.bCoef) / obj.aCoef;
            switch roundType
                case 'round'; idx = round(idx);
                case 'fix';   idx = fix(idx);
                case 'ceil';  idx = ceil(idx);
            end

            invalidIndex = (idx < 1) | (idx > obj.DataPoints);

            if validationType == "CheckAndRound"
                idx(idx < 1) = 1;
                idx(idx > obj.DataPoints) = obj.DataPoints;
            end
        end

        %-----------------------------------------------------------------%
        function idxTime = Timestamp2idxTime(obj, idx, Timestamp)
            [~, idxTime] = min(abs(obj.callingApp.specData(idx).Data{1}-Timestamp));
        end

        %-----------------------------------------------------------------%
        function Timestamp = idxTime2Timestamp(obj, idx, idxTime)
            Timestamp = obj.callingApp.specData(idx).Data{1}(idxTime);
        end
    end

    methods(Access = private)
        %-----------------------------------------------------------------%
        function axesLimits = XYCLimits(obj, idx, idxEmission, GuardBand)
            arguments
                obj
                idx
                idxEmission = -1
                GuardBand   = struct('Mode', 'manual', 'Parameters', struct('Type', 'BWRelated', 'Value', 5))
            end
            specData   = obj.callingApp.specData(idx);

            % xLimits
            switch obj.Context
                case {'appAnalise:PLAYBACK', 'appAnalise:REPORT:BAND'}
                    xLimits    = [obj.FreqStart, obj.FreqStop];
                    xIndexDown = 1;
                    xIndexUp   = obj.DataPoints;

                case {'appAnalise:REPORT:EMISSION', 'appAnalise:SIGNALANALYSIS'}
                    emissionFreqCenter = specData.UserData.Emissions.Frequency(idxEmission); % MHz
                    emissionBW         = specData.UserData.Emissions.BW(idxEmission) / 1000; % kHz >> MHz

                    if emissionBW <= 0
                        GuardBand = struct('Mode', 'manual', 'Parameters', struct('Type', 'Fixed', 'Value', 1));
                    end
                    [xLimits,    ...
                     xIndexDown, ...
                     xIndexUp] = XEmissionLimits(obj, emissionFreqCenter, emissionBW, GuardBand);

                case 'appAnalise:DRIVETEST'
                    chFrequency = obj.callingApp.general_chFrequency.Value; % MHz
                    chBW        = obj.callingApp.general_chBW.Value / 1000; % kHz >> MHz

                    [xLimits,    ...
                     xIndexDown, ...
                     xIndexUp] = XEmissionLimits(obj, chFrequency, chBW, GuardBand);
            end
        
            % yLevelLimits
            DataType     = specData.MetaData.DataType;
            if ismember(DataType, class.Constants.specDataTypes)
                % yLimits
                minArray = sort(specData.Data{3}(xIndexDown:xIndexUp, 1));
                maxArray = sort(specData.Data{3}(xIndexDown:xIndexUp, 3), 'descend');

                nSamples = ceil(.01*numel(minArray));
                minValue = median(minArray(1:nSamples));
                maxValue = median(maxArray(1:nSamples));

                downYLim = minValue - mod(minValue, 5);
                upYLim   = maxValue - mod(maxValue, 10) + 10;

                % cLimits
                downCLim = RF.noiseEstimation(specData, xIndexDown, xIndexUp, .05, .15, 3);
                upCLim   = upYLim - 10;
                downCLim = max(downCLim, upCLim-30);

                diffCLim = upCLim-downCLim;
                if diffCLim < 15
                    downCLim = downCLim - (15-diffCLim)/2;
                    upCLim   = upCLim   + (15-diffCLim)/2;
                end

            elseif ismember(DataType, class.Constants.occDataTypes)
                downYLim = 0;
                upYLim   = 100;

                downCLim = 0;
                upCLim   = 1;

            else
                error('Band:XYCLimits:UnexpectedDataType', 'UnexpectedDataType')
            end
            yLevelLimits = [downYLim, upYLim];
        
            if diff(yLevelLimits) > class.Constants.yMaxLimRange
                yLevelLimits(1) = yLevelLimits(1) + diff(yLevelLimits) - class.Constants.yMaxLimRange;
            end

            axesLimits = struct('xLim',         xLimits,                                      ...
                                'xIndexLimits', [xIndexDown, xIndexUp],                       ...
                                'yLevelLim',    yLevelLimits,                                 ...
                                'yTimeLim',     [specData.Data{1}(1), specData.Data{1}(end)], ...
                                'cLim',         [downCLim, upCLim]);

            if specData.Data{1}(1) == specData.Data{1}(end)
                axesLimits.yTimeLim(2) = axesLimits.yTimeLim(2) + seconds(1);
            end
        end

        %-----------------------------------------------------------------%
        function [xFrequencyLimits, xIndexDown, xIndexUp] = XEmissionLimits(obj, refFreqCenter, refBW, GuardBand)
            % Escolhido como nome da variável "refFreqCenter" e "refBW" 
            % porque essa chamada é consumida tanto por ROIs relacionadas a
            % emissões, quanto por ROIs relacionadas a canais.

            switch GuardBand.Mode
                case 'auto'
                    screenFreqStart = refFreqCenter - refBW/2;
                    screenFreqStop  = refFreqCenter + refBW/2;
        
                case 'manual'
                    switch GuardBand.Parameters.Type
                        case 'Fixed'
                            screenFreqStart = refFreqCenter - GuardBand.Parameters.Value/2;
                            screenFreqStop  = refFreqCenter + GuardBand.Parameters.Value/2;
        
                        case 'BWRelated'
                            screenFreqStart = refFreqCenter - GuardBand.Parameters.Value * refBW/2;
                            screenFreqStop  = refFreqCenter + GuardBand.Parameters.Value * refBW/2;
                    end
            end
    
            xIndexDown       = freq2idx(obj, screenFreqStart * 1e+6, 'CheckAndRound', 'fix');
            xIndexUp         = freq2idx(obj, screenFreqStop  * 1e+6, 'CheckAndRound', 'ceil');
            xFrequencyLimits = [screenFreqStart, screenFreqStop];
        end
    end
end