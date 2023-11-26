function measCalibration(app, OperationType, idx1, idx2, Name)

    FreqStart  = app.specData(idx1).MetaData.FreqStart / 1e+6;
    FreqStop   = app.specData(idx1).MetaData.FreqStop  / 1e+6;
    DataPoints = app.specData(idx1).MetaData.DataPoints;

    measCalibration = app.specData(idx1).UserData.measCalibration;

    switch OperationType
        case 'Add'
            kFactorTable = FactorTable(app.RootFolder, Name);

            % VALIDAÇÕES        
            if contains(measCalibration.Name, Name)
                error('Curva de correção já incluída!')        
            elseif strcmp(kFactorTable.Type, 'Antenna k-Factor')
                if any(contains(measCalibration.Type, 'Antenna k-Factor'))
                    error('Já incluída uma curva de correção do tipo "Antenna k-Factor", a qual deve ser previamente excluída antes da inclusão de uma nova.')
                elseif ~ismember(app.specData(idx1).MetaData.LevelUnit, {'dBm', 'dBµV'})
                    error('Para inclusão de uma curva de correção do tipo "Antenna k-Factor", a unidade de medida da faixa monitorada precisa ser "dBm" ou "dBµV".')
                end
            end

            if ~((kFactorTable.xData(1) <= FreqStart) && (kFactorTable.xData(end) >= FreqStop))
                error('A curva de correção não engloba a faixa monitorada.')
            end
        
            % UNIDADES INICIAL E FINAL (PÓS-PROCESSAMENTO)
            switch kFactorTable.Type
                case 'Antenna k-Factor'  
                    oldLevelUnit = app.specData(idx1).MetaData.LevelUnit;
                    newLevelUnit = 'dBµV/m';
                case 'Calibration'
                    if isempty(measCalibration)
                        oldLevelUnit = app.specData(idx1).MetaData.LevelUnit;
                    else
                        oldLevelUnit = measCalibration.oldUnitLevel{1};
                    end
                    newLevelUnit = oldLevelUnit;
            end
            kFactorArray = FactorArray(kFactorTable, FreqStart, FreqStop, DataPoints, oldLevelUnit);
            
            app.specData(idx1).Data{2} = app.specData(idx1).Data{2} + kFactorArray;
            app.specData(idx1).Data{3} = app.specData(idx1).Data{3} + kFactorArray;
            app.specData(idx1).MetaData.LevelUnit = newLevelUnit;

            app.specData(idx1).UserData.measCalibration(end+1,:) = {kFactorTable.Name, kFactorTable.Type, oldLevelUnit, newLevelUnit};
            app.specData(idx1).UserData.measCalibration          = sortrows(app.specData(idx1).UserData.measCalibration, 'Type', 'descend');

        case 'Remove'
            oldLevelUnit = measCalibration.oldUnitLevel{1};

            for ii = numel(idx2):-1:1
                kFactorTable = FactorTable(app.RootFolder, Name{ii});                
                kFactorArray = FactorArray(kFactorTable, FreqStart, FreqStop, DataPoints, oldLevelUnit);
                
                app.specData(idx1).Data{2} = app.specData(idx1).Data{2} - kFactorArray;
                app.specData(idx1).Data{3} = app.specData(idx1).Data{3} - kFactorArray;
                app.specData(idx1).MetaData.LevelUnit = oldLevelUnit;
                app.specData(idx1).UserData.measCalibration(idx2(ii),:) = [];
            end
    end

    SelectedNodesTextList = edit_SelectedNodesText(app);
    hComp = app.misc_Edit_kFactor;
    play_TreeRebuilding(app, SelectedNodesTextList, hComp)
end


%-------------------------------------------------------------------------%
function kFactorTable = FactorTable(RootFolder, Name)
    kFactorTable = jsondecode(fileread(fullfile(RootFolder, 'Settings', 'measCalibration.json')));
    kFactorTable(~strcmp({kFactorTable.Name}, Name)) = [];
end


%-------------------------------------------------------------------------%
function kFactorArray = FactorArray(kFactor, FreqStart, FreqStop, DataPoints, LevelUnit)
    kFactorArray = interp1(kFactor.xData, kFactor.yData, linspace(FreqStart, FreqStop, DataPoints)', 'linear');
    if strcmp(kFactor.Type, 'Antenna k-Factor') && strcmp(LevelUnit, 'dBm')
        kFactorArray = kFactorArray + 107;
    end
end