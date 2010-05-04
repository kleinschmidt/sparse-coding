function X = unmake_patches(patches, nr, nc, sz)

X = zeros(nr*sz, nc*sz);
i=1;
for c = 0:nc-1
    for r = 0:nr-1
        rows = (1:sz)+r*sz;
        cols = (1:sz)+c*sz;
        X(rows, cols) = reshape(patches(:,i), sz,sz);
        i = i+1;
    end
end

return