function plotMFR( timeStamps,labels,duration )
%heatmapSpikes  Heatmap of mean firing rate per channel
%   heatmapSpikes(timeStamps,duration) takes in a cell array with 60 elements 
%   containing the spike data for each channel, the duration [seconds] of 
%   the selected recordring, and generates a heatmap of the mean firing rate
%   for each channel.

    % Replace channel label 'Ref' with '15'
    refIndex = find(contains(labels,'Ref'));
    if refIndex ~= 0 
        labels{refIndex} = '15'; 
    end
    [labels,s] = sort(labels);
    timeStamps = timeStamps(s);
    
    for i=1:length(labels)
        mfr(i) = numel(timeStamps{i})/duration;
    end

    cfg = [];
    cfg.title = 'Mean firing rate';
    cfg.cbLabel = '[spike/s]';
    plot_layout(mfr,labels,cfg);
end

