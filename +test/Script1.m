% Principais variáveis do appAnaliseV2
% - app.metaData: objeto da classe class.metaData que armazena nomes dos arquivos 
%                 e os seus metadados.
% - app.specData: objeto da classe class.specData que armazena os fluxos espectrais 
%                 (metadados e matriz de níveis).

app = test.App;
cd(app.RootFolder)

warning('off', 'MATLAB:ui:javaframe:PropertyToBeRemoved')
warning('off', 'MATLAB:subscripting:noSubscriptsSpecified')
warning('off', 'MATLAB:structOnObject')
warning('off', 'MATLAB:class:DestructorError')
warning('off', 'MATLAB:modes:mode:InvalidPropertySet')
warning('off', 'MATLAB:table:RowsAddedExistingVars')


% Lista de arquivos
[fileName, filePath] = uigetfile({'*.bin;*.dbm;*.mat', 'Binários (*.bin,*.dbm,*.mat)'; ...
                                  '*.csv;*.sm1809',    'Textuais (*.csv,*.sm1809)'},   ...
                                  'MultiSelect', 'on');
if isequal(fileName, 0)
    return
elseif ~iscell(fileName)
    fileName = {fileName};
end


% Leitura dos metadados
for ii = 1:numel(fileName)
    fileFullPath  = fullfile(filePath, fileName{ii});
    [~,~,fileExt] = fileparts(fileFullPath);

    relatedFiles = RelatedFiles(app.metaData);
    if ~any(contains(relatedFiles, fileName(ii)))
        idx = numel(app.metaData)+1;
        
        app.metaData(idx).File = fileFullPath;
        app.metaData(idx).Type = 'Spectral data';       
        Read_MetaData(app.metaData(idx), app.RootFolder)
    end
end


% Leitura da matriz de níveis
class.specData.read(app, [])


% Plot em tempo real
hFig  = uifigure;
hAxes = plotFcn.axesDraw.AxesCreation([], 'Cartesian', hFig);
Parameters      = app.General.Plot;
Parameters.Plot = struct('Type', 'Band', 'emissionIndex', -1);

plotFcn.axesDraw.execute('Persistance', hAxes, app.specData(1), Parameters, 'LiveScript')