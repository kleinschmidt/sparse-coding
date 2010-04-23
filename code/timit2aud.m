function [aud, x] = timit2aud(fn)

params = [8, 8, .1, 0];

[x samprate] = readnist(fn);
x = unitseq(x);

aud = wav2aud(x, params);
