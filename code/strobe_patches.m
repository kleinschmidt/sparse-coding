function [patches nr nc] = strobe_patches(X, window, stepsize)
% function [patches nr nc] = strobe_patches(X, window[, stepsize])
%
% Strobes the given size window across X, returning a matrix of vectorized
% patches, and, optionally, the number of row- and column-wise steps.
% Stepsize optionally specifies how many spaces to skip with each window.

[rs cs] = size(X);
wrs = window(1);
wcs = window(2);

if nargin < 3, stepsize = 1; end

rows = 1:stepsize:rs-wrs+1;
cols = 1:stepsize:cs-wcs+1;
nr = length(rows);
nc = length(cols);

patches = zeros(wrs*wcs, nr*nc);

i=0;
for c = cols
    for r = rows
        i = i+1;
        patch = X(r+(1:wrs), c+(1:wcs));
        patches(:,i) = patch(:);
    end
end
