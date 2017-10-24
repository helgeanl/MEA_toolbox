function [  ] = crossCor( data )
%crossCor Cross correlation map from analog data
%   Create cross correlation map
    cc = zeros(60,60);
    xcor = dsp.Crosscorrelator;
    for chan1Index = 1:numel(data(:,1))
        for chan2Index = 1:numel(data(:,1))
            if chan1Index ~= chan2Index
                cc(chan1Index,chan2Index) = mean(xcor(data(chan1Index,:),data(chan2Index,:)));
            end
        end
    end
    figure(21);
    heatmap(cc);
    title('Cross correlation')
    ylabel('Electrodes')
    %set(gca,'YTickLabel',strtrim(analogData.Info.Label));
    xlabel('Electrodes')
    %set(gca,'XTickLabel',strtrim(analogData.Info.Label));
end

