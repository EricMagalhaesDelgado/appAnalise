function wxPk = findpeaks(Yin, varargin)
%FINDPEAKS Find local peaks in data

% Copyright 2007-2022 The MathWorks, Inc.
% Edited by Eric Magalhães Delgado (Aug-11 2023)

narginchk(1,22);
isInMATLAB = coder.target('MATLAB');

% extract the parameters from the input argument list
[y, ~, x, ~, minH, minP, minW, maxW, ~, minT, ~, ~, ~, refW] = parse_inputs(isInMATLAB, Yin, varargin{:});

% find indices of all finite and infinite peaks and the inflection points
[iFinite, iInfinite, iInflect] = getAllPeaks(y);

% keep only the indices of finite peaks that meet the required
% minimum height and threshold
iPk = removePeaksBelowMinPeakHeight(y,iFinite,minH,refW);
iPk = removePeaksBelowThreshold(y,iPk,minT);

% obtain the indices of each peak (iPk), the prominence base (bPk), and
% the x- and y- coordinates of the peak base (bxPk, byPk) and the width
% (wxPk)
[~, ~, ~, ~, wxPk] = signal.internal.findpeaks.findExtents(y, x, iPk, iFinite, iInfinite, iInflect, minP, minW, maxW, refW);


%--------------------------------------------------------------------------
function [y,yIsRow,x,xIsRow,Ph,Pp,Wmin,Wmax,Pd,Th,NpOut,Str,Ann,Ref] = parse_inputs(isInMATLAB,Yin,varargin)

% Validate input signal
validateattributes(Yin,{'double','single'},{'nonempty','real','vector'},...
    'findpeaks','Y');
y = Yin(:);
M = length(y);

if isInMATLAB
    if M < 3
        error(message('signal:findpeaks:emptyDataSet'));
    end
    yIsRow = isrow(Yin);
else
    coder.internal.assert(M >= 3,'signal:findpeaks:emptyDataSet');
    % To return row vectors we require Yin to be a row vector *type*, i.e.
    % length(size(y)) == 2, size(y,1) is constant 1, and size(y,2) ==
    % length(y). Otherwise, the output allocation might be O(n^2) instead
    % of O(n).
    yIsRow = coder.internal.isConst(isrow(Yin)) && isrow(Yin);
end

% indicate if the user specified an Fs or X
hasX = ~isempty(varargin) && (isnumeric(varargin{1}) || ...
  isInMATLAB && isdatetime(varargin{1}) && length(varargin{1})>1);

if hasX
  startArg = 2;
  if isInMATLAB
      FsSupplied = isscalar(varargin{1});
  else
      FsSupplied = coder.internal.isConst(isscalar(varargin{1})) && isscalar(varargin{1});
  end
  if FsSupplied
    % Fs
    Fs1 = varargin{1};
    validateattributes(Fs1,{'numeric'},{'real','finite','positive'},'findpeaks','Fs');
    Fs = double(Fs1(1));
    x = (0:M-1).'/Fs;
    xIsRow = yIsRow;
  else
    % X
    Xin1 = varargin{1};
    
    if isnumeric(Xin1)
      validateattributes(Xin1,{'numeric'},{'real','finite','vector','increasing'},'findpeaks','X');
      Xin = double(Xin1);
    else % isdatetime(Xin)
      validateattributes(seconds(Xin1-Xin1(1)),{'double'},{'real','finite','vector','increasing'},'findpeaks','X');
      Xin = Xin1;
    end
    
    if isInMATLAB
        if length(Xin) ~= M
            throwAsCaller(MException(message('signal:findpeaks:mismatchYX')));
        end
        xIsRow = isrow(Xin);
    else
        coder.internal.assert(length(Xin) == M, ...
            'signal:findpeaks:mismatchYX');
        xIsRow = coder.internal.isConst(isrow(Xin)) && isrow(Xin);
    end
    x = Xin(:);
  end
else
  startArg = 1;
  % unspecified, use index vector
  x = (1:M).';
  xIsRow = yIsRow;
end

%#function dspopts.findpeaks
if isInMATLAB
    p = signal.internal.findpeaks.getParser();
    parse(p,varargin{startArg:end});
    Ph = p.Results.MinPeakHeight;
    Pp = p.Results.MinPeakProminence;
    Wmin = p.Results.MinPeakWidth;
    Wmax = p.Results.MaxPeakWidth;
    Pd = p.Results.MinPeakDistance;
    Th = p.Results.Threshold;
    Np = p.Results.NPeaks;
    Str = p.Results.SortStr;
    Ann = p.Results.Annotate;
    Ref = p.Results.WidthReference;
else
    defaultMinPeakHeight = -inf;
    defaultMinPeakProminence = 0;
    defaultMinPeakWidth = 0;
    defaultMaxPeakWidth = Inf;
    defaultMinPeakDistance = 0;
    defaultThreshold = 0;
    defaultNPeaks = [];
    defaultSortStr = 'none';
    defaultAnnotate = 'peaks';
    defaultWidthReference = 'halfprom';

    parms = struct('MinPeakHeight',uint32(0), ...
                'MinPeakProminence',uint32(0), ...
                'MinPeakWidth',uint32(0), ...
                'MaxPeakWidth',uint32(0), ...
                'MinPeakDistance',uint32(0), ...
                'Threshold',uint32(0), ...
                'NPeaks',uint32(0), ...
                'SortStr',uint32(0), ...
                'Annotate',uint32(0), ...
                'WidthReference',uint32(0));
    pstruct = eml_parse_parameter_inputs(parms,[],varargin{startArg:end});
    Ph = eml_get_parameter_value(pstruct.MinPeakHeight,defaultMinPeakHeight,varargin{startArg:end});
    Pp = eml_get_parameter_value(pstruct.MinPeakProminence,defaultMinPeakProminence,varargin{startArg:end});
    Wmin = eml_get_parameter_value(pstruct.MinPeakWidth,defaultMinPeakWidth,varargin{startArg:end});
    Wmax = eml_get_parameter_value(pstruct.MaxPeakWidth,defaultMaxPeakWidth,varargin{startArg:end});
    Pd = eml_get_parameter_value(pstruct.MinPeakDistance,defaultMinPeakDistance,varargin{startArg:end});
    Th = eml_get_parameter_value(pstruct.Threshold,defaultThreshold,varargin{startArg:end});
    Np = eml_get_parameter_value(pstruct.NPeaks,defaultNPeaks,varargin{startArg:end});
    Str = eml_get_parameter_value(pstruct.SortStr,defaultSortStr,varargin{startArg:end});
    Ann = eml_get_parameter_value(pstruct.Annotate,defaultAnnotate,varargin{startArg:end});
    Ref = eml_get_parameter_value(pstruct.WidthReference,defaultWidthReference,varargin{startArg:end});
end

% limit the number of peaks to the number of input samples
if isempty(Np)
    NpOut = M;
else
    NpOut = Np;
end

% ignore peaks below zero when using halfheight width reference
if strcmp(Ref,'halfheight')
  Ph = max(Ph,0);
end

validateattributes(Ph,{'numeric'},{'real','scalar','nonempty'},'findpeaks','MinPeakHeight');
if isnumeric(x)
  validateattributes(Pd,{'numeric'},{'real','scalar','nonempty','nonnegative','<',x(M)-x(1)},'findpeaks','MinPeakDistance');
else
  if isInMATLAB && isduration(Pd)
    validateattributes(seconds(Pd),{'numeric'},{'real','scalar','nonempty','nonnegative'},'findpeaks','MinPeakDistance');
  else 
    validateattributes(Pd,{'numeric'},{'real','scalar','nonempty','nonnegative'},'findpeaks','MinPeakDistance');
  end    
end
validateattributes(Pp,{'numeric'},{'real','scalar','nonempty','nonnegative'},'findpeaks','MinPeakProminence');
if isInMATLAB && isduration(Wmin)
  validateattributes(seconds(Wmin),{'numeric'},{'real','scalar','finite','nonempty','nonnegative'},'findpeaks','MinPeakWidth');
else
  validateattributes(Wmin,{'numeric'},{'real','scalar','finite','nonempty','nonnegative'},'findpeaks','MinPeakWidth');
end
if isInMATLAB && isduration(Wmax)
  validateattributes(seconds(Wmax),{'numeric'},{'real','scalar','nonnan','nonempty','nonnegative'},'findpeaks','MaxPeakWidth');
else
  validateattributes(Wmax,{'numeric'},{'real','scalar','nonnan','nonempty','nonnegative'},'findpeaks','MaxPeakWidth');
end
if isInMATLAB && isduration(Pd)
  validateattributes(seconds(Pd),{'numeric'},{'real','scalar','nonempty','nonnegative'},'findpeaks','MinPeakDistance');
else
  validateattributes(Pd,{'numeric'},{'real','scalar','nonempty','nonnegative'},'findpeaks','MinPeakDistance');
end  
validateattributes(Th,{'numeric'},{'real','scalar','nonempty','nonnegative'},'findpeaks','Threshold');
validateattributes(NpOut,{'numeric'},{'real','scalar','nonempty','integer','positive'},'findpeaks','NPeaks');
Str = validatestring(Str,{'ascend','none','descend'},'findpeaks','SortStr');
Ann = validatestring(Ann,{'peaks','extents'},'findpeaks','SortStr');
Ref = validatestring(Ref,{'halfprom','halfheight'},'findpeaks','WidthReference');

%--------------------------------------------------------------------------
function [iPk,iInf,iInflect] = getAllPeaks(y)
% fetch indices all infinite peaks
iInf = find(isinf(y) & y>0);

% temporarily remove all +Inf values
yTemp = y;
yTemp(iInf) = NaN;

% determine the peaks and inflection points of the signal
[iPk,iInflect] = findLocalMaxima(yTemp);


%--------------------------------------------------------------------------
function [iPk, iInflect] = findLocalMaxima(yTemp)
% bookend Y by NaN and make index vector
yTemp = [NaN; yTemp; NaN];
iTemp = (1:length(yTemp)).';

% keep only the first of any adjacent pairs of equal values (including NaN).
yFinite = ~isnan(yTemp);
iNeq = [1; 1 + find((yTemp(1:end-1) ~= yTemp(2:end)) & ...
                    (yFinite(1:end-1) | yFinite(2:end)))];
iTemp = iTemp(iNeq);

% take the sign of the first sample derivative
s = sign(diff(yTemp(iTemp)));

% find local maxima
iMax = 1 + find(diff(s)<0);

% find all transitions from rising to falling or to NaN
iAny = 1 + find(s(1:end-1)~=s(2:end));

% index into the original index vector without the NaN bookend.
iInflect = iTemp(iAny)-1;
iPk = iTemp(iMax)-1;


%--------------------------------------------------------------------------
function [iPk,iInf,iInflect] = getAllPeaksCodegen(y)
% One-pass code generation version of getAllPeaks
coder.varsize('iPk');
coder.varsize('iInf');
coder.varsize('iInflect');
% Define constants.
ZERO = coder.internal.indexInt(0);
ONE = coder.internal.indexInt(1);
DECREASING = 'd';
INCREASING = 'i';
NEITHER = 'n';
NonFiniteSupport = eml_option('NonFinitesSupport');
% Allocate output arrays.
iPk = coder.nullcopy(zeros(size(y),'like',ONE));
iInf = coder.nullcopy(zeros(size(y),'like',ONE));
iInflect = coder.nullcopy(zeros(size(y),'like',ONE));
ny = coder.internal.indexInt(length(y));
% Counter variables to store the number of elements in each array that are
% in use.
nPk = ZERO;
nInf = ZERO;
nInflect = ZERO;
% Initial direction.
dir = NEITHER;
if NonFiniteSupport || ny == 0
    % This is the typical start. With kfirst = 0 and ykfirst = +Inf, the
    % first value is an artificial +Inf. Unless the signal begins with
    % +Infs and/or NaNs, we'll pick up the first non-NaN, non-Inf value in
    % the first iteration, replace ykfirst with it, and proceed from there.
    kfirst = ZERO; % index of first element of a series of equal values
    ykfirst = coder.internal.inf('like',y); % first element of a series of equal values
    isinfykfirst = true;
else
    % With no non-finite support, we know the first element of the signal
    % is finite, so we can start with it.
    kfirst = ONE; % index of first element of a series of equal values
    ykfirst = y(1); % first element of a series of equal values
    isinfykfirst = false;
end
for k = kfirst + 1:ny
    yk = y(k);
    if isnan(yk)
        % yk is NaN. Convert it to +Inf.
        yk = coder.internal.inf('like',yk);
        isinfyk = true;
    elseif isinf(yk) && yk > 0
        % yk is +Inf. Record its position in the iInf array.
        isinfyk = true;
        nInf = nInf + 1;
        iInf(nInf) = k;
    else
        isinfyk = false;
    end
    if yk ~= ykfirst
        previousdir = dir;
        if NonFiniteSupport && (isinfyk || isinfykfirst)
            dir = NEITHER;
            % kfirst == 0 implies that ykfirst was just the artificial
            % starting value. We don't want to add the artificial value to
            % the array of inflection points, so we only append if kfirst
            % is at least 1.
            if kfirst >= 1
                nInflect = nInflect + 1;
                iInflect(nInflect) = kfirst;
            end
        elseif yk < ykfirst
            dir = DECREASING;
            if dir ~= previousdir
                % Previously the direction was not decreasing and now it
                % is. At least record an inflection point.                
                nInflect = nInflect + 1;
                iInflect(nInflect) = kfirst;
                if previousdir == INCREASING
                    % Since the direction was previously increasing and now
                    % is decreasing, y(kfirst) is a peak.
                    nPk = nPk + 1;
                    iPk(nPk) = kfirst;
                end
            end
        else % if yk > ykfirst
            dir = INCREASING;
            if dir ~= previousdir
                % Direction was previously not increasing. Record the
                % inflection point y(kfirst).
                nInflect = nInflect + 1;
                iInflect(nInflect) = kfirst;
            end
        end
        % yk becomes the new ykfirst.
        ykfirst = yk;
        kfirst = k;
        isinfykfirst = isinfyk;
    end
end
% Add last point as inflection point if it is finite and not already there.
if ny > 0 && ~isinfykfirst && (nInflect == 0 || iInflect(nInflect) < ny)
    nInflect = nInflect + 1;
    iInflect(nInflect) = ny;
end
% Shorten the variable-size arrays down to the number of elements in use.
iPk = iPk(1:nPk,1);
iInf = iInf(1:nInf,1);
iInflect = iInflect(1:nInflect,1);

%--------------------------------------------------------------------------
function iPk = removePeaksBelowMinPeakHeight(Y,iPk,Ph,widthRef)
if ~isempty(iPk) 
  iPk = iPk(Y(iPk) > Ph);
  if isempty(iPk) && ~strcmp(widthRef,'halfheight')
    warning(message('signal:findpeaks:largeMinPeakHeight', 'MinPeakHeight', 'MinPeakHeight'));
  end
end
    
%--------------------------------------------------------------------------
function iPk = removePeaksBelowThreshold(Y,iPk,Th)
base = max(Y(iPk-1),Y(iPk+1));
iPk = iPk(Y(iPk)-base >= Th);

%--------------------------------------------------------------------------
function iPk = removeSmallPeaks(y,iFinite,minH,thresh)
% Combination of removePeaksBelowMinPeakHeight and
% removePeaksBelowThreshold for code generation
iPk = coder.nullcopy(iFinite);
nPk = coder.internal.indexInt(0);
n = coder.internal.indexInt(length(iFinite));
for k = 1:n
    j = iFinite(k);
    pk = y(j);
    if pk > minH
        base = max(y(j - 1),y(j + 1));
        if pk - base >= thresh
            nPk = nPk + 1;
            iPk(nPk) = j;
        end
    end
end
iPk = iPk(1:nPk,1);

%--------------------------------------------------------------------------
function [iPkOut,bPk,bxPk,byPk,wxPk] = combinePeaks(iPk,iInf)
iPkOut = union(iPk,iInf);
bPk = zeros(0,1);
bxPk = zeros(0,2);
byPk = zeros(0,2);
wxPk = zeros(0,2);

%--------------------------------------------------------------------------
function idx = findPeaksSeparatedByMoreThanMinPeakDistance(y,x,iPk,Pd,sortDir)
% Start with the larger peaks to make sure we don't accidentally keep a
% small peak and remove a large peak in its neighborhood. 

if isempty(iPk) || Pd==0
  IONE = ones('like',getIZERO);
  idx = orderPeaks(y,iPk,(IONE:length(iPk)).',sortDir);
  return
end

% copy peak values and locations to a temporary place
pks = y(iPk);
locs_temp = x(iPk);

% Order peaks from large to small
if coder.target('MATLAB')
    [~, sortIdx] = sort(pks,'d');
else

    ZERO = coder.internal.indexInt(0);
    sortIdx = coder.nullcopy(zeros(numel(pks), 1, 'like', ZERO));
    sortIdx = coder.internal.mergesort(sortIdx,pks,'d', ...
        ZERO,coder.internal.indexInt(numel(pks)));
end

locs_temp = locs_temp(sortIdx);

idelete = zeros(size(locs_temp), 'logical');

for i = 1:length(idelete)
  if ~idelete(i)
    % If the peak is not in the neighborhood of a larger peak, find
    % secondary peaks to eliminate.

    if coder.target('MATLAB')
        idelete = idelete | (locs_temp>=locs_temp(i)-Pd)&(locs_temp<=locs_temp(i)+Pd);
    else
		% explicit loop for better memory profile
        for jj = length(idelete):-1:1
            idelete(jj) = idelete(jj) | (locs_temp(jj)>=locs_temp(i)-Pd)&(locs_temp(jj)<=locs_temp(i)+Pd);
        end
    end

    idelete(i) = 0; % Keep current peak
  end
end

% report back indices in consecutive order
idx = sortIdx(~idelete);

if isempty(idx)
    return
end

% re-order and bound the number of peaks based upon the index vector and
% sortDir.

if strcmp(sortDir,'none')
    if coder.target('MATLAB')
        idx = sort(idx);
    else
        idx = coder.internal.introsort(idx,coder.internal.indexInt(1), ...
            coder.internal.indexInt(length(idx)));
    end
elseif sortDir(1) == 'a'
    idx = flipud(idx);
end

%--------------------------------------------------------------------------
function idx = orderPeaks(Y,iPk,idx,Str)

if isempty(idx) || strcmp(Str,'none')
  return
end

if coder.target('MATLAB')
  [~,s]  = sort(Y(iPk(idx)),Str);
else
  ZERO = coder.internal.indexInt(0);
  s = zeros(numel(idx), 1, 'like', ZERO);  
  s = coder.internal.mergesort(s, Y(iPk(idx)), Str(1), ...
      ZERO,coder.internal.indexInt(numel(idx)));
end
idx = idx(s);


%--------------------------------------------------------------------------
function idx = keepAtMostNpPeaks(idx,Np)

if length(idx)>Np
  idx = idx(1:Np);
end


%--------------------------------------------------------------------------
function [YpkOut,XpkOut] = assignOutputs(y,x,iPk,yIsRow,xIsRow)
coder.internal.prefer_const(yIsRow,xIsRow);

% fetch the coordinates of the peak
Ypk = y(iPk);
Xpk = x(iPk);

% preserve orientation of Y
if yIsRow
  YpkOut = Ypk.';
else
  YpkOut = Ypk;
end

% preserve orientation of X
if xIsRow
  XpkOut = Xpk.';
else
  XpkOut = Xpk;
end

%--------------------------------------------------------------------------
function [YpkOut,XpkOut,WpkOut,PpkOut] = assignFullOutputs(y,x,iPk,wxPk,bPk,yIsRow,xIsRow,idx,maxN)
coder.internal.prefer_const(yIsRow,xIsRow);

% fetch the coordinates of the peak
Ypk = y(iPk);
Xpk = x(iPk);

% compute the width and prominence

Wpk = diff(wxPk(idx(1:maxN),:),1,2);

Ppk = Ypk - bPk(idx(1:maxN));

% preserve orientation of Y (and P)
if yIsRow
  YpkOut = Ypk.';
  PpkOut = Ppk.';
else
  YpkOut = Ypk;
  PpkOut = Ppk;  
end

% preserve orientation of X (and W)
if xIsRow
  XpkOut = Xpk.';
  WpkOut = Wpk.';
else
  XpkOut = Xpk;
  WpkOut = Wpk;  
end

%--------------------------------------------------------------------------
function y = getIZERO
% Return zero of the indexing type: double 0 in MATLAB,
% coder.internal.indexInt(0) for code generation targets.
if coder.target('MATLAB')
    y = 0;
else
    y = coder.internal.indexInt(0);
end

% [EOF]
