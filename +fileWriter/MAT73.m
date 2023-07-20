function MAT73(filename, prj_specData, prj_Info)

% FILEWRITER_MAT73 *Escrita do arquivo MAT v. 7.3.*
% Escrita de arquivo no formato MAT v. 7.3. O arquivo, ao final da escrita, 
% conterá sete variáveis usadas no *appAnálise*. 

% * Type (cell): "Spectral data"
% * Version (double): 2
% * Source (char): "appAnalise" | "appColeta" | "rfPy"
% * FilesList (cell array)
% * MetaData (struct)
% * SpecData (struct)
% * PrjInfo (struct)

% Versão: *27/10/2022*
    arguments
        filename     char
        prj_specData struct
        prj_Info     struct = []
    end
    
    prj_Version = 2;
    prj_Source  = 'appAnalise';
    
    [prj_RelatedFiles, prj_metaData, prj_specData] = spec2metaData(prj_specData);
    
    if isempty(prj_Info)
        prj_Type     = {'Spectral data'};
        prj_specData = rmfield(prj_specData, {'Emissions', 'reportFlag', 'reportOCC', 'reportDetection', 'reportClassification', 'reportAttachments'});
    else
        prj_Type = {'Project data'};
        idx = Misc_FindOCCData(prj_specData);
        if ~isempty(idx)
            for ii = idx
                prj_specData(ii).reportOCC.Related = prj_specData(ii).reportOCC.Index;
            end
        end
    end
    save(filename, 'prj_Type', 'prj_Version', 'prj_Source', 'prj_RelatedFiles', 'prj_metaData', 'prj_specData', 'prj_Info', '-v7.3')
    
end

% Função auxiiar.
function [prj_RelatedFiles, prj_metaData, prj_specData] = spec2metaData(prj_specData)
    prj_specData(1).Blocks = [];
    for ii = 1:numel(prj_specData)
        prj_specData(ii).statsData = [];
    end
    
    prj_metaData = rmfield(prj_specData, {'Emissions', 'reportFlag', 'reportOCC', 'reportDetection', 'reportClassification', 'reportAttachments'});
    
    prj_RelatedFiles = {};
    for ii = 1:numel(prj_metaData)
        prj_RelatedFiles      = [prj_RelatedFiles; prj_metaData(ii).RelatedFiles.Name];
        prj_metaData(ii).Data = [];
    end
    
    prj_RelatedFiles = unique(prj_RelatedFiles);
        
end