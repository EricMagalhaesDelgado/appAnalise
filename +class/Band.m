classdef Band < handle

    properties
        %-----------------------------------------------------------------%
        Context
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
            switch obj.Context
                case 'appAnalise:PLAYBACK'
                  % axesLimits = struct('xLim', {}, 'yLevelLim', {}, 'yTimeLim', {})
                    axesLimits = playbackLimits(obj, idx);

                case 'appAnalise:REPORT'
                    axesLimits = reportLimits(obj, idx);
                    error('PENDENTE AJUSTAR IMPLEMENTAÇÃO')

                case 'appAnalise:SIGNALANALYSIS'
                    idxEmission = varargin{1};
                    axesLimits = playbackAutomaticLimits(obj, idx, idxEmission);
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
        
                        case 'appAnalise:SIGNALANALYSIS'
                            YArray = specData.Data{3}(:,idxFcn)';
                    end

                case 'WaterfallTime'
                     XArray = [obj.xArray(1), obj.xArray(end)];

                    switch obj.Context
                        case 'appAnalise:PLAYBACK'
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
        function axesLimits = playbackLimits(obj, idx)
            specData = obj.callingApp.specData(idx);

            switch specData.UserData.customPlayback.Type
                case 'manual'
                    xLim      = specData.UserData.customPlayback.Parameters.Controls.FrequencyLimits;
                    yLevelLim = specData.UserData.customPlayback.Parameters.Controls.LevelLimits;
                    cLim      = specData.UserData.customPlayback.Parameters.Waterfall.LevelLimits;

                    if issorted(xLim, 'strictascend') && issorted(yLevelLim, 'strictascend') && issorted(cLim, 'strictascend')
                        axesLimits = struct('xLim',      xLim,      ...
                                            'yLevelLim', yLevelLim, ...
                                            'cLim',      cLim);

                        axesLimits.yTimeLim = [specData.Data{1}(1), specData.Data{1}(end)];
                        if specData.Data{1}(1) == specData.Data{1}(end)
                            axesLimits.yTimeLim(2) = axesLimits.yTimeLim(2) + seconds(1);
                        end

                    else
                        axesLimits = playbackAutomaticLimits(obj, idx);
                    end

            otherwise
                axesLimits = playbackAutomaticLimits(obj, idx);
            end
        end

        %-----------------------------------------------------------------%
        function axesLimits = playbackAutomaticLimits(obj, idx, idxEmission)
            arguments
                obj
                idx
                idxEmission = -1
            end
            specData   = obj.callingApp.specData(idx);

            % xLimits
            switch obj.Context
                case {'appAnalise:PLAYBACK', 'appAnalise:REPORT:BAND'}
                    xLimits = [obj.FreqStart, obj.FreqStop];

                case {'appAnalise:REPORT:EMISSION', 'appAnalise:SIGNALANALYSIS'}
                    projectData = obj.callingApp.projectData;

                    if obj.callingApp.projectData.peaksTable.BW(idxEmission) ~= 0
                        F0_axes = projectData.peaksTable.Frequency(idxEmission) - 2.5*projectData.peaksTable.BW(idxEmission)/1000;
                        F1_axes = projectData.peaksTable.Frequency(idxEmission) + 2.5*projectData.peaksTable.BW(idxEmission)/1000;
                    else
                        F0_axes = projectData.peaksTable.Frequency(idxEmission) - .5;
                        F1_axes = projectData.peaksTable.Frequency(idxEmission) + .5;
                    end

                    xLimits = [F0_axes, F1_axes];
            end
        
            % yLevelLimits
            DataType     = specData.MetaData.DataType;
            if ismember(DataType, class.Constants.specDataTypes)
                % yLimits
                minArray = sort(specData.Data{3}(:,1));
                maxArray = sort(specData.Data{3}(:,3), 'descend');

                nSamples = ceil(.01*numel(minArray));
                minValue = median(minArray(1:nSamples));
                maxValue = median(maxArray(1:nSamples));

                downYLim = minValue - mod(minValue, 5);
                upYLim   = maxValue - mod(maxValue, 10) + 10;

                % cLimits
                downCLim = RF.noiseEstimation(specData, .05, .15, 3);
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
                error('Band:playbackAutomaticLimits:UnexpectedDataType', 'UnexpectedDataType')
            end
            yLevelLimits = [downYLim, upYLim];
        
            if diff(yLevelLimits) > class.Constants.yMaxLimRange
                yLevelLimits(1) = yLevelLimits(1) + diff(yLevelLimits) - class.Constants.yMaxLimRange;
            end

            axesLimits.xLim      = xLimits;
            axesLimits.yLevelLim = yLevelLimits;
            axesLimits.cLim      = [downCLim, upCLim];

            % yTimeLimits
            axesLimits.yTimeLim  = [specData.Data{1}(1), specData.Data{1}(end)];
            if specData.Data{1}(1) == specData.Data{1}(end)
                axesLimits.yTimeLim(2) = axesLimits.yTimeLim(2) + seconds(1);
            end
        end

        %-----------------------------------------------------------------%
        function [xLim, yLim, zLim, xIndexLim, xLimitedArray] = reportLimits(obj, idx, Parameters, yUnit)
            specData = obj.callingApp.specData(idx);

            switch Parameters.Plot.Type
                case 'Band'
                    FreqStartView = obj.FreqStart;
                    FreqStopView  = obj.FreqStop;
                    xIndexLim     = [1, obj.DataPoints];

                case 'Emission'
                    emissionIndex = Parameters.Plot.emissionIndex;
                    if emissionIndex == -1
                        error('Unexpected value.')
                    end
    
                    emissionBW    = specData.UserData.Emissions.BW(emissionIndex)/1000;
                    xGuardBand    = Parameters.Axes.xGuardBandFactor * emissionBW;
    
                    FreqStartView = specData.UserData.Emissions.Frequency(emissionIndex) - (emissionBW + xGuardBand)/2;
                    FreqStopView  = specData.UserData.Emissions.Frequency(emissionIndex) + (emissionBW + xGuardBand)/2;
                    xIndexLim     = [freq2idx(obj, FreqStartView*1e+6, 'fix'), freq2idx(obj, FreqStopView*1e+6, 'ceil')];

                    xLimitedArray = obj.xArray(xIndexLim(1):xIndexLim(2));
            end

            xLim = [FreqStartView, FreqStopView];

            switch yUnit
                case {'ordinary level', 'persistance level'}
                    yLim = yzLimits(obj, specData, yUnit, xIndexLim);
                    zLim = [-1, 1];
                case 'occupancy level'
                    yLim = [0, 100];
                    zLim = [-1, 1];
                case 'time'
                    yLim = [SpecInfo.Data{1}(1), SpecInfo.Data{1}(end)];
                    zLim = yzLimits(obj, specData, yUnit, xIndexLim);
                case 'timeIndex'
                    yLim = [1, numel(SpecInfo.Data{1})];
                    zLim = [-1, 1];
            end
        end

        %-----------------------------------------------------------------%
        function yzLim = yzLimits(obj, specData, yUnit, xIndexLim)
            yzLim  = [min(specData.Data{3}(xIndexLim(1):xIndexLim(2),1)), ...
                      max(specData.Data{3}(xIndexLim(1):xIndexLim(2),end))];

            if ismember(yUnit, {'persistance level', 'time'})
                yzAmplitude = class.Constants.yMaxLimRange;

                yzLim(2)    = max(yzLim(1)+yzAmplitude, yzLim(2));
                yzLim(1)    = yzLim(2)-yzAmplitude;
            end
        end
    end
end