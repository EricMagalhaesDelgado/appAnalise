function [wxPk, Ppk] = findpeaks(Yin, varargin)
%FINDPEAKS Find local peaks in data

% Copyright 2007-2022 The MathWorks, Inc.
% Edited by Eric Magalhães Delgado (Aug-24 2023)

narginchk(1,22);

% extract the parameters from the input argument list
[y, ~, x, ~, minH, minP, minW, maxW, minD, minT, maxN, sortDir, ~, refW] = parse_inputs(Yin, varargin{:});

% find indices of all finite and infinite peaks and the inflection points
[iFinite, iInfinite, iInflect] = getAllPeaks(y);

% keep only the indices of finite peaks that meet the required
% minimum height and threshold
iPk = removePeaksBelowMinPeakHeight(y,iFinite,minH,refW);
iPk = removePeaksBelowThreshold(y,iPk,minT);

% obtain the indices of each peak (iPk), the prominence base (bPk), and
% the x- and y- coordinates of the peak base (bxPk, byPk) and the width
% (wxPk)
[iPk, bPk, ~, ~, wxPk] = signal.internal.findpeaks.findExtents(y, x, iPk, iFinite, iInfinite, iInflect, minP, minW, maxW, refW);

% find the indices of the largest peaks within the specified distance
idx = findPeaksSeparatedByMoreThanMinPeakDistance(y,x,iPk,minD,sortDir);

iPk  = iPk(idx);
bPk  = bPk(idx);
wxPk = wxPk(idx,:);

% use the index vector to fetch the correct peaks.
if numel(idx) > maxN
    iPk  = iPk(1:maxN);
    bPk  = bPk(1:maxN);
    wxPk = wxPk(1:maxN,:);
end

Ppk = y(iPk) - bPk;


%--------------------------------------------------------------------------
function [y,yIsRow,x,xIsRow,Ph,Pp,Wmin,Wmax,Pd,Th,NpOut,Str,Ann,Ref] = parse_inputs(Yin,varargin)

% Validate input signal
validateattributes(Yin,{'double','single'},{'nonempty','real','vector'},...
    'findpeaks','Y');
y = Yin(:);
M = length(y);

if M < 3
    error(message('signal:findpeaks:emptyDataSet'));
end
yIsRow = isrow(Yin);

% indicate if the user specified an Fs or X
hasX = ~isempty(varargin) && (isnumeric(varargin{1}) || isdatetime(varargin{1}) && length(varargin{1})>1);

if hasX
  startArg = 2;
  FsSupplied = isscalar(varargin{1});
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
    
    if length(Xin) ~= M
        throwAsCaller(MException(message('signal:findpeaks:mismatchYX')));
    end
    xIsRow = isrow(Xin);
    x = Xin(:);
  end
else
  startArg = 1;
  % unspecified, use index vector
  x = (1:M).';
  xIsRow = yIsRow;
end

%#function dspopts.findpeaks
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
  if isduration(Pd)
    validateattributes(seconds(Pd),{'numeric'},{'real','scalar','nonempty','nonnegative'},'findpeaks','MinPeakDistance');
  else 
    validateattributes(Pd,{'numeric'},{'real','scalar','nonempty','nonnegative'},'findpeaks','MinPeakDistance');
  end    
end
validateattributes(Pp,{'numeric'},{'real','scalar','nonempty','nonnegative'},'findpeaks','MinPeakProminence');
if isduration(Wmin)
  validateattributes(seconds(Wmin),{'numeric'},{'real','scalar','finite','nonempty','nonnegative'},'findpeaks','MinPeakWidth');
else
  validateattributes(Wmin,{'numeric'},{'real','scalar','finite','nonempty','nonnegative'},'findpeaks','MinPeakWidth');
end
if isduration(Wmax)
  validateattributes(seconds(Wmax),{'numeric'},{'real','scalar','nonnan','nonempty','nonnegative'},'findpeaks','MaxPeakWidth');
else
  validateattributes(Wmax,{'numeric'},{'real','scalar','nonnan','nonempty','nonnegative'},'findpeaks','MaxPeakWidth');
end
if isduration(Pd)
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
[~, sortIdx] = sort(pks,'d');

locs_temp = locs_temp(sortIdx);

idelete = zeros(size(locs_temp), 'logical');

for i = 1:length(idelete)
  if ~idelete(i)
    % If the peak is not in the neighborhood of a larger peak, find
    % secondary peaks to eliminate.

    idelete = idelete | (locs_temp>=locs_temp(i)-Pd)&(locs_temp<=locs_temp(i)+Pd);
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
    idx = sort(idx);
elseif sortDir(1) == 'a'
    idx = flipud(idx);
end


%--------------------------------------------------------------------------
function idx = orderPeaks(Y,iPk,idx,Str)

if isempty(idx) || strcmp(Str,'none')
  return
end

[~,s]  = sort(Y(iPk(idx)),Str);
idx = idx(s);


%--------------------------------------------------------------------------
function y = getIZERO
% Return zero of the indexing type: double 0 in MATLAB,
% coder.internal.indexInt(0) for code generation targets.
y = 0;

% [EOF]
