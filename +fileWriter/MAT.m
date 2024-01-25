function MAT(fileName, fileType, prj_specData, prj_Info)

    % Author.: Eric Magalhães Delgado
    % Date...: November 15, 2023
    % Version: 3.00

    % MAT v.1 (INCOMPATÍVEL)
    % Data...: 01/07/2021
    % Versões: appAnaliseV1 (v.1.00 a 1.03)
    % Informação organizada em uma única variável "Data". Essa variável era 
    % uma estrutura com os campos "Type", "Version", "Source", "specData" e 
    % "prjInfo".

    % MAT v.2 (LEGADO)
    % Data...: 15/09/2021
    % Versões: appAnaliseV1 (v.1.04 a 1.39)
    % Informação organizada em 7 variáveis no arquivo .MAT - 'prj_Type', 
    % 'prj_Version', 'prj_Source', 'prj_RelatedFiles', 'prj_metaData', 
    % 'prj_specData' e 'prj_Info'.
    % As variáveis 'prj_metaData' e 'prj_specData' são estruturas, seguindo 
    % a antiga organização da variável app.specData.

    % MAT v.3
    % Data...: 15/11/2023
    % Versões: appAnaliseV2 (v.1.51 em diante...)
    % Informação organizada nas mesmas 7 variáveis contempladas na v.2 do 
    % arquivo .MAT, com a diferença que 'prj_metaData' e 'prj_specData' não 
    % são estruturas, mas instâncias da classe "class.specData", seguindo a 
    % nova organização da variável app.specData.
    
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
        fileType
        prj_specData
        prj_Info struct = []
    end
    
    prj_Version = 3;
    prj_Source  = 'appAnalise';
    
    [prj_RelatedFiles, prj_metaData] = spec2metaData(prj_specData);
    
    switch fileType
        case 'SpectralData'
            prj_Type = {'Spectral data'};
            prj_specData = copy(prj_specData, {'UserData'});

        case 'ProjectData'
            prj_Type = {'Project data'};

        case 'UserData'
            prj_Type = {'User data'};
            prj_specData = copy(prj_specData, {'Data'});
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