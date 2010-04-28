function [patches, nr, nc] = make_patches(X, sz)
% make_patches(X,sz): break a matrix up into square patches
%
% output is a sz^2-by-n matrix

[rs, cs] = size(X);
nr = floor(rs/sz);
nc = floor(cs/sz);
n = nr*nc;

rpad = floor(mod(rs,sz)/2);
cpad = floor(mod(cs,sz)/2);

patches = zeros(sz^2, n);
i = 1;
for c = 0:nc-1
    for r = 0:nr-1
        rows = (1:sz)+r*sz+rpad;
        cols = (1:sz)+c*sz+cpad;
        patch = X(rows, cols);
        patches(:,i) = patch(:);
        i = i+1;
    end
end

return;
