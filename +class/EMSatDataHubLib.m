classdef (Abstract) EMSatDataHubLib
    
    methods (Static = true)
        %-----------------------------------------------------------------%
        function chList = read_PlanoFrequenciaSatelite(Filename, columnName, columnListOfValues)

            chTable = readtable(Filename);
            chTable = chTable(ismember(chTable.(columnName), columnListOfValues), :);

            % Conversões esquisitas de algumas colunas que serão usadas e que 
            % imagino que não precisem ser feita caso sejam ajustados aspectos 
            % da geração do XLSX.
            chTable.TPDR_SAT_ANATEL_ID     = int64(chTable.TPDR_SAT_ANATEL_ID);
            chTable.TPDR_BW                = chTable.TPDR_BW/100;
            chTable.TPDR_FREQ_CENTRAL_UP   = chTable.TPDR_FREQ_CENTRAL_UP/10;
            chTable.TPDR_FREQ_CENTRAL_DOWN = chTable.TPDR_FREQ_CENTRAL_DOWN/10;
            chTable.TPDR_OCUPACAO_TOTAL    = chTable.TPDR_OCUPACAO_TOTAL/100;
            chTable.TPDR_OCUPACAO_BR       = chTable.TPDR_OCUPACAO_BR/100;

            chList  = struct('Name',          {}, ...
                             'Band',          [], ...
                             'FirstChannel',  [], ...
                             'LastChannel',   [], ...
                             'StepWidth',     [], ...
                             'ChannelBW',     [], ...
                             'FreqList',      [], ...
                             'Reference',     '', ...
                             'FindPeaksName', '');

            for ii = 1:height(chTable)
                CF  = chTable.TPDR_FREQ_CENTRAL_DOWN(ii);
                BW  = chTable.TPDR_BW(ii);
                GBW = ceil(BW / 20);

                chList(ii).Name          = sprintf('SAT %s', chTable.TPDR_DESIG_INT{ii});
                chList(ii).Band          = [CF-BW/2-GBW, CF+BW/2+GBW];
                chList(ii).FirstChannel  = CF;
                chList(ii).LastChannel   = -1;
                chList(ii).StepWidth     = -1;
                chList(ii).ChannelBW     = chTable.TPDR_BW(ii);
                chList(ii).FreqList      = [];
                chList(ii).Reference     = jsonencode(chTable(ii, {'TPDR_SNAPSHOT_DT', 'TPDR_SAT_ANATEL_ID', 'TPDR_DESIG_INT', 'TPDR_CODE', 'TPDR_LICENCIADO_BRASIL', 'TPDR_TECNOLOGIA', 'TPDR_FEIXE_DOWN', 'TPDR_FEIXE_POLARIZ_DOWN', 'TPDR_OBS'}));
                chList(ii).FindPeaksName = 'Satellite A';
            end    
        end
    end
end