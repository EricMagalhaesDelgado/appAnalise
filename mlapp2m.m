function mlapp2m(MLAPPFiles, showDiffApp)
    arguments
        MLAPPFiles  cell    = {'winAppAnalise', 'winDriveTest', 'winSignalAnalysis', 'winRFDataHub'}
        showDiffApp logical = false
    end

    % Essa função manipula alguns dos arquivos .MLAPP do projeto, gerando
    % versões .M.
    % - "winAppAnalise.mlapp"
    %   A versão .M facilita acompanhamento da evolução do projeto por meio 
    %   do GitHub Desktop (ao invés de executar a comparação linha a linha 
    %   no próprio Matlab).
    %
    % - "winDriveTest", "winSignalAnalysis" e "winRFDataHub"
    %   A versão .M  traz manipulações que possibilitam que esses módulos do 
    %   appAnalise possam ser renderizados na figura de "winAppAnalise".
     
    fileFolder = fileparts(mfilename('fullpath'));    
    
    for ii = 1:numel(MLAPPFiles)
        try
            oldClassName = MLAPPFiles{ii};
            newClassName = [oldClassName '_exported'];

            switch oldClassName
                case 'winAppAnalise'
                    fileBaseName = fullfile(fileFolder, oldClassName);
                    matlabCode   = getMFileContent(fileBaseName);

                    % SUBSTITUIÇÃO: ClassName
                    oldTags = {sprintf('classdef %s < matlab.apps.AppBase', oldClassName), ...
                               sprintf('function app = %s',                 oldClassName)};

                    % VALIDAÇÃO
                    if any(cellfun(@(x) ~contains(matlabCode, x), oldTags))
                        error('Não identificado uma das tags! :(')
                    end

                    newTags = {sprintf('classdef %s < matlab.apps.AppBase', newClassName), ...
                               sprintf('function app = %s',                 newClassName)};

                    matlabCode   = replace(matlabCode, oldTags, newTags);
                    writematrix(matlabCode, [fileBaseName '_exported.m'], 'FileType', 'text', 'WriteMode', 'overwrite', 'QuoteStrings', 'none')

                otherwise
                    switch oldClassName
                        case 'winRFDataHub'
                            fileBaseName = fullfile(fileFolder, oldClassName);
                        otherwise
                            fileBaseName = fullfile(fileFolder, '+auxApp', oldClassName);
                    end
                    
                    matlabCode   = getMFileContent(fileBaseName);

                    % Salva a versão original do .M em pasta temporária, de
                    % forma que possa ser possível visualizar as diferenças
                    % linha a linha no Matlab, caso desejável (argumento de
                    % entrada "showDiffApp").
                    writematrix(matlabCode, fullfile(tempdir, [oldClassName '.m']), 'FileType', 'text', 'WriteMode', 'overwrite', 'QuoteStrings', 'none')

                    oldTag1 = sprintf('classdef %s < matlab.apps.AppBase', oldClassName);
                    oldTag2 = 'function createComponents(app)';
                    oldTag3 = 'app.GridLayout = uigridlayout(app.UIFigure);';
                    oldTag4 = sprintf('function app = %s(varargin)',       oldClassName);

                    % VALIDAÇÃO
                    if any(cellfun(@(x) ~contains(matlabCode, x), {oldTag1, oldTag2, oldTag3, oldTag4}))
                        error('Não identificado uma das tags! :(')
                    end

                    % SUBSTITUIÇÃO 1: ClassName
                    % SUBSTITUIÇÃO 2: CreateComponents
                    % SUBSTITUIÇÃO 3: ClassName+Constructor+Delete
                    matlabCode = replace(matlabCode, oldTag1, Step1Pattern(newClassName));
                    matlabCode = replace(matlabCode, extractBetween(matlabCode, oldTag2, oldTag3, 'Boundaries', 'inclusive'), Step2Pattern);
                    matlabCode = replace(matlabCode, [oldTag4 extractAfter(matlabCode, oldTag4)], Step3Pattern(newClassName));

                    writematrix(matlabCode, [fileBaseName '_exported.m'], 'FileType', 'text', 'WriteMode', 'overwrite', 'QuoteStrings', 'none')

                    if showDiffApp
                        visdiff(fullfile(tempdir, [oldClassName '.m']), [fileBaseName '_exported.m'])
                    end
            end
            fprintf('Criado o arquivo %s\n', [fileBaseName '_exported.m'])

        catch ME
            fprintf('ERRO ao processar o arquivo %s. %s\n', [fileBaseName '.mlapp'], ME.message)
        end
    end
end

%-------------------------------------------------------------------------%
function matlabCode = getMFileContent(fileBaseName)
    readerObj  = appdesigner.internal.serialization.FileReader([fileBaseName '.mlapp']);
    matlabCode = readerObj.readMATLABCodeText();
end

%-------------------------------------------------------------------------%
function step1Pattern = Step1Pattern(newClassName)
    step1Pattern = sprintf('classdef %s < matlab.apps.AppBase', newClassName);
end

%-------------------------------------------------------------------------%
function step2Pattern = Step2Pattern()
    step2Pattern  = sprintf(['function createComponents(app, Container)\n\n'                          ...
        '            %% Create UIFigure and hide until all components are created\n'                  ...
        '            if isempty(Container)\n'                                                         ...
        '                app.UIFigure = uifigure(''Visible'', ''off'');\n'                            ...
        '                app.UIFigure.AutoResizeChildren = ''off'';\n'                                ...
        '                app.UIFigure.Position = [100 100 1244 660];\n'                               ...
        '                app.UIFigure.Name = ''appAnalise'';\n'                                       ...
        '                app.UIFigure.Icon = ''icon_48.png'';\n'                                      ...
        '                app.UIFigure.CloseRequestFcn = createCallbackFcn(app, @closeFcn, true);\n\n' ...
        '                app.Container = app.UIFigure;\n\n'                                           ...
        '            else\n'                                                                          ...
        '                if ~isempty(Container.Children)\n'                                           ...
        '                    delete(Container.Children)\n'                                            ...
        '                end\n\n'                                                                     ...
        '                app.UIFigure  = ancestor(Container, ''figure'');\n'                          ...
        '                app.Container = Container;\n'                                                ...
        '                app.isDocked  = true;\n'                                                     ...
        '            end\n\n'                                                                         ...
        '            %% Create GridLayout\n'                                                          ...
        '            app.GridLayout = uigridlayout(app.Container);']);
end

%-------------------------------------------------------------------------%
function step3Pattern = Step3Pattern(newClassName)
    step3Pattern = sprintf(['function app = %s(Container, varargin)\n\n'         ...
        '            %% Create UIFigure and components\n'                        ...
        '            createComponents(app, Container)\n\n'                       ...
        '            %% Execute the startup function\n'                          ...
        '            runStartupFcn(app, @(app)startupFcn(app, varargin{:}))\n\n' ...
        '            if nargout == 0\n'                                          ...
        '                clear app\n'                                            ...
        '            end\n'                                                      ...
        '        end\n\n'                                                        ...
        '        %% Code that executes before app deletion\n'                    ...
        '        function delete(app)\n\n'                                       ...
        '            %% Delete UIFigure when app is deleted\n'                   ...
        '            if app.isDocked\n'                                          ...
        '                delete(app.Container.Children)\n'                       ...
        '            else\n'                                                     ...
        '                delete(app.UIFigure)\n'                                 ...
        '            end\n'                                                      ...
        '        end\n'                                                          ...
        '    end\n'                                                              ...
        'end'], newClassName);
end