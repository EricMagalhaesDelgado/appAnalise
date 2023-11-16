function MAT(fileName, prj_specData, prj_Info)

    % Author.: Eric Magalhães Delgado
    % Date...: November 15, 2023
    % Version: 3.00

    % MAT v.1 (INCOMPATÍVEL)
    % Data...: 01/07/2021
    % Versões: appAnalise v.1.00 a 1.03
    % Era salva apenas uma única variável "Data" no arquivo .MAT. Essa variável era 
    % uma estrutura com os campos "Type", "Version", "Source", "specData" e "prjInfo".

    % MAT v.2 (LEGADO)
    % Data...: 15/09/2021
    % Versões: appAnalise v.1.04 a 1.39
    % Salva sete variáveis no arquivo .MAT - 'prj_Type', 'prj_Version', 'prj_Source', 
    % 'prj_RelatedFiles', 'prj_metaData', 'prj_specData' e 'prj_Info'.
    % 'prj_metaData' e 'prj_specData' são estruturas, seguindo a organização
    % da variável app.specData.

    % MAT v.3
    % Data...: 15/11/2023
    % Versões: appAnaliseV2 (v.1.51 em diante...)
    % Salva as mesmas sete variáveis da v.2 do arquivo .MAT, mas 'prj_metaData' e 
    % 'prj_specData' são instâncias da classe "class.specData", seguindo a organização
    % da variável app.specData no appAnaliseV2.
    
    % VARIÁVEIS:
    % (1) prj_Version      {double}                                = 2 | 3
    % (2) prj_metaData     {struct (v.2)} | {class.specData (v.3)}
    % (3) prj_specData     {struct (v.2)} | {class.specData (v.3)}
    % (4) prj_Type         {cell}                                  = {'Spectral data'} | {'Project data'}
    % (5) prj_Info         {struct}
    % (6) prj_Source       {char}                                  = 'appAnalise' | 'appColeta' | 'rfPy'
    % (7) prj_RelatedFiles {cell array}
    
    arguments
        fileName
        prj_specData
        prj_Info struct = []
    end
    
    prj_Version = 3;
    prj_Source  = 'appAnalise';
    
    [prj_RelatedFiles, prj_metaData] = spec2metaData(prj_specData);
    
    if isempty(prj_Info)
        prj_Type = {'Spectral data'};
        prj_specData = copy(prj_specData, {'UserData'});

    else
        prj_Type = {'Project data'};
    end
    save(fileName, 'prj_Type', 'prj_Version', 'prj_Source', 'prj_RelatedFiles', 'prj_metaData', 'prj_specData', 'prj_Info', '-v7.3')    
end


%-------------------------------------------------------------------------%
function [prj_RelatedFiles, prj_metaData] = spec2metaData(prj_specData)
    
    prj_metaData     = copy(prj_specData, {'Data', 'UserData'});
    prj_RelatedFiles = {};

    for ii = 1:numel(prj_metaData)
        prj_RelatedFiles = [prj_RelatedFiles; prj_metaData(ii).RelatedFiles.File];
    end    
    prj_RelatedFiles = unique(prj_RelatedFiles);        
end