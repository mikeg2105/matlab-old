function overshoot = getOvershoot(y, t, final)

% find the maximum overshoot
[overshoot, ix] = max(y);

if isempty(overshoot)
    %disp(['response doesnt overshoot']);
    overshoot = 0;
    return
end

% calculate the percentage overshoot relative to the final value
overshoot = (overshoot - final) / final;