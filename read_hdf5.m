%% Load hdf5-files and analyze spike cutouts, analog data, and spike data
% Download link to the McsHDF5 Matlab package
%   http://download.multichannelsystems.com/download_data/software/multi-channel-datamanager/McsMatlabDataTools.mltbx

%% Check if McsMatlabDataTools is installed
if isempty(which('McsHDF5.McsData'))
    fprintf("--------------------------------------------\n")
    fprintf(2,"* McsMatlabDataTools is not installed.\n")
    fprintf(2,"* Download and install the toolbox and try again\n")
    fprintf(2,"* http://www.multichannelsystems.com/software/multi-channel-datamanager\n")
    fprintf("--------------------------------------------\n")
    return
end

%% Input file
clear; 
[file, pathname] = uigetfile('*.h5','Select HDF5 file with recording');
window = []; % Time window
%% Load data
%cfg = [];
% Change the dataformat from double to single in to use less memory 
%cfg.dataType = 'single'; 
%adding cfg as an input to McsData
clc;
dataFile = McsHDF5.McsData([pathname file]);
fprintf("Recording: %s\n",file);
fprintf("- Date of recording: %s\n", dataFile.Data.Date);
fprintf("- Duration: %d s\n", dataFile.Recording{1,1}.Duration/1000000 );
fprintf("- Number of raw data recordings: %d\n",size(dataFile.Recording{1,1}.AnalogStream,2));
fprintf("- Number of spike trains: %d\n",size(dataFile.Recording{1,1}.SegmentStream,2));
input('Press ENTER to continue...')
while 1
    %% Choose recording
    clc;
    disp("1 - Spike cut")
    disp("2 - Analog values")
    disp("3 - Timestamps")
    disp("0 - Exit")
    rec = input('Choose recording type: ');

    %% Load segments of spike cutouts
    if rec == 1
        cfg = [];
        cfg.segment = []; % channel index ranging from i to j (1-60)
        spikeCuts = dataFile.Recording{1}.SegmentStream{1}.readPartialSegmentData(cfg);
        %plot(spikeCuts,[]); % plot the analog stream segment
        %for i = 1:length(spikeCuts.SegmentData)
        %    spikeCut = spikeCuts.SegmentData{1,i};
        %    save(['spikedata/ch' num2str(i) '.mat' ],'spikeCut');
        %end
        %% Choose method on spike cutouts
        while 1
            clc;
            disp("1 - PCA on spike cutouts")
            disp("0 - Go back ")
            method = input('Choose method: ');
            switch method
                case 1
                    %% PCA on spike cutouts
                    [coeff,score,latent,tsquared,explained,mu] = pca(cell2mat(spikeCuts.SegmentData));
                    for i = 2:length(explained)
                        explained(i) = explained(i)+explained(i-1);
                    end
                    figure(10);clf(10);
                        plot(explained );
                        ylim([0 100]);
                        xlim([1 10]);
                        xlabel('Principal components');
                        ylabel('x-variance [%]');
                        title('Explained variance');
                    figure(11);clf(11);
                        hold on;
                        %for i=1:60
                        %    scatter(score(i,1),score(i,2),'filled')
                        %    text(score(i,1),score(i,2),spikeCuts.Info.Label(i));
                        %end
                        scatter(score(:,1),score(:,2),'filled')
                        title('Score')
                        xlabel('PC-1');
                        ylabel('PC-2');
                    figure(12);clf(12);
                        hold on;
                        channel = 0;
                        numSpikes = 0;
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
                case 0
                    break;
            end
        end
    %% Load segments of analog channel data
    elseif rec == 2
        cfg = [];
        chan = getLabelIndex('44');
        cfg.channel = []; % channel index ranging from i to j (1-60)
        cfg.window = window; % time range in seconds
        % Original
        analogData = dataFile.Recording{1}.AnalogStream{1}.readPartialChannelData(cfg);
        % alpha
        %analogData2 = dataFile.Recording{1}.AnalogStream{2}.readPartialChannelData(cfg);
        % highpass
        %analogData3 = dataFile.Recording{1}.AnalogStream{3}.readPartialChannelData(cfg);
        %plot(analogData3,[]); % plot the analog stream segment
        data = analogData.ChannelData;

        
        %% Choose method on analog data
        while 1
            clc;
            disp("1 - Cross correlation")
            disp("2 - PCA on timeseries")
            disp("0 - Go back ")
            method = input('Choose method: ');
            switch method
                case 1
                    %% Create cross correlation map
                    crossCor(data);
                case 2
                    %% PCA on timeseries
                    [coeff,score,latent,tsquared,explained,mu] = pca((analogData.ChannelData)');
                    for i = 2:length(explained)
                        explained(i) = explained(i)+explained(i-1);
                    end
                    figure(22);clf(22);
                        hold on
                        %for i=1:60
                        %    scatter(score(i,1),score(i,2),'filled')
                        %    text(score(i,1),score(i,2),analogData.Info.Label(i));
                        %end
                        scatter(score(:,1),score(:,2),'filled')
                        title('Scores')
                        xlabel('PC-1');
                        ylabel('PC-2');
                    figure(23);clf(23);
                        plot(explained );
                        ylim([0 100]);
                        xlim([1 10]);
                        xlabel('Principal components');
                        ylabel('x-variance [%]');
                        title('Explained variance');
                    figure(24);clf(24);
                        hold on;
                        for i=1:60
                            scatter(coeff(i,1),coeff(i,2),'filled')
                            text(coeff(i,1),coeff(i,2),analogData.Info.Label(i));
                        end
                        %scatter(coeff(:,1),coeff(:,2),'filled')
                        xlabel('PC-1');
                        ylabel('PC-2');
                        title('Loadings');
                case 0
                    break;
            end
        end
    %% Load segments of time stamps (Raster plot)
    elseif rec == 3
        cfg = [];
        cfg.timestamp = []; % channel indexes (1-60)
        cfg.window = window; % time range in seconds
        timeStampData = dataFile.Recording{1}.TimeStampStream{1}.readPartialTimeStampData(cfg);
        

        %% Choose method on spike data
        while 1
            clc;
            disp("1 - Generate heatmap with number of spikes")
            disp("2 - Bargraph with number of spikes")
            disp("3 - Pattern of spikes firing at the same time")
            disp("4 - Pattern of spikes firing after a spike within a delta")
            disp("5 - Export to ToolConnect format ")
            disp("6 - Rasterplot")
            disp("0 - Go back ")
            method = input('Choose method: ');
            switch(method)   
                case  1
                    %% Generate heatmap
                    heatmapSpikes( timeStampData )
                case  2
                    %% Generate bar graph of spike count
                    bargraph( timeStampData )
                case 3
                    %% Pattern of spikes firing at the same time
                    heatmapPattern(timeStampData,true)
                case  4
                    %% Pattern of spikes firing after a spike within a delta
                    heatmapPattern(timeStampData,false)
                case  5
                    %% Export to ToolConnect format
                    exportToolConnect(timeStampData,dataFile.Recording{1,1}.Duration)
                case  6
                    %% Create Rasterplot
                    rasterplot(timeStampData);
                case 0
                    % Go back to main manu
                    break
            end
        end

    elseif rec == 0
        %% Clear workspace and exit
        %clear;
        return
    end
end
    
    
    


