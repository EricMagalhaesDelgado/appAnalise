function CRFSBin(fileName, SpecInfo)

    % Escrita de arquivo no formato CRFS BIN (versão 5). O conteúdo do arquivo é 
    % extraído da variável "specData", sendo possível a geração dos tipos de 
    % dados 21 (Informações textuais), 40 (GPS), 67 (Espectro) e 69 (Ocupação).

    % Author.: Eric Magalhães Delgado
    % Date...: November 26, 2023
    % Version: 1.01

    arguments
        fileName
        SpecInfo
    end
    
    fileID = fopen(fileName, 'w+');
    
    % Format
    fwrite(fileID, 23, 'int32');
    fwrite(fileID, ['CRFS DATA FILE V023' zeros(1, 13)], 'char*1');
    
    % Unit Information (DataType 21)
    Write_DataType21(fileID, SpecInfo(1))
    
    % GPS data (DataType 40)
    if SpecInfo(1).GPS.Status
        Write_DataType40(fileID, SpecInfo(1))
    end
    
    % Spectral data (DataType 67) and OCC data (DataType 69)
    SPECTYPES = [4, 7, 60, 61, 63, 64, 67, 68];
    OCCTYPES  = [8, 62, 65, 69];

    for ii = 1:numel(SpecInfo)
        nSweep = numel(SpecInfo(ii).Data{1});
        
        switch SpecInfo(ii).MetaData.Antenna.SwitchMode
            case 'manual'; antennaPort = SpecInfo(ii).MetaData.Antenna.Port;
            case 'auto';   antennaPort = 0;
        end
        
        if ismember(SpecInfo(ii).MetaData.DataType, SPECTYPES)
            for jj = 1:nSweep
                Write_DataType67(fileID, SpecInfo(ii), antennaPort, jj)
            end
            
        elseif ismember(SpecInfo(ii).MetaData.DataType, OCCTYPES)
            for jj = 1:nSweep
                Write_DataType69(fileID, SpecInfo(ii), antennaPort, jj)
            end
        end
    end
    
    fclose(fileID);
end


%-------------------------------------------------------------------------%
function Write_BlockHeader(fileID, ThreadID, BytesBlock, DataType)
    
    fwrite(fileID, [ThreadID, BytesBlock], 'uint32');
    fwrite(fileID, DataType, 'int32');    
end


%-------------------------------------------------------------------------%
function Write_BlockTrailer(fileID, BytesBlock)
    
    fseek(fileID, -(12+BytesBlock), 'cof');
    CheckSumAdd = fread(fileID, (12+BytesBlock), 'uint8');
    CheckSumAdd = uint32(sum(CheckSumAdd));
    fseek(fileID, 0, 'cof');                                                % Artifício que possibilita escrita após leitura.
    
    fwrite(fileID, CheckSumAdd, 'uint32');
    fwrite(fileID, 'UUUU',      'char*1');    
end


%-------------------------------------------------------------------------%
function Write_DataType21(fileID, SpecInfo)
    
    Hostname = SpecInfo.Receiver;
    Hostname = [Hostname zeros(1, 16-length(Hostname))];
    
    unitInfo = 'Stationary';
    if mod(length(unitInfo), 4)
        unitInfo = [unitInfo zeros(1, 4-mod(length(unitInfo), 4))];
    end
    unitInfoLength = numel(unitInfo);
    
    method = SpecInfo.RelatedFiles.Task{1};
    if mod(length(method), 4)
        method = [method zeros(1, 4-mod(length(method), 4))];
    end    
    methodLength = numel(method);
    
    FileNumber = 0;
    BytesBlock = 28 + unitInfoLength + methodLength;
    
    Write_BlockHeader(fileID, 0, BytesBlock, 21);
    
    fwrite(fileID, Hostname,       'char*1');
    fwrite(fileID, unitInfoLength, 'uint32');
    fwrite(fileID, unitInfo,       'char*1');
    fwrite(fileID, methodLength,   'uint32');
    fwrite(fileID, method,         'char*1');
    fwrite(fileID, FileNumber,     'uint32');
    
    Write_BlockTrailer(fileID, BytesBlock)    
end


%-------------------------------------------------------------------------%
function Write_DataType40(fileID, SpecInfo)
    
    Write_BlockHeader(fileID, 1, 40, 40);
    
    fwrite(fileID,   day(SpecInfo.Data{1}(1)));                             % Wall Clock Date
    fwrite(fileID, month(SpecInfo.Data{1}(1)));
    fwrite(fileID,  year(SpecInfo.Data{1}(1))-2000);
    fwrite(fileID, 0);
    
    fwrite(fileID,   hour(SpecInfo.Data{1}(1)));                            % Wall Clock Time
    fwrite(fileID, minute(SpecInfo.Data{1}(1)));
    fwrite(fileID, second(SpecInfo.Data{1}(1)));
    fwrite(fileID, 0);
        
    fwrite(fileID, 0, 'uint32');                                            % Wall Clock Nanoseeconds
    
    fwrite(fileID,   day(SpecInfo.Data{1}(1)));                             % Wall Clock Date
    fwrite(fileID, month(SpecInfo.Data{1}(1)));
    fwrite(fileID,  year(SpecInfo.Data{1}(1))-2000);
    fwrite(fileID, 0);
    
    fwrite(fileID,   hour(SpecInfo.Data{1}(1)));                            % Wall Clock Time
    fwrite(fileID, minute(SpecInfo.Data{1}(1)));
    fwrite(fileID, second(SpecInfo.Data{1}(1)));
    fwrite(fileID, 0);
        
    fwrite(fileID, SpecInfo.GPS.Status);                                    % Positional fix and status of first GPS block
    fwrite(fileID, 0);                                                      % Sattelites
    fwrite(fileID, 0, 'uint16');                                            % Heading
    fwrite(fileID, SpecInfo.GPS.Latitude  .* 1e+6, 'int32');                % Latitude   (mean)
    fwrite(fileID, SpecInfo.GPS.Longitude .* 1e+6, 'int32');                % Longitude  (mean)
    fwrite(fileID, 0, 'uint32');                                            % Speed
    fwrite(fileID, 0, 'uint32');                                            % Altitude
        
    Write_BlockTrailer(fileID, 40)
end


%-------------------------------------------------------------------------%
function Write_DataType67(fileID, SpecInfo, antennaPort, idx)
    
    % Description
    Description = SpecInfo.RelatedFiles.Description{1};
    if mod(length(Description), 4)
        Description = [Description zeros(1,4-mod(length(Description), 4))];
    end
    
    % NPAD and NDATA
    NPAD  = 0;
    NDATA = SpecInfo.MetaData.DataPoints;
    
    BytesBlock = 68 + length(Description) + NDATA;
    if mod(BytesBlock, 4)
        NPAD = 4-mod(BytesBlock, 4);
        BytesBlock = BytesBlock + NPAD;
    end
    
    Write_BlockHeader(fileID, SpecInfo.RelatedFiles.ID(1), BytesBlock, 67);
    
    fwrite(fileID,   day(SpecInfo.Data{1}(idx)));                           % WALLDATE
    fwrite(fileID, month(SpecInfo.Data{1}(idx)));
    fwrite(fileID,  year(SpecInfo.Data{1}(idx))-2000);
    fwrite(fileID, 0);
    
    fwrite(fileID,   hour(SpecInfo.Data{1}(idx)));                          % WALLTIME
    fwrite(fileID, minute(SpecInfo.Data{1}(idx)));
    fwrite(fileID, second(SpecInfo.Data{1}(idx)));
    fwrite(fileID, 0);
    fwrite(fileID, (second(SpecInfo.Data{1}(idx))-fix(second(SpecInfo.Data{1}(idx))))*1e+9, 'uint32');
    
    fwrite(fileID, zeros(1, 2), 'uint32');                                  % Group ID and Dynamic ID
    
    fwrite(fileID, length(Description), 'uint32');
    fwrite(fileID, Description, 'char*1');
    
    F0 = SpecInfo.MetaData.FreqStart ./ 1e+6;                               % FreqStart in MHz
    IntegerPart = fix(F0);
    DecimalPart = round((F0 - IntegerPart).*1e+3);
    fwrite(fileID, IntegerPart, 'uint16');
    fwrite(fileID, DecimalPart, 'int32');
    
    F1 = SpecInfo.MetaData.FreqStop ./ 1e+6;                                % FreqStop in MHz
    IntegerPart = fix(F1);
    DecimalPart = round((F1 - IntegerPart).*1e+3);
    fwrite(fileID, IntegerPart, 'uint16');
    fwrite(fileID, DecimalPart, 'int32');
    
    if ~isempty(SpecInfo.MetaData.Resolution)                               % Resolution in Hz
        fwrite(fileID, SpecInfo.MetaData.Resolution, 'int32');
    else
        fwrite(fileID, -1, 'int32');
    end
    
    fwrite(fileID, zeros(1, 2), 'uint16');                                  % STARTCHAN and STOPCHAN
    fwrite(fileID, 0, 'uint32');                                            % SAMPLE = Duration of sampling    
    fwrite(fileID, 1, 'int32');                                             % NAMAL (Number of loops)    
    fwrite(fileID, antennaPort);                                            % Antenna number [0-255]

    switch SpecInfo.MetaData.TraceMode
        case 'SingleMeasurement'; traceID = 0;
        case 'Mean';              traceID = 1;
        case 'Peak';              traceID = 2;
        case 'Minimum';           traceID = 3;
    end
    fwrite(fileID, traceID);                                                % Processing (0: single measurement; 1: average; 2: peak; 3: minimum)

    switch SpecInfo.MetaData.LevelUnit                                      % Data Type (0: dBm; 1: dBµV/m)
        case 'dBm';    levelID = 0;
        case 'dBµV/m'; levelID = 1;
    end
    fwrite(fileID, levelID);
    
    OFFSET = ceil(max(SpecInfo.Data{2}(:,idx)));
    if OFFSET < -20
        OFFSET = -20;                                                       % Typical offset value
    end
    fwrite(fileID, OFFSET, 'int8');                                         % Offset
    
    fwrite(fileID, -1, 'int8');                                             % Global Error Code (GERROR)
    fwrite(fileID, -1, 'int8');                                             % Global Clipping Flags (GFLAGS)
    fwrite(fileID,  0, 'int8');                                             % Reserved for alignment
    
    fwrite(fileID, zeros(1, 2), 'uint16');                                  % NTUN and NAGC
    fwrite(fileID, NPAD);                                                   % NPAD (Number of bytes of padding)
    fwrite(fileID, NDATA, 'uint32');                                        % NDATA
    
    EncodedSpec = 2.*(SpecInfo.Data{2}(:,idx) - OFFSET) + 255;    
    fwrite(fileID, EncodedSpec, 'uint8');
    fwrite(fileID, zeros(1,NPAD));                                          % Padding
    
    Write_BlockTrailer(fileID, BytesBlock)    
end


%-------------------------------------------------------------------------%
function Write_DataType69(fileID, SpecInfo, antennaPort, idx)
    
    % Description
    Description = SpecInfo.RelatedFiles.Description{1};
    if mod(length(Description), 4)
        Description = [Description zeros(1,4-mod(length(Description), 4))];
    end
    
    % NPAD and NDATA
    NPAD  = 0;
    NDATA = SpecInfo.MetaData.DataPoints;
    
    BytesBlock = 64 + length(Description) + NDATA;
    if mod(BytesBlock, 4)
        NPAD = 4-mod(BytesBlock, 4);
        BytesBlock = BytesBlock + NPAD;
    end
    
    Write_BlockHeader(fileID, SpecInfo.RelatedFiles.ID(1), BytesBlock, 69);
    
    fwrite(fileID,   day(SpecInfo.Data{1}(idx)));                           % WALLDATE
    fwrite(fileID, month(SpecInfo.Data{1}(idx)));
    fwrite(fileID,  year(SpecInfo.Data{1}(idx))-2000);
    fwrite(fileID, 0);
    
    fwrite(fileID,   hour(SpecInfo.Data{1}(idx)));                          % WALLTIME
    fwrite(fileID, minute(SpecInfo.Data{1}(idx)));
    fwrite(fileID, second(SpecInfo.Data{1}(idx)));
    fwrite(fileID, 0);
    
    fwrite(fileID, zeros(1, 3), 'uint32');                                  % WALLNANO, Group ID and Dynamic ID
    
    fwrite(fileID, length(Description), 'uint32');
    fwrite(fileID, Description, 'char*1');
    
    F0 = SpecInfo.MetaData.FreqStart ./ 1e+6;                               % FreqStart in MHz
    IntegerPart = fix(F0);
    DecimalPart = round((F0 - IntegerPart).*1e+3);
    fwrite(fileID, IntegerPart, 'uint16');
    fwrite(fileID, DecimalPart, 'int32');
    
    F1 = SpecInfo.MetaData.FreqStop ./ 1e+6;                                % FreqStop in MHz
    IntegerPart = fix(F1);
    DecimalPart = round((F1 - IntegerPart).*1e+3);
    fwrite(fileID, IntegerPart, 'uint16');
    fwrite(fileID, DecimalPart, 'int32');
    
    if ~isempty(SpecInfo.MetaData.Resolution)                               % Resolution in Hz
        fwrite(fileID, SpecInfo.MetaData.Resolution, 'int32');
    else
        fwrite(fileID, -1, 'int32');
    end
    
    fwrite(fileID, zeros(1, 2), 'uint16');                                  % STARTCHAN and STOPCHAN
    fwrite(fileID, 2, 'int32');                                             % Operation type (2: Peak)
    fwrite(fileID, 1);                                                      % Operation count
    fwrite(fileID, antennaPort);                                            % Antenna number [0-255]
    
    switch SpecInfo.MetaData.LevelUnit                                      % Data Type (0: dBm; 1: dBµV/m)
        case 'dBm';    levelID = 0;
        case 'dBµV/m'; levelID = 1;
    end
    fwrite(fileID, levelID, 'uint16');
    
    fwrite(fileID, -1, 'int8');                                             % Global Error Code (GERROR)
    fwrite(fileID, -1, 'int8');                                             % Global Clipping Flags (GFLAGS)
    fwrite(fileID,  0, 'int8');                                             % Reserved for alignment
    
    fwrite(fileID, NPAD);                                                   % NPAD (Number of bytes of padding)
    fwrite(fileID, SpecInfo.MetaData.Threshold, 'int16');                   % Threshold
    fwrite(fileID, SpecInfo.RelatedFiles.RevisitTime(1), 'uint16');         % Integration time
    
    fwrite(fileID, NDATA, 'uint32');                                        % NDATA
    
    EncodedSpec = 2.*SpecInfo.Data{2}(:,idx);
    fwrite(fileID, EncodedSpec, 'uint8');
    fwrite(fileID, zeros(1,NPAD));                                          % Padding
    
    Write_BlockTrailer(fileID, BytesBlock)    
end