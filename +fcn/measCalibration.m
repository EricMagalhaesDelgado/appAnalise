function measCalibration(app, OperationType, idx1, idx2, Name)

    % LEITURA DO ARQUIVO E FILTRAGEM
    kFactor = jsondecode(fileread(fullfile(app.RootFolder, 'Settings', 'measCalibration.json')));
    kFactor(~strcmp({kFactor.Name}, Name)) = [];

    FreqStart  = app.specData(idx1).MetaData.FreqStart / 1e+6;
    FreqStop   = app.specData(idx1).MetaData.FreqStop  / 1e+6;
    DataPoints = app.specData(idx1).MetaData.DataPoints;

    measCalibration = app.specData(idx1).UserData.measCalibration;

    switch OperationType
        case 'Add'
            % VALIDAÇÕES        
            if contains(measCalibration.Name, Name)
                error('Curva de correção já incluída!')        
            elseif strcmp(kFactor.Type, 'Antenna k-Factor')
                if contains(measCalibration.Type, 'Antenna k-Factor')
                    error('Já incluída uma curva de correção do tipo "Antenna k-Factor", a qual deve ser previamente excluída antes da inclusão de uma nova.')
                elseif ~ismember(app.specData(idx1).MetaData.LevelUnit, {'dBm', 'dBµV'})
                    error('Para inclusão de uma curva de correção do tipo "Antenna k-Factor", a unidade de medida da faixa monitorada precisa ser "dBm" ou "dBµV".')
                end
            end

            if ~((kFactor.xData(1) <= FreqStart) && (kFactor.xData(end) >= FreqStop))
                error('A curva de correção não engloba a faixa monitorada.')
            end
        
            % UNIDADES INICIAL E FINAL (PÓS-PROCESSAMENTO)
            switch kFactor.Type
                case 'Antenna k-Factor'  
                    oldLevelUnit = app.specData(idx1).MetaData.LevelUnit;
                    newLevelUnit = 'dBµV/m';
                case 'Calibration'
                    oldLevelUnit = app.specData(idx1).MetaData.LevelUnit;
                    newLevelUnit = oldLevelUnit;
            end
            kFactorArray = FactorArray(kFactor, FreqStart, FreqStop, DataPoints, oldLevelUnit);
            
            app.specData(idx1).Data{2} = app.specData(idx1).Data{2} + kFactorArray;
            app.specData(idx1).Data{3} = app.specData(idx1).Data{3} + kFactorArray;
            app.specData(idx1).MetaData.LevelUnit = newLevelUnit;
            app.specData(idx1).UserData.measCalibration(end+1,:) = {kFactor.Name, kFactor.Type, oldLevelUnit, newLevelUnit};

        case 'Remove'
            oldLevelUnit = measCalibration.oldUnitLevel{1};
            kFactorArray = FactorArray(kFactor, FreqStart, FreqStop, DataPoints, oldLevelUnit);
            
            app.specData(idx1).Data{2} = app.specData(idx1).Data{2} - kFactorArray;
            app.specData(idx1).Data{3} = app.specData(idx1).Data{3} - kFactorArray;
            app.specData(idx1).MetaData.LevelUnit = oldLevelUnit;
            app.specData(idx1).UserData.measCalibration(idx2,:) = [];
    end

    layoutFcn.clickEffect(app, idx1, app.misc_Edit_kFactor)
end


%-------------------------------------------------------------------------%
function kFactorArray = FactorArray(kFactor, FreqStart, FreqStop, DataPoints, LevelUnit)

    kFactorArray = interp1(kFactor.xData, kFactor.yData, linspace(FreqStart, FreqStop, DataPoints)', 'spline');

    if strcmp(kFactor.Type, 'Antenna k-Factor') && strcmp(LevelUnit, 'dBm')
        kFactorArray = kFactorArray + 107;
    end
end