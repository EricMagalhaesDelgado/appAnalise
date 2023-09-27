function Misc_ExceptionGlobalList(RootFolder)
    
    global ExceptionGlobalList
    
    ExceptionGlobalList = struct2table(jsondecode(fileread(fullfile(RootFolder, 'Settings', 'ExceptionGlobalList.json'))));
    ExceptionGlobalList.Frequency = single(ExceptionGlobalList.Frequency);
    
end