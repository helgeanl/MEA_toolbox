function [  ] = pcaSpikeCutout( spikeCuts )
%pcaSpikeCutout PCA on Spike Cutouts
%   Detailed explanation goes here
    [coeff,score,latent,tsquared,explained,mu] = pca(cell2mat(spikeCuts.SegmentData));
    for i = 2:length(explained)
        explained(i) = explained(i)+explained(i-1);
    end
    figure;
        plot(explained );
        ylim([0 100]);
        xlim([1 10]);
        xlabel('Principal components');
        ylabel('x-variance [%]');
        title('Explained variance');
    figure;
        hold on;
        %for i=1:60
        %    scatter(score(i,1),score(i,2),'filled')
        %    text(score(i,1),score(i,2),spikeCuts.Info.Label(i));
        %end
        scatter(score(:,1),score(:,2),'filled')
        title('Score')
        xlabel('PC-1');
        ylabel('PC-2');
    figure;
        hold on;
        indexStart = 1;
        indexEnd = 1;
        for i=1:60
            numSpikes = size(spikeCuts.SegmentData{1,i},2);

            indexEnd = indexEnd + numSpikes -1;
            range = indexStart:indexEnd;
            scatter(coeff(range,1),coeff(range,2),'filled')
            text(coeff(range,1),coeff(range,2),spikeCuts.Info.Label(i));
            indexStart = indexStart + numSpikes;
        end
        %legend(spikeCuts.Info.Label);
        %scatter(coeff(:,1),coeff(:,2),'filled')
        title('Loadings')
        xlabel('PC-1');
        ylabel('PC-2');

end

