function CRFSBin(fileName, SpecInfo)

    % Escrita de arquivo no formato CRFS BIN (versão 5). O conteúdo do arquivo é 
    % extraído da variável "specData", sendo possível a geração dos tipos de 
    % dados 21 (Informações textuais), 40 (GPS), 67 (Espectro) e 69 (Ocupação).

    % Author.: Eric Magalhães Delgado
    % Date...: June 11, 2021
    % Version: 1.00

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
    clear global fileID
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
    fseek(fileID, 0, 'cof');                                    % Artifício que possibilita escrita após leitura.
    
    fwrite(fileID, CheckSumAdd, 'uint32');
    fwrite(fileID, 'UUUU',      'char*1');    
end


%-------------------------------------------------------------------------%
function Write_DataType21(fileID, SpecInfo)
    
    Hostname = SpecInfo.Node;
    Hostname = [Hostname zeros(1, 16-length(Hostname))];
    
    unitInfo = 'Stationary';
    if mod(length(unitInfo), 4)
        unitInfo = [unitInfo zeros(1, 4-mod(length(unitInfo), 4))];
    end
    unitInfoLength = length(unitInfo);
    
    method = SpecInfo.TaskName;
    if mod(length(method), 4)
        method = [method zeros(1, 4-mod(length(method), 4))];
    end    
    methodLength = length(method);
    
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
    
    fwrite(fileID,   day(SpecInfo.Data{1}(1)));                 % Wall Clock Date
    fwrite(fileID, month(SpecInfo.Data{1}(1)));
    fwrite(fileID,  year(SpecInfo.Data{1}(1))-2000);
    fwrite(fileID, 0);
    
    fwrite(fileID,   hour(SpecInfo.Data{1}(1)));                % Wall Clock Time
    fwrite(fileID, minute(SpecInfo.Data{1}(1)));
    fwrite(fileID, second(SpecInfo.Data{1}(1)));
    fwrite(fileID, 0);
        
    fwrite(fileID, 0, 'uint32');                                % Wall Clock Nanoseeconds
    
    fwrite(fileID,   day(SpecInfo.Data{1}(1)));                 % Wall Clock Date
    fwrite(fileID, month(SpecInfo.Data{1}(1)));
    fwrite(fileID,  year(SpecInfo.Data{1}(1))-2000);
    fwrite(fileID, 0);
    
    fwrite(fileID,   hour(SpecInfo.Data{1}(1)));                % Wall Clock Time
    fwrite(fileID, minute(SpecInfo.Data{1}(1)));
    fwrite(fileID, second(SpecInfo.Data{1}(1)));
    fwrite(fileID, 0);
        
    fwrite(fileID, SpecInfo.GPS.Status);                        % Positional fix and status of first GPS block
    fwrite(fileID, 0);                                          % Sattelites
    fwrite(fileID, 0, 'uint16');                                % Heading
    fwrite(fileID, SpecInfo.GPS.Latitude  .* 1e+6, 'int32');    % Latitude   (mean)
    fwrite(fileID, SpecInfo.GPS.Longitude .* 1e+6, 'int32');    % Longitude  (mean)
    fwrite(fileID, 0, 'uint32');                                % Speed
    fwrite(fileID, 0, 'uint32');                                % Altitude
        
    Write_BlockTrailer(fileID, 40)
end


%-------------------------------------------------------------------------%
function Write_DataType67(fileID, SpecInfo, antennaPort, ind)
    
    % Description
    Description = SpecInfo.Description;
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
    
    Write_BlockHeader(fileID, SpecInfo.ThreadID, BytesBlock, 67);
    
    fwrite(fileID,   day(SpecInfo.Data{1}(ind)));               % WALLDATE
    fwrite(fileID, month(SpecInfo.Data{1}(ind)));
    fwrite(fileID,  year(SpecInfo.Data{1}(ind))-2000);
    fwrite(fileID, 0);
    
    fwrite(fileID,   hour(SpecInfo.Data{1}(ind)));              % WALLTIME
    fwrite(fileID, minute(SpecInfo.Data{1}(ind)));
    fwrite(fileID, second(SpecInfo.Data{1}(ind)));
    fwrite(fileID, 0);
    fwrite(fileID, (second(SpecInfo.Data{1}(ind))-fix(second(SpecInfo.Data{1}(ind))))*1e+9, 'uint32');
    
    fwrite(fileID, zeros(1, 2), 'uint32');                      % Group ID and Dynamic ID
    
    fwrite(fileID, length(Description), 'uint32');
    fwrite(fileID, Description, 'char*1');
    
    F0 = SpecInfo.MetaData.FreqStart ./ 1e+6;                   % FreqStart in MHz
    IntegerPart = fix(F0);
    DecimalPart = round((F0 - IntegerPart).*1e+3);
    fwrite(fileID, IntegerPart, 'uint16');
    fwrite(fileID, DecimalPart, 'int32');
    
    F1 = SpecInfo.MetaData.FreqStop ./ 1e+6;                    % FreqStop in MHz
    IntegerPart = fix(F1);
    DecimalPart = round((F1 - IntegerPart).*1e+3);
    fwrite(fileID, IntegerPart, 'uint16');
    fwrite(fileID, DecimalPart, 'int32');
    
    if ~isempty(SpecInfo.MetaData.Resolution)                   % Resolution in Hz
        fwrite(fileID, SpecInfo.MetaData.Resolution, 'int32');
    else
        fwrite(fileID, -1, 'int32');
    end
    
    fwrite(fileID, zeros(1, 2), 'uint16');                      % STARTCHAN and STOPCHAN
    
    if ~isempty(SpecInfo.MetaData.SampleTime)                   % SAMPLE = Duration of sampling
        fwrite(fileID, SpecInfo.MetaData.SampleTime*1e+6, 'uint32');
    else
        fwrite(fileID, 0, 'uint32');
    end
    
    fwrite(fileID, 1, 'int32');                                 % NAMAL (Number of loops)
    
    fwrite(fileID, antennaPort);                                % Antenna number [0-255]
    fwrite(fileID, SpecInfo.MetaData.TraceMode);                % Processing (0: single measurement; 1: average; 2: peak; 3: minimum)
    
    if ismember(SpecInfo.MetaData.LevelUnit, [1,2])
        fwrite(fileID, 0);                                      % Data Type (0: dBm; 1: dBµV/m)
    elseif SpecInfo.MetaData.LevelUnit == 3
        fwrite(fileID, 1);
    end
    
    OFFSET = ceil(max(SpecInfo.Data{2}(:,ind)));
    if OFFSET < -20
        OFFSET = -20;                                           % Typical offset value
    end
    fwrite(fileID, OFFSET, 'int8');                             % Offset
    
    fwrite(fileID, -1, 'int8');                                 % Global Error Code (GERROR)
    fwrite(fileID, -1, 'int8');                                 % Global Clipping Flags (GFLAGS)
    fwrite(fileID,  0, 'int8');                                 % Reserved for alignment
    
    fwrite(fileID, zeros(1, 2), 'uint16');                      % NTUN and NAGC
    fwrite(fileID, NPAD);                                       % NPAD (Number of bytes of padding)
    fwrite(fileID, NDATA, 'uint32');                            % NDATA
    
    EncodedSpec = 2.*(SpecInfo.Data{2}(:,ind) - OFFSET) + 255;
    if SpecInfo.MetaData.LevelUnit == 2
        EncodedSpec = EncodedSpec - 107;                        % dBµV-dBm convertion factor (50Ω)
    end
    
    fwrite(fileID, EncodedSpec, 'uint8');
    fwrite(fileID, zeros(1,NPAD));                              % Padding
    
    Write_BlockTrailer(fileID, BytesBlock)    
end


%-------------------------------------------------------------------------%
function Write_DataType69(fileID, SpecInfo, antennaPort, ind)
    
    % Description
    Description = SpecInfo.Description;
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
    
    Write_BlockHeader(fileID, SpecInfo.ThreadID, BytesBlock, 69);
    
    fwrite(fileID,   day(SpecInfo.Data{1}(ind)));               % WALLDATE
    fwrite(fileID, month(SpecInfo.Data{1}(ind)));
    fwrite(fileID,  year(SpecInfo.Data{1}(ind))-2000);
    fwrite(fileID, 0);
    
    fwrite(fileID,   hour(SpecInfo.Data{1}(ind)));              % WALLTIME
    fwrite(fileID, minute(SpecInfo.Data{1}(ind)));
    fwrite(fileID, second(SpecInfo.Data{1}(ind)));
    fwrite(fileID, 0);
    
    fwrite(fileID, zeros(1, 3), 'uint32');                      % WALLNANO, Group ID and Dynamic ID
    
    fwrite(fileID, length(Description), 'uint32');
    fwrite(fileID, Description, 'char*1');
    
    F0 = SpecInfo.MetaData.FreqStart ./ 1e+6;                   % FreqStart in MHz
    IntegerPart = fix(F0);
    DecimalPart = round((F0 - IntegerPart).*1e+3);
    fwrite(fileID, IntegerPart, 'uint16');
    fwrite(fileID, DecimalPart, 'int32');
    
    F1 = SpecInfo.MetaData.FreqStop ./ 1e+6;                    % FreqStop in MHz
    IntegerPart = fix(F1);
    DecimalPart = round((F1 - IntegerPart).*1e+3);
    fwrite(fileID, IntegerPart, 'uint16');
    fwrite(fileID, DecimalPart, 'int32');
    
    if ~isempty(SpecInfo.MetaData.Resolution)                   % Resolution in Hz
        fwrite(fileID, SpecInfo.MetaData.Resolution, 'int32');
    else
        fwrite(fileID, -1, 'int32');
    end
    
    fwrite(fileID, zeros(1, 2), 'uint16');                      % STARTCHAN and STOPCHAN
    fwrite(fileID, 2, 'int32');                                 % Operation type (2: Peak)
    fwrite(fileID, 1);                                          % Operation count
    fwrite(fileID, antennaPort);                                % Antenna number [0-255]
    
    if ismember(SpecInfo.MetaData.LevelUnit, [1,2])
        fwrite(fileID, 0, 'uint16');                            % Data Type (0: dBm; 1: dBµV/m)
    elseif SpecInfo.MetaData.LevelUnit == 3
        fwrite(fileID, 1);
    end
    
    fwrite(fileID, -1, 'int8');                                 % Global Error Code (GERROR)
    fwrite(fileID, -1, 'int8');                                 % Global Clipping Flags (GFLAGS)
    fwrite(fileID,  0, 'int8');                                 % Reserved for alignment
    
    fwrite(fileID, NPAD);                                       % NPAD (Number of bytes of padding)
    fwrite(fileID, SpecInfo.MetaData.Threshold, 'int16');       % Threshold
    fwrite(fileID, SpecInfo.MetaData.SampleTime, 'uint16');     % Integration time    
    
    fwrite(fileID, NDATA, 'uint32');                            % NDATA
    
    EncodedSpec = 2.*SpecInfo.Data{2}(:,ind);
    fwrite(fileID, EncodedSpec, 'uint8');
    fwrite(fileID, zeros(1,NPAD));                              % Padding
    
    Write_BlockTrailer(fileID, BytesBlock)    
end