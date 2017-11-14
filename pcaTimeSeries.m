function [ coeff,score,latent,tsquared,explained,mu ] = pcaTimeSeries( analogData, labels )
%pcaTimeSeries PCA on timeseries
   
    [coeff,score,latent,tsquared,explained,mu] = pca(analogData,'Centered',true);
   
    figure;
        hold on
%         for i=1:min(size(analogData))
%            scatter(score(i,1),score(i,2),'filled')
%            text(score(i,1),score(i,2),labels(i));
%         end
         scatter(score(:,1),score(:,2),'filled')
        title('Scores')
        xlabel(['PC-1 (' num2str(explained(1)) '%)']);
        ylabel(['PC-2 (' num2str(explained(2)) '%)']);
    figure;
        exp = cumsum(explained);
        plot(exp ,'-o');
        ylim([0 100]);
        xlim([1 10]);
        xlabel('Principal components');
        ylabel('x-variance [%]');
        title('Explained variance');
    figure;
        hold on;
        for i=1:min(size(analogData))
            scatter(coeff(i,1),coeff(i,2),'filled')
            text(coeff(i,1),coeff(i,2),labels(i));
        end

        xlabel(['PC-1 (' num2str(explained(1)) '%)']);
        ylabel(['PC-2 (' num2str(explained(2)) '%)']);
        title('Loadings');

end

