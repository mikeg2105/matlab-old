function Tr = getRiseTime(y, t, final, limits)

lower = limits(1);
upper = limits(2);

% upper defaults to 0.9
% lower defaults to 0.1
if isempty(limits)
    lower = 0.1;
    upper = 0.9;
end

% find the upper time
i = find(y >= (upper * final));

% if the response time never reaches the point at which rise time is
% measured then the rise time is infinity
if isempty(i)
    %disp(['response doesnt reach ' num2str(100 * upper) '%']);
    Tr = Inf;
    return
end

% get the upper time
upp_t = t(i(1));

% find the lower time
i = find(y >= (lower * final));
low_t = t(i(1));

% get the rise time
Tr = upp_t - low_t;