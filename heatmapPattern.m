function [ pattern ] = heatmapPattern( timeStampData, instantaneous )
%heatmapPattern Geneate heatmap of neurons firing within a delta
%   Takes in a time stamp data object (McsTimeStampStream) 
%   and generates a heatmap with number of spikes per channel
    if instantaneous == false
        while(1)
            delta = input(['Choose delta [' char(956) 's]: ']);
            if (~isnumeric(delta)) || isempty(delta) || delta <0
                fprintf(2,'- Input a positive number\n');
            else
                break;
            end
        end
    else
        delta = 0;
    end
    timeStamps = timeStampData.TimeStamps;
    pattern = zeros(60,60);
    for chan1Index = 1:numel(timeStamps)
        for spikeTime = timeStamps{1,chan1Index}
            for chan2Index = 1:numel(timeStamps)
                if chan1Index ~= chan2Index
                    if instantaneous == true
                        if sum(timeStamps{1,chan2Index}>=(spikeTime) & timeStamps{1,chan2Index}<= (spikeTime +delta ))
                            pattern(chan1Index,chan2Index) = pattern(chan1Index,chan2Index) +1;
                        end
                    else
                         if sum(timeStamps{1,chan2Index}>(spikeTime) & timeStamps{1,chan2Index}<= (spikeTime +delta ))
                            pattern(chan1Index,chan2Index) = pattern(chan1Index,chan2Index) +1;
                        end
                    end
                end
            end
        end
    end
    figure;
    imagesc(pattern);

    %pcolor(pattern);
    %caxis([0 15])
    colorbar;
    labels = timeStampData.Info.Label;

    set(gca, 'XTick', 1:length(labels), 'XTickLabel', labels)
    set(gca, 'YTick', 1:length(labels), 'YTickLabel', labels)
    grid on;
    xtickangle(90);
    %heatmap(pattern);
    title(['Pattern of spikes firing within a delta = ' num2str(delta) ' ' char(956) 's']);

end

