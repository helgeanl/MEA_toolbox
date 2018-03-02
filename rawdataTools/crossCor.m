function crosscor( data, labels )
%crosscor Cross correlation map from analog data
%   crosscor(data) takes in a NxM matrix with a timeseries of size N 
%   and M channels. This is used to calculate and plot the crosscorrelation
%   between each channel, with a lag search of 10 samples.
%   Requires Signal Processing Toolbox

    % Limits to the colorbar [min max]
    colorLimits = [0 1];

    nChannels = size(data,2);
    cc = zeros(nChannels,nChannels);
    for chan1Index = 1:nChannels
        for chan2Index = 1:nChannels
            if chan1Index ~= chan2Index
                ccTemp = xcorr(data(:,chan1Index),data(:,chan2Index),10,'coeff');
                ccTemp(11:end)=[];
                cc(chan1Index,chan2Index) =  max(ccTemp);
            end
        end
    end
    
    % Replace channel label 'Ref' with '15'
    refIndex = find(contains(labels,'Ref'));
    if refIndex ~= 0 
        labels{refIndex} = '15'; 
    end
    [labels,s ]= sort(labels);
    cc = cc(s,s);
    
    % Plot heatmap
    figure;
    imagesc(cc);
    colorbar;
    caxis(colorLimits)
    set(gca, 'XTick', 1:length(labels), 'XTickLabel', labels)
    set(gca, 'YTick', 1:length(labels), 'YTickLabel', labels)
    grid on;
    xtickangle(90);
    title('Cross correlation')
    xlabel('Electrodes')
    ylabel('Electrodes')
    
    % Plot directional graph
    cfg = [];
    cfg.title = 'Cross correlation';
    dirgraph(cc, labels, 1, cfg);
end

