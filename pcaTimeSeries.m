function [  ] = pcaTimeSeries( analogData, labels )
%pcaTimeSeries PCA on timeseries
%   
    [coeff,score,latent,tsquared,explained,mu] = pca(analogData);
    for i = 2:length(explained)
        explained(i) = explained(i)+explained(i-1);
    end
    figure;
        hold on
        for i=1:60
           scatter(score(i,1),score(i,2),'filled')
           text(score(i,1),score(i,2),labels(i));
        end
%         scatter(score(:,1),score(:,2),'filled')
        title('Scores')
        xlabel('PC-1');
        ylabel('PC-2');
    figure;
        plot(explained );
        ylim([0 100]);
        xlim([1 10]);
        xlabel('Principal components');
        ylabel('x-variance [%]');
        title('Explained variance');
    figure;
        hold on;
%         for i=1:60
%             scatter(coeff(i,1),coeff(i,2),'filled')
%             text(coeff(i,1),coeff(i,2),labels(i));
%         end
        scatter(coeff(:,1),coeff(:,2),'filled')
        xlabel('PC-1');
        ylabel('PC-2');
        title('Loadings');

end

