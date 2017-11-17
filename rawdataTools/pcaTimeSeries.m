function [ coeff,score,latent,tsquared,explained,mu ] = pcaTimeSeries( analogData ,labels)
%pcaTimeSeries PCA on timeseries


    [coeff,score,latent,tsquared,explained,mu] = pca(analogData,'Centered',true);
    
    figure;
        scatter(score(:,1),score(:,2),'filled');
        title('Raw data - Scores')
        xlabel(['PC-1 (' num2str(explained(1)) '%)']);
        ylabel(['PC-2 (' num2str(explained(2)) '%)']);

    figure;
        exp = cumsum(explained);
        plot(exp ,'-o');
        ylim([0 100]);
        xlim([1 10]);
        xlabel('Principal components');
        ylabel('x-variance [%]');
        title('Timeseries - Explained variance');
    figure;
        hold on;
        scatter3(coeff(:,1),coeff(:,2),coeff(:,3),'filled')
        grid on;
        x = double(coeff(:,1));
        y = double(coeff(:,2));
        z = double(coeff(:,3));
        text(x,y,z, labels, 'horizontal','left', 'vertical','bottom');
        xlabel(['PC-1 (' num2str(explained(1)) '%)']);
        ylabel(['PC-2 (' num2str(explained(2)) '%)']);
        zlabel(['PC-3 (' num2str(explained(3)) '%)']);
        title('Raw data - Loadings');
        box on;
        view(3);

end

