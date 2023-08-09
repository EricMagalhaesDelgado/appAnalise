function kFactor = Misc_kFactorRead(RootFolder, AntennaName)
%% MISC_KFACTORREAD Leitura do arquivo.
msg = fileread(fullfile(RootFolder, 'Settings', 'kFactor.cfg'));
ind = strfind(msg, sprintf('## %s ##', AntennaName));
msg = msg(ind(1):ind(2));
kFactor.Name = extractBetween(msg, '## ', ' ##');
cellArray = strsplit(msg, '\n');
cellArray([1,2,end]) = [];
for ii = 1:numel(cellArray)
    rowValues = strsplit(cellArray{ii}, '\t');
    
    kFactor.Data(ii,1:2) = [str2double(rowValues{1}), str2double(rowValues{2})];
end