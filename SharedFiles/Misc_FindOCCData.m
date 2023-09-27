function idx = Misc_FindOCCData(Data)

    idx = [];
    for ii = 1:numel(Data)
        if ~isempty(Data(ii).reportOCC.Index)
            idx = [idx, Data(ii).reportOCC.Index];
        end
    end

end