function editedReceiverName = treeReceiverName(rawReceiverName)

    IDN = strsplit(rawReceiverName, ',');
    if numel(IDN) == 4
        keys   = ["keysight technologies", ...
                  "rohde&schwarz",         ...
                  "tektronix"];
        values = ["Keysight",              ...
                  "Rohde&Schwarz",         ...
                  "Tektronix"];
        
        d = dictionary(keys, values);
        
        if isKey(d, lower(IDN{1}))
            IDN{1} = char(d(lower(IDN{1})));
            editedReceiverName = strjoin(IDN, ',');
        else
            editedReceiverName = rawReceiverName;
        end

    else
        editedReceiverName = rawReceiverName;
    end
end