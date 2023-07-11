classdef specData

    % No desenvolvimento do appAnaliseV2 (com versões webapp e desktop),
    % ajustar nomenclatura de alguns campos, dentre eles:
    % (a) "Node" → "Receiver"
    % (b) "ThreadID" → "ID"
    % (c) Eliminar subcampos "ThreadID" e "SampleTime" do campo "MetaData".
    %     Criar um método que retorne o "tempo de revisita médio" a partir
    %     do vetor de timestamp.
    % (d) Padronizar nomenclatura do TraceMode (atualmente à relacionada ao
    %     CRFS Bin difere da relacionada aos outros arquivos).
    % (e) Coisas que não são comuns a todos os leitores devem ser
    %     encapsuladas em "UserData". Por exemplo, "Blocks" é comum apenas 
    %     ao leitor do CRFS Bin, devendo ser encapsulada em "Blocks".
    % (f) Método que retorne o "ObservationTime", eliminando o campo.
    %     Eliminar o campo "Samples" também.
    % (g) "TaskName" → "taskName"... e "relatedFiles", "relatedGPS",
    %     "fileFormat" e por aí vai...
    % (h) Criar campo "TraceIntegration".
    % (i) Campo pra receber outras informações, como a máscara espectral - 
    %     pode ser o próprio "UserData".

    properties
        Node
        ThreadID
        MetaData = struct('DataType',    [], ...                            % Valor numérico: RFlookBin (1-2), CRFS Bin (4, 7-8, 60-65 e 67-69), Argus (167-168), CellPlan (1000) e SM1809 (1809)
                          'ThreadID',    [], ...
                          'FreqStart',   [], ...                            % Valor numérico (em Hertz)
                          'FreqStop',    [], ...                            % Valor numérico (em Hertz)
                          'LevelUnit',   [], ...                            % 1 (dBm) | 2 (dBµV) | 3 (dBµV/m)
                          'DataPoints',  [], ...
                          'Resolution',  [], ...                            % Valor numérico (em Hertz) - caso não registrado em arquivo, valor igual a -1
                          'SampleTime',  [], ...
                          'Threshold',   [], ...
                          'TraceMode',   [], ...                            % CRFS Bin: 1 (Single Measurement) | 2 (Mean)    | 3 (Peak)    | 4 (Minimum)
                                             ...                            % Outros..: 1 (ClearWrite)         | 2 (Average) | 3 (MaxHold) | 4 (MinHold)
                          'Detector',    [], ...                            % 1 (Sample) | 2 (Average/RMS) | 3 (Positive Peak) | 4 (Negative Peak)
                          'metaString',  []);                               % {Unit, Resolution, traceMode, Detector, antennaName}
        ObservationTime
        Samples
        Data
        statsData
        FileFormat
        TaskName
        Description
        RelatedFiles
        RelatedGPS
        gps
        UserData
    end

    methods (Static = true)
        %-----------------------------------------------------------------%
        function str = id2str(Type, id)        
            switch Type
                case 'TraceMode'
                    switch id
                        case 1; str = 'ClearWrite';
                        case 2; str = 'Average';
                        case 3; str = 'MaxHold';
                        case 4; str = 'MinHold';
                    end
        
                case 'Detector'
                    switch id
                        case 1; str = 'Sample';
                        case 2; str = 'Average/RMS';
                        case 3; str = 'Positive Peak';
                        case 4; str = 'Negative Peak';
                    end
        
                case 'LevelUnit'
                    switch id
                        case 1; str = 'dBm';
                        case 2; str = 'dBµV';
                        case 3; str = 'dBµV/m';
                    end
            end        
        end


        %-----------------------------------------------------------------%
        function ID = str2id(Type, Value)        
            switch Type
                case 'TraceMode'
                    switch Value
                        case 'ClearWrite'; ID = 1;
                        case 'Average';    ID = 2;
                        case 'MaxHold';    ID = 3;
                        case 'MinHold';    ID = 4;
                    end
        
                case 'Detector'
                    switch Value
                        case 'Sample';        ID = 1;
                        case 'Average/RMS';   ID = 2;
                        case 'Positive Peak'; ID = 3;
                        case 'Negative Peak'; ID = 4;
                    end
        
                case 'LevelUnit'
                    switch Value
                        case 'dBm';                ID = 1;
                        case {'dBµV', 'dBμV'};     ID = 2;
                        case {'dBµV/m', 'dBμV/m'}; ID = 3;
                    end
            end        
        end
    end
end