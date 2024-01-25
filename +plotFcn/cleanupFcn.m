function cleanupFcn(hROI)
    try
        listenersList = struct(hROI).AutoListeners__;
        cellfun(@(x) delete(x), listenersList)
    catch
    end
end