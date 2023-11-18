function measCalibration(app, kFactorTable)

    % ESSA FUNCIONALIDADE SERÁ EMBARCADA NO APP AUXILIAR SETTINGS.

    % % app.axes4
    % axtoolbar(app.axes4, 'restoreview');
    % app.axes4.Interactions = [rulerPanInteraction, dataTipInteraction];
    % enableDefaultInteractivity(app.axes4)

    if nargin < 2
        kFactorTable = jsondecode(fileread(fullfile(app.RootFolder, 'Settings', 'measCalibration.json')));
    end

    idx = find(strcmp({kFactorTable.Name}, app.Info_Unit_Antenna.Value), 1);
    if ~isempty(idx)
        xArray = kFactorTable(idx).Data(:,1);
        yArray = kFactorTable(idx).Data(:,2);

        kFatorLine = plot(app.axes4, xArray, yArray, Color=app.General.Colors(4,:));
        plotFcn.DataTipModel(kFatorLine, 'dB')
        
        drawnow
    end
end