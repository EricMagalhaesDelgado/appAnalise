function [Rn, D, d1] = FresnelZone(txObj, rxObj, nPoints)

    arguments
        txObj   = struct('Latitude', -11, 'Longitude', -40, 'Frequency', 100e+6)
        rxObj   = struct('Latitude', -8,  'Longitude', -37)
        nPoints = 256
    end

    D  = deg2km(distance(txObj.Latitude, txObj.Longitude, rxObj.Latitude, rxObj.Longitude)) * 1000;
    d1 = linspace(0, D, nPoints)';
    d2 = D-d1;

    lambda = physconst('LightSpeed')/txObj.Frequency;
    Rn = sqrt(((d1.*d2)/D) * lambda);
end