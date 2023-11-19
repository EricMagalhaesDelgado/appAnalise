function measCalibration(app, idx, Name)

    try
        kFactor = jsondecode(fileread(fullfile(app.RootFolder, 'Settings', 'measCalibration.json')));
        kFactor(~strcmp({kFactor.Name}, Name)) = [];
    
        switch kFactor.Type
            case 'Antenna k-Factor'
                oldLevelUnit = app.specData(idx).MetaData.LevelUnit;
                newLevelUnit = 'dBµV/m';

                if ~ismember(oldLevelUnit, {'dBm', 'dBµV'})
                    error('A unidade de medida da faixa monitorada precisa ser "dBm" ou "dBµV".')
                end

            case 'Calibration'
                oldLevelUnit = app.specData(idx).MetaData.LevelUnit;
                newLevelUnit = oldLevelUnit;
        end
    
        FreqStart  = app.specData(idx).MetaData.FreqStart / 1e+6;
        FreqStop   = app.specData(idx).MetaData.FreqStop  / 1e+6;
        DataPoints = app.specData(idx).MetaData.DataPoints;
        
        if (kFactor.xData(1) <= FreqStart) && (kFactor.xData(end) >= FreqStop)
            kFactorArray = interp1(kFactor.xData, kFactor.yData, linspace(FreqStart, FreqStop, DataPoints)', 'spline');            
            if strcmp(oldLevelUnit, 'dBm')
                kFactorArray = kFactorArray + 107;
            end
            
            app.specData(idx).Data{2} = app.specData(idx).Data{2} + kFactorArray;
            app.specData(idx).Data{3} = app.specData(idx).Data{3} + kFactorArray;
            app.specData(idx).MetaData.LevelUnit = newLevelUnit;
            app.specData(idx).UserData.measCalibration(end+1,:) = {kFactor.Name, kFactor.Type, oldLevelUnit, newLevelUnit};
        
        else
            error('A curva de correção não engloba a faixa monitorada.')
        end

    catch ME
        layoutFcn.modalWindow(app.UIFigure, 'ccTools.MessageBox', getReport(ME));
    end
end