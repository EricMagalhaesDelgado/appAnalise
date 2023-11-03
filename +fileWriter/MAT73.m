function MAT73(fileName, prj_specData, prj_Info)

% FILEWRITER_MAT73
% Escrita de arquivo no formato MAT v. 7.3. O arquivo, ao final da escrita, 
% conterá sete variáveis usadas no appAnalise. 
% - prj_Type        (cell): {'Spectral data'} | {'Project data'}
% - prj_Version   (double): 3
% - prj_Source      (char): 'appAnalise' | 'appColeta' | 'rfPy'
% - FilesList (cell array)
% - MetaData      (struct)
% - SpecData      (struct)
% - PrjInfo       (struct)

% Versão: 02/11/2023

    arguments
        fileName
        prj_specData
        prj_Info struct = []
    end
    
    prj_Version = 2;
    prj_Source  = 'appAnalise';
    
    [prj_RelatedFiles, prj_metaData, prj_specData] = spec2metaData(prj_specData);
    
    if isempty(prj_Info)
        prj_Type = {'Spectral data'};
        prj_specData.UserData = class.userData;
    else
        prj_Type = {'Project data'};
    end
    save(fileName, 'prj_Type', 'prj_Version', 'prj_Source', 'prj_RelatedFiles', 'prj_metaData', 'prj_specData', 'prj_Info', '-v7.3')    
end


%-------------------------------------------------------------------------%
function [prj_RelatedFiles, prj_metaData, prj_specData] = spec2metaData(prj_specData)
    
    prj_metaData     = copy(prj_specData, {'Data', 'UserData'});
    prj_RelatedFiles = {};

    for ii = 1:numel(prj_metaData)
        prj_RelatedFiles = [prj_RelatedFiles; prj_metaData(ii).RelatedFiles.File];
    end    
    prj_RelatedFiles = unique(prj_RelatedFiles);        
end