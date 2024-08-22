function noiseValue = noiseEstimation(specData, noiseTrashSamples, noiseUsefulSamples, noiseOffset)
    DataPoints  = specData.MetaData.DataPoints;

    idx1        = max(1,                 ceil(noiseTrashSamples  * DataPoints));
    idx2        = min(DataPoints, idx1 + ceil(noiseUsefulSamples * DataPoints));
    
    sortedData  = sort(specData.Data{3}(:,2));
    sortedData  = sortedData(idx1:idx2);
    
    noiseValue = median(sortedData) + noiseOffset;
end