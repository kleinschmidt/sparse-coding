% run the sparsenet algorithm on the AUDs (cochleagrams) extracted from the
% TIMIT samples by preprocess.m

fprintf('SPARSE_CODE_AUDS -- running the sparse coding model in TIMIT AUDS\n');

% this loads the struct array filestruct
load([sparse_coding_dir() '/clips/whitened_auds.mat']);

%% create the IMAGES array required by sparsenet.m
fprintf('  Generating IMAGES:\n');
IMAGES = cell(size(filestruct));
for n = 1:length(filestruct)
    im = filestruct(n).whitened;
    IMAGES{n} = im;
    fprintf('   %3d: %d by %d\n', n, size(im));
end

%% create A, the matrix of basis functions
basis_size = 16;    % start small
num_bases = 192;
fprintf('  Generating %d (%d-by-%d) basis functions A\n', ...
    num_bases, basis_size, basis_size)
A = rand(basis_size^2, num_bases) - 0.5;
A = A*diag(1./sqrt(sum(A.*A)));


%% run the model
fprintf('  Starting sparsenet.m ...\n')
sparsenet