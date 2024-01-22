classdef App < handle

    properties
        %-----------------------------------------------------------------%
        RootFolder = 'C:\P&D\appAnalise';
        General
        
        metaData   = class.metaData.empty
        specData
        channelObj
    end


    methods
        %-----------------------------------------------------------------%
        function obj = App()
            obj.General    = jsondecode(fileread(fullfile(obj.RootFolder, 'Settings', 'GeneralSettings.json')));
            obj.channelObj = class.ChannelLib(obj.RootFolder);
        end
    end
end