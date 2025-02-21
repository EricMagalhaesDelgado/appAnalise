function [ReportProject, emissionFiscalizaTable] = fiscalizaStructureFields(app, idxThreads, reportInfo)

    % Variável que possibilitará o preenchimento dos campos
    % estruturados da inspeção (no Fiscaliza).
    ReportProject = struct('Issue',           app.report_Issue.Value,       ...
                           'Latitude',        [], 'Longitude',          [], ...
                           'City',            [], 'Bands',              [], ...
                           'F0',              [], 'F1',                 [], ...
                           'emissionsValue1',  0, 'emissionsValue2',     0, 'emissionsValue3',     0, ...
                           'Services',        [], 'tableJournal',       []);

    % Preenchimento dos dados...            
    ReportProject.Services = app.General.Models.RelatedServices{reportInfo.Model.idx};
    
    % Definir FreqStart, FreqStop, Latitude, Longitude e City que
    % irão compor inspeção no Fiscaliza.
    ReportProject.Bands = {};
    for ii = idxThreads
        if ismember(app.specData(ii).MetaData.DataType, class.Constants.specDataTypes)
            ReportProject.Bands(end+1) = {sprintf('%.3f - %.3f MHz', app.specData(ii).MetaData.FreqStart / 1e+6, ...
                                                                     app.specData(ii).MetaData.FreqStop  / 1e+6)};
            
            if isempty(ReportProject.Latitude)
                ReportProject.Latitude  = app.specData(ii).GPS.Latitude;
                ReportProject.Longitude = app.specData(ii).GPS.Longitude;
                ReportProject.City      = {sprintf('%s/%s', app.specData(ii).GPS.Location(end-1:end), app.specData(ii).GPS.Location(1:end-3))};
                
                ReportProject.F0 = app.specData(ii).MetaData.FreqStart;
                ReportProject.F1 = app.specData(ii).MetaData.FreqStop;
            
            else
                if ~ismember(app.specData(ii).GPS.Location, ReportProject.City)
                    ReportProject.City{end+1,1} = sprintf('%s/%s', app.specData(ii).GPS.Location(end-1:end), app.specData(ii).GPS.Location(1:end-3));
                end                        
                
                ReportProject.F0 = min(ReportProject.F0, app.specData(ii).MetaData.FreqStart);
                ReportProject.F1 = max(ReportProject.F1, app.specData(ii).MetaData.FreqStop);
            end
        end
    end
    
    % Juntar numa mesma variável a informação gerada pelo algoritmo
    % embarcado no appAnálise (app.peaksTable) com a informação
    % gerada pelo fiscal (app.exceptionList).
    [emissionSummaryTable, infoTable] = reportLibConnection.table.Summary(app.projectData.peaksTable, app.projectData.exceptionList, 'EditedEmissionsTable+TotalSummaryTable');

    ReportProject.emissionsValue1 = sum(infoTable{:,2:4}, 'all');                               % Qtd. emissões
    ReportProject.emissionsValue2 = sum(infoTable{:,2});                                        % Qtd. emissões licenciadas
    ReportProject.emissionsValue3 = sum(infoTable{:,5:8}, 'all');                               % Qtd. emissões identificadas

    % Arquivo JSON
    emissionFiscalizaTable = reportLibConnection.table.fiscalizaJsonFile(app.specData, idxThreads, app.projectData, emissionSummaryTable);
end