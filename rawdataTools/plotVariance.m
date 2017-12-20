function variance = plotVariance(data,labels)
%plotVariance Plot the variance from each electrode
%   variance = plotVariance(DATA,LABELS) returns a vector containing the
%   variance in each electrode, sorted from lowest to highest electrode. 
%   
%   DATA is a NxM matrix where N is the timeseries and M electrodes. 
%   LABELS is a cell array containing all the string labels in the
%   recording.
%
%   The variance for each electrode is plotted on the 60MEA layout.
    
    % Replace channel label 'Ref' with '15'
    refIndex = find(contains(labels,'Ref'));
    if refIndex ~= 0 
        labels{refIndex} = '15'; 
    end
    [labels,s] = sort(labels);
    data = data(:,s);
    variance = std(data).^2;
    cfg = [];
    cfg.title = 'Variance';
    plot_layout(variance,labels,cfg);
end


