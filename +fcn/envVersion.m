function appVersion = envVersion(rootFolder, versionType, varargin)

    arguments
        rootFolder 
        versionType = 'full'
    end

    arguments (Repeating)
        varargin
    end

    appName = class.Constants.appName;

    switch versionType
        case 'full'
            appVersion = struct('Machine', '', ...
                                'Matlab',  '', ...
                                appName,   struct('release',    class.Constants.appRelease, ...
                                                  'version',    class.Constants.appVersion, ...
                                                  'rootFolder', rootFolder));
        
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
        case 'reportLib'
            global RFDataHub
            global RFDataHub_info
            
            appVersion  = struct('App', struct('name',              appName,                    ...
                                               'release',           class.Constants.appRelease, ...
                                               'version',           class.Constants.appVersion, ...
                                               'rootFolder',        rootFolder,                 ...
                                               'databaseRelease',   RFDataHub_info.ReleaseDate, ...
                                               'databaseRows',      height(RFDataHub),          ...
                                               'databaseNumberOfUniqueStations', numel(unique(RFDataHub.("Station")))));
    end

end