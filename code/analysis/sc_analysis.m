% loads filestruct
load([sparse_coding_dir '/clips/whitened_auds.mat']);
% load A
load([sparse_coding_dir '/output/run-4-27_16x16_n192.mat']);


%% Patches analysis...
i = 1;
au = filestruct(i).whitened;

[L,M] = size(A);
sz = sqrt(L);

[ps, nr, nc] = make_patches(au, sz);

% compute activations of units for each patch
u = ps'*A;
% convert to 3d array
u = reshape(u, nr, nc, M);
view_patches_by_freq(u);