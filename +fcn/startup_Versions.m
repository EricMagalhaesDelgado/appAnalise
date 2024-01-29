function appVersion = startup_Versions(ReadType, RootFolder)

    appVersion = struct('OS', '', 'Matlab', '', 'OpenGL', '', class.Constants.appName, struct('Release', class.Constants.appRelease, ...
                                                                                              'Version', class.Constants.appVersion, ...
                                                                                              'RootFolder', RootFolder),             ...
                        'Python', '', 'fiscaliza', '', 'RFDataHub', '');

    % OS
    [~, WindowsVersion] = system('ver');
    appVersion.OS = strtrim(WindowsVersion);

    % MATLAB    
    [matVersion, matReleaseDate] = version;    
    matProducts = struct2table(ver);
    appVersion.Matlab = struct('Version',  sprintf('%s (Release date: %s)', matVersion, matReleaseDate), ...
                               'Path',     matlabroot,                                                   ...
                               'Products', strjoin(matProducts.Name + " v. " + matProducts.Version, ', '));

    % OpenGL
    graphRender = opengl('data');
    appVersion.OpenGL = rmfield(graphRender, {'MaxTextureSize', 'Visual', 'SupportsGraphicsSmoothing', 'SupportsDepthPeelTransparency', 'SupportsAlignVertexCenters', 'Extensions', 'MaxFrameBufferSize'});
        
    % PYTHON
    Python = pyenv;
    if isfile(Python.Executable)
        appVersion.Python = struct('Version', Python.Version, ...
                                   'Path', Python.Home);

        if ReadType == "Full"
            try
                [~, pyPackages]  = system(fullfile(Python.Home, 'Scripts', 'pip list'));
                pyPackages_table = struct2table(regexp(pyPackages, '(?<lib>[a-zA-Z0-9_-]*)\s*(?<ver>[0-9.]+)\n', 'names'));
        
                appVersion.Python.Packages = strjoin(pyPackages_table.lib + " v. " + pyPackages_table.ver, ', ');

                % fiscaliza
                idx = find(pyPackages_table.lib == "fiscaliza", 1);
                if ~isempty(idx)
                    appVersion.fiscaliza = pyPackages_table.ver{idx};
                end
            catch
            end
        end
    end

    % RFDataHub
    global RFDataHub
    global RFDataHub_info

    if isempty(RFDataHub) || isempty(RFDataHub_info)
        class.RFDataHub.read(RootFolder)
    end
    appVersion.RFDataHub = RFDataHub_info;   
end