function appVersion = envVersion(rootFolder, versionType, tempDir)

    arguments
        rootFolder  char
        versionType char {mustBeMember(versionType, {'full', 'full+Python'})} = 'full'
        tempDir     char = ''
    end

    appName = class.Constants.appName;

    appVersion = struct('Machine',   '',                                              ...
                        'Matlab',    '',                                              ...
                        appName,     struct('release',    class.Constants.appRelease, ...
                                            'version',    class.Constants.appVersion, ...
                                            'rootFolder', rootFolder),                ...
                        'RFDataHub', [],                                              ...
                        'Python',    [],                                              ...
                        'fiscaliza', []);

    % OS
    appVersion.Machine = struct('platform',     ccTools.fcn.OperationSystem('platform'),     ...
                                'version',      ccTools.fcn.OperationSystem('ver'),          ...
                                'computerName', ccTools.fcn.OperationSystem('computerName'), ...
                                'userName',     ccTools.fcn.OperationSystem('userName'));

    % OpenGL
    graphRender = '';
    try
        graphRender = opengl('data');
        graphRender = rmfield(graphRender, {'MaxTextureSize', 'Visual', 'SupportsGraphicsSmoothing', 'SupportsDepthPeelTransparency', 'SupportsAlignVertexCenters', 'Extensions', 'MaxFrameBufferSize'});
    catch
    end

    % MATLAB    
    [matVersion, matReleaseDate] = version;
    matProducts = struct2table(ver);
    appVersion.Matlab  = struct('version',  sprintf('%s (Release date: %s)', matVersion, matReleaseDate),   ...
                                'rootPath', matlabroot,                                                     ...
                                'products', strjoin(matProducts.Name + " v. " + matProducts.Version, ', '), ...
                                'openGL',   graphRender);

    % RFDataHub
    global RFDataHub
    global RFDataHub_info

    if isempty(RFDataHub) || isempty(RFDataHub_info)
        model.RFDataHub.read(appName, rootFolder, tempDir)
    end
    appVersion.RFDataHub = RFDataHub_info;   

    % PYTHON
    if versionType == "full+Python"
        pyEnv = pyenv;
        if isfile(pyEnv.Executable)
            appVersion.Python = struct('Version', pyEnv.Version, 'Path', pyEnv.Home);
    
            try
                [~, pyPackages]  = system(fullfile(pyEnv.Home, 'Scripts', 'pip list'));
                pyPackages_table = struct2table(regexp(pyPackages, '(?<lib>[a-zA-Z0-9_-]*)\s*(?<ver>[0-9.]+)\n', 'names'));
        
                appVersion.Python.Packages = strjoin(pyPackages_table.lib + " v. " + pyPackages_table.ver, ', ');

                % fiscaliza
                idxFind = find(pyPackages_table.lib == "fiscaliza", 1);
                if ~isempty(idxFind)
                    appVersion.fiscaliza = pyPackages_table.ver{idxFind};
                end
            catch
            end
        end
    end
end