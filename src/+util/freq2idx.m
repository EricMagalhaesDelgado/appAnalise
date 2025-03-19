function varargout = freq2idx(requestedOutput, varargin)
    % FrequencyInHertz = aCoef * FrequencyInHertzIndex + bCoef;
    % FreqStart        = aCoef * 1                     + bCoef;
    % FreqStop         = aCoef * DataPoints            + bCoef

    arguments
        requestedOutput char {mustBeMember(requestedOutput, {'Coefficients', 'FrequencyInHertzIndex', 'FrequencyInHertz'})}
    end

    arguments (Repeating)
        varargin
    end

    switch requestedOutput
        case 'Coefficients'
            specData   = varargin{1};
            idxThread  = varargin{2};

            DataPoints = specData(idxThread).MetaData.DataPoints;
            FreqStart  = specData(idxThread).MetaData.FreqStart;
            FreqStop   = specData(idxThread).MetaData.FreqStop;

            aCoef      = (FreqStop-FreqStart)/(DataPoints-1);
            bCoef      = FreqStart-aCoef;

            varargout  = {aCoef, bCoef};
        
        otherwise
            aCoef      = varargin{1};
            bCoef      = varargin{2};

            switch requestedOutput
                case 'FrequencyInHertzIndex'
                    FrequencyInHertz      = varargin{3};
                    FrequencyInHertzIndex = round((FrequencyInHertz - bCoef) ./ aCoef);

                    varargout = {FrequencyInHertzIndex};

                case 'FrequencyInHertz'
                    FrequencyInHertzIndex = varargin{3};
                    FrequencyInHertz      = (aCoef .* FrequencyInHertzIndex + bCoef);

                    varargout = {FrequencyInHertz};
            end
    end
end