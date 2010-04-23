
clippref = [sparse_coding_dir() 'clips/'];

[ts1 sr1] = readnist([clippref 'SA1.WAV']);
[ts2 sr2] = readnist([clippref 'SI1027.WAV']);
[ts3 sr3] = readnist([clippref 'SI1657.WAV']);
[ts4 sr4] = readnist([clippref 'SI648.WAV']);

%%
x1 = unitseq(ts1);
x2 = unitseq(ts2);
x3 = unitseq(ts3);
x4 = unitseq(ts4);

%%
loadload;
paras = [8 8 -.1 0];
y1 = wav2aud(x1, paras);
aud_plot(y1, paras);

%%
figure(1);
subplot(1,2,1); 
paras = [8 8 .05 0];
aud_plot(wav2aud(x1, paras), paras);
%%
subplot(1,2,2);
paras = [8 8 .1 0];
aud_plot(wav2aud(x1, paras), paras);
colorbar();

%%
y1 = wav2aud(x1, paras);
y2 = wav2aud(x2, paras);
y3 = wav2aud(x3, paras);
y4 = wav2aud(x4, paras);

%% some plotting stuff
getTs = @(x, sr) (1:length(x))/sr;

figure(2)

subplot(2,4,1); plot(getTs(x1,sr1), x1); axis tight;
subplot(2,4,2); plot(getTs(x2,sr2), x2); axis tight;
subplot(2,4,3); plot(getTs(x3,sr3), x3); axis tight;
subplot(2,4,4); plot(getTs(x4,sr4), x4); axis tight;

subplot(2,4,5); aud_plot(y1, paras);
subplot(2,4,6); aud_plot(y2, paras);
subplot(2,4,7); aud_plot(y3, paras);
subplot(2,4,8); aud_plot(y4, paras);
