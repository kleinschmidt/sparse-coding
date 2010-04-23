function aud = timit2aud(filename)

params = [8, 8, .1, 0];

[x samprate] = readnist(fn);
x = unitseq(x);

aud = wav2aud(x, params);