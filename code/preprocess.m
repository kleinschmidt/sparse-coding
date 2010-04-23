
% ensure the nsltools toolbox is loaded
loadload;

% get list of all TIMIT .wav files (compiled earlier) and shuffle them
filenames = textread([sparse_coding_dir() 'clips/all_TIMIT_WAVs.txt'], '%s');
rand_files = filenames(randperm(length(filenames)));

numfiles = 50;   % start small, this maybe should be more like 50

% initialize the struct for the processed files
filestruct = struct('filename', {}, 'waveform', {}, ...
    'aud', {}, 'whitened', {});
for n = 1:numfiles
    fn = rand_files{n};
    fprintf('Processing file number %d\n', n)
    fprintf('  name: %s\n', fn);
    fprintf('  generating cochleagram...')
    [aud, wav] = timit2aud(fn);
    fprintf('done (%d by %d)\n', size(aud));
    filestruct(n).filename = fn;
    filestruct(n).aud = aud;
    filestruct(n).waveform = wav;
    fprintf('  spatially whitening...');
    filestruct(n).whitened = whiten_image(aud);
    fprintf('done\n')
end

save([sparse_coding_dir() 'clips/whitened_auds.mat'], 'filestruct');
