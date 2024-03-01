classdef MetaDataList

    properties
        %-----------------------------------------------------------------%
        DataType         = []                                               % Valor numérico: RFlookBin (1-2), CRFSBin (4, 7-8, 60-65 e 67-69), Argus (167-168), CellPlan (1000) e SM1809 (1809)
        FreqStart        = []                                               % Valor numérico (em Hertz)
        FreqStop         = []                                               % Valor numérico (em Hertz)
        LevelUnit        = []                                               % dBm | dBµV | dBµV/m
        DataPoints       = []
        Resolution       = -1                                               % Valor numérico (em Hertz) ou -1 (caso não registrado em arquivo)
        VBW              = -1
        Threshold        = -1
        TraceMode        = ''                                               % "ClearWrite" | "Average" | "MaxHold" | "MinHold" | "OCC" | "SingleMeasurement" | "Mean" | "Peak" | "Minimum"
        TraceIntegration = -1                                               % Aplicável apenas p/ "Average", "MaxHold" ou "MinHold"
        Detector         = ''                                               % "Sample" | "Average/RMS" | "Positive Peak" | "Negative Peak"
        Antenna          = []
        Others           = ''                                               % JSON
    end
end