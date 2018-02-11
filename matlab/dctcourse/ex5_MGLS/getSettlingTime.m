function Ts = getSettlingTime(y, t, final, tol)

% tol defaults to 2%
if isempty(tol)
    tol = 0.02;
end    

% calculate the band that counts as settled
above = final * (1 + tol);
below = final * (1 - tol);

% find the last time it was above the boundary and the last time is was
% below the boundary
lastAbove = max(find(y >= above));
lastBelow = max(find(y <= below));

% return the settling time (I think this is right ??)
ix = max([lastAbove, lastBelow]) + 1;
if ix > length(t)
    Ts = Inf;
else
    Ts = t(ix);
end

% if it never reaches the 'settled' band, then set the settling time to
% infinity
if isempty(Ts)
    %disp(['response doesnt reach ' num2str(100 * (1 - tol)) '%']);
    Ts = Inf;
    return
end
