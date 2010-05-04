function [avgaud, n] = phn_avg(segs, phn, useWhitened)
% function avgaud = phn_avg(segs, phn, useWhitened)
%
% compute the average AUD for a given phn name

if nargin<3, useWhitened=0; end

n=0;
avgaud = zeros(size(segs(1).aud));
for seg=segs
    if strcmp(phn,seg.phn)
        if useWhitened
            avgaud = avgaud + seg.wht;
        else
            avgaud = avgaud + seg.aud;
        end
        n=n+1;
    end
end

avgaud = avgaud/n;
return
