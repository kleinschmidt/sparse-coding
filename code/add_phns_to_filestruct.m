if ~exist('fs')
    load clips/whitened_auds.mat
    fs = filestruct;
end

%% read .PHN files
alldurs = [];
allstarts = [];
allends = [];
allphns = {};
for i=1:length(fs)
    fn = fs(i).filename;
    fid = fopen([fn(1:end-3) 'PHN']);
    phntxt = textscan(fid, '%n %n %s');
    fclose(fid);
    
    starts = phntxt{1};
    ends = phntxt{2};
    phns = phntxt{3};
    
    % convert to aud frame numbers
    audlen = size(fs(i).aud, 1) - 1;
    starts = floor(starts/max(ends)*audlen + 1);
    ends = ceil(ends/max(ends)*audlen + 1);
    alldurs = [alldurs; ends-starts];
    allstarts = [allstarts; starts];
    allends = [allends; ends];
    allphns = cat(1, allphns, phns);
    
    fs(i).phns = struct('start', num2cell(starts),...
        'end', num2cell(ends), ...
        'phn', phntxt{3});
end

%% Make a struct with all the segments
% length of segment and lead-in in aud frames
seglen = 30;
leadframes = 5;
allsegs = struct('phn', {}, 'fsn', {}, 'aud', {}, 'wht', {}, ...
    'start', {}, 'end', {}, 'dur', {}, 'prev', {}, 'next', {});
i=0;
% for each file
for n=1:length(fs)
    f=fs(n);
    % for each phn, excluding first and last (which are h#)
    for m=2:length(f.phns)-1
        seg=f.phns(m);
        i=i+1;
        first = seg.start-leadframes;
        last = min(seg.start+seglen-1, size(f.aud,1));
        
        aud = zeros(seglen+leadframes, size(f.aud,2));
        wht = zeros(seglen+leadframes, size(f.whitened,2));
        aud(1:(last-first+1), :) = f.aud(first:last,:);
        wht(1:(last-first+1), :) = f.whitened(first:last,:);
        
        allsegs(i).phn=seg.phn;
        allsegs(i).fsn=n;
        allsegs(i).aud=aud;
        allsegs(i).wht=wht;
        
        allsegs(i).start=seg.start;
        allsegs(i).end=seg.end;
        allsegs(i).dur=seg.end-seg.start;
        allsegs(i).prev=f.phns(m-1).phn;
        allsegs(i).next=f.phns(m+1).phn;
        fprintf('  %s: %d-%d\n', seg.phn,first,last);
    end
end
