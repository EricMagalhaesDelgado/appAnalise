function Misc_FindPeaksDefaultValues(RootFolder)
    
    global peaksReference
    
    peaksReference = jsondecode(fileread(fullfile(RootFolder, 'Settings', 'FindPeaksDefaultValues.json')));
    
end