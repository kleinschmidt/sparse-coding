
% ensure the nsltools toolbox is loaded
loadload;

% get list of all TIMIT .wav files (compiled earlier) and shuffle them
filenames = textread([sparse_coding_dir() 'clips/all_TIMIT_WAVs.txt'], '%s');
rand_files = filenames(randperm(length(filenames)));

numfiles = 50;   % start small, this maybe should be more like 50

if ~exist('filestruct')
    % initialize the struct for the processed files
    filestruct = struct('filename', {}, 'waveform', {}, ...
        'aud', {}, 'whitened', {});
end
imvars = zeros(numfiles, 1);
for n = 1:numfiles
    if exist('filestruct')
        fn = filestruct(n).filename;
    else
        fn = rand_files{n};
    end
    fprintf('Processing file number %d\n', n)
    fprintf('  name: %s\n', fn);
    fprintf('  generating cochleagram...')
    [aud, wav] = timit2aud(fn);
    fprintf('done (%d by %d)\n', size(aud));
    filestruct(n).filename = fn;
    filestruct(n).aud = aud;
    filestruct(n).waveform = wav;
    fprintf('  spatially whitening...');
    % just rescale to [0 1] for now
    %white = whiten_image(aud);
    white = (aud-min(aud(:))) / range(aud(:));
    filestruct(n).whitened = white;
    imvars(n) = var(white(:));
    fprintf('done\n')
end

% adjust so that the mean variance is 0.1
fprintf('  Adjusting variance to have mean of 0.1');
var_adjustment = sqrt(0.1/mean(imvars));
for n = 1:numfiles
    filestruct(n).whitened = filestruct(n).whitened * var_adjustment;
    imvars(n) = var(filestruct(n).whitened(:));
end
fprintf(' (actual mean: %g)', mean(imvars));



save([sparse_coding_dir() 'clips/whitened_auds_rescaled_only.mat'], 'filestruct');
