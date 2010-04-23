cd ~/Documents/modeling/sparse-coding/TIMIT

[ts1 sr1] = readnist('timit/SA1');
[ts2 sr2] = readnist('timit/SI1027.WAV');
[ts3 sr3] = readnist('timit/SI1657.WAV');
[ts4 sr4] = readnist('timit/SI648.WAV');

%%
x1 = unitseq(ts1);
x2 = unitseq(ts2);
x3 = unitseq(ts3);
x4 = unitseq(ts3);

%%
paras = [8 8 -.1 0];
y1 = wav2aud(x1, paras);
aud_plot(y1, paras);

%%
figure(1);
subplot(1,2,1); 
paras = [8 8 -.1 0];
aud_plot(wav2aud(x1, paras), paras);

subplot(1,2,2);
paras = [8 8 .1 0];
aud_plot(wav2aud(x1, paras), paras);
colorbar();
