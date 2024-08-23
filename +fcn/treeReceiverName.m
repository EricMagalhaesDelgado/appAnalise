function editedReceiverName = treeReceiverName(rawReceiverName, callingFcn)
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
            switch callingFcn
                case {'file_TreeBuilding', 'play_TreeBuilding'}
                    editedReceiverName = strjoin(IDN, ',');
                case 'class.Band.update'
                    editedReceiverName = strjoin(IDN(1:2), ' ');
            end

        else            
            switch callingFcn
                case {'file_TreeBuilding', 'play_TreeBuilding'}
                    editedReceiverName = rawReceiverName;
                case 'class.Band.update'
                    editedReceiverName = strjoin(IDN(1:2), ' ');
            end            
        end

    else
        editedReceiverName = rawReceiverName;
    end
end