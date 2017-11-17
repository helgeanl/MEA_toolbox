%% Load hdf5-files and analyze spike cutouts, analog data, and spike data
% Download link to the McsHDF5 Matlab package
%   http://download.multichannelsystems.com/download_data/software/multi-channel-datamanager/McsMatlabDataTools.mltbx

%% Check if McsMatlabDataTools is installed
if isempty(which('McsHDF5.McsData'))
    fprintf('--------------------------------------------\n')
    fprintf(2,'* McsMatlabDataTools is not installed.\n')
    fprintf(2,'* Download and install the toolbox and try again\n')
    fprintf(2,'* http://www.multichannelsystems.com/software/multi-channel-datamanager\n')
    fprintf(2,'* or install using the Add-On Explorer in Matlab\n')
    fprintf('--------------------------------------------\n')
    return
end

%% Add to path all the subdirectories in the toolbox
topdir = fileparts(which(mfilename));
addpath(genpath(topdir));

%% Input file
clear; 
[file, pathname] = uigetfile('*.h5','Select HDF5 file with recording');
if ~file % Exit script if error in opening file
    return
end
fs = 10000; % Sampling rate in Hz

%% Load data



% Change the dataformat from double to single to use less memory 
% -> max voltage: +/-2mV
% -> max time: 30min
cfg = [];
cfg.dataType = 'single'; 

% Load recording info
dataFile = McsHDF5.McsData([pathname file],cfg);
duration = dataFile.Recording{1,1}.Duration*1e-6; % microsec -> sec

clc;
fprintf('Recording: %s\n',file);
fprintf('- Date of recording: %s\n', dataFile.Data.Date);
fprintf('- Duration: %d s\n', duration);
fprintf('- Sampling rate: %d Hz\n', fs);
fprintf('- Number of raw data recordings: %d\n',size(dataFile.Recording{1,1}.AnalogStream,2));
fprintf('- Number of spike trains: %d\n',size(dataFile.Recording{1,1}.SegmentStream,2));
input('Press ENTER to continue...');

while 1
    %% Choose recording
    clc;
    fprintf('Recording: %s \n',file);
    disp('1 - Spike cutout')
    disp('2 - Analog values')
    disp('3 - Timestamps (spike train)')
    disp('0 - Exit')
    rec = input('Choose recording type: ');

    %% Load segments of spike cutouts
    switch rec
        case 1
            cfg = [];
            cfg.segment = []; % channel index ranging from i to j (1-60)
            spikecutData = dataFile.Recording{1}.SegmentStream{1}.readPartialSegmentData(cfg);
            spikecuts = spikecutData.SegmentData;
            labels = spikecutData.Info.Label;
            %plot(spikeCuts,[]); % plot the analog stream segment
            %for i = 1:length(spikeCuts.SegmentData)
            %    spikeCut = spikeCuts.SegmentData{1,i};
            %    save(['spikedata/ch' num2str(i) '.mat' ],'spikeCut');
            %end
            %% Choose method on spike cutouts
            while 1
                clc;
                fprintf('Recording: %s \n',file);
                disp('1 - PCA on spike cutouts')
                disp('0 - Go back ')
                method = input('Choose method: ');
                if ~isnumeric(method) || isempty(method)
                    method = -1;
                end
                switch method
                    case 1
                        %% PCA on spike cutouts
                        pcaSpikeCutout( spikecuts,labels );
                    case 0
                        break;
                end
            end
        %% Load segments of analog channel data
        case 2
            clc;
            fprintf('Duration of recording: %d s\n', duration);
            fprintf('Input the start and end time in seconds, of which segment you want to use\n');
            tStart = input('Start: ');
            if isempty(tStart)
                tStart = 0 ;
            end
            tEnd = input('End: ');
            if isempty(tEnd)
                tEnd = duration;
            end
            window = [tStart tEnd]; % Time window
            cfg = [];
            cfg.channel = []; % channel index ranging from i to j (1-60)
            cfg.window = window; % time range in seconds
            
            % Select recording if more than one
            if size(dataFile.Recording{1}.AnalogStream,2) > 1
                clc;
                fprintf('Analog streams in the recording:\n');
                for i=1:size(dataFile.Recording{1}.AnalogStream,2)
                    fprintf('%d - %s\n',i,dataFile.Recording{1}.AnalogStream{i}.Label);
                end
                stream = input('Select recording to process: ');
            else
                stream = 1;
            end
            analogData = dataFile.Recording{1}.AnalogStream{stream}.readPartialChannelData(cfg);
            %plot(analogData3,[]); % plot the analog stream segment
            data = analogData.ChannelData';
            labels = analogData.Info.Label;

            %% Choose method on analog data
            while 1
                clc;
                fprintf('Recording: %s [%d - %ds]\n',file,tStart,tEnd);
                disp('1 - Cross correlation')
                disp('2 - PCA on timeseries')
                disp('3 - Export raw data to .mat')
                disp('4 - Filter the data with 2nd order butterworth 200 Hz highpass filter')
                disp('5 - Filter the data with 2nd order butterworth 8-13Hz bandpass filter')
                disp('6 - Plot PDS of signal')
                disp('0 - Go back ')
                method = input('Choose method: ');
                if ~isnumeric(method) || isempty(method)
                    method = -1;
                end
                switch method
                    case 1
                        %% Create cross correlation map
                        crossCor(data);
                    case 2
                        %% PCA on timeseries
                        % Remove ref node as outlier
                        tempdata = data;
                        templabels = labels;
                        tempdata(:,15)=[];
                        templabels(15)=[];
                        pcaTimeSeries(tempdata,templabels);
                        clear tempdata templabels
                    case 3
                        %% Export raw data to .mat
                        [filename, pathname] = uiputfile('*.mat','Save file as');
                        if isequal(filename,0) || isequal(pathname,0)
                           disp('User pressed cancel')
                        else
                           save([ pathname filename ],'data');
                        end
                    case 4
                        data = highpassFilter(2,500,fs,data);
                    case 5
                        data = bandpassFilter(2,8,13,fs,data);
                    case 6
                        plotPDS(data(:,26)); %26
                    case 0
                        break;
                end
            end
        %% Load segments of time stamps (spike train)
        case 3
            clc;
            fprintf('Duration of recording: %d s\n', duration);
            fprintf('Input the start and end time in seconds, of which segment you want to use\n');
            tStart = input('Start: ');
            if isempty(tStart)
                tStart = 0 ;
            end
            tEnd = input('End: ');
            if isempty(tEnd)
                tEnd = duration;
            end
            window = [tStart tEnd]; % Time window
            cfg = [];
            cfg.timestamp = []; % channel indexes (1-60)
            cfg.window = window; % time range in seconds
            timeStampData = dataFile.Recording{1}.TimeStampStream{1}.readPartialTimeStampData(cfg);
            timeStamps = timeStampData.TimeStamps;
            labels = timeStampData.Info.Label;

            %% Choose method on spike data
            while 1
                clc;
                fprintf('Recording: %s [%d - %ds]\n',file,tStart,tEnd);
                disp('1 - Generate heatmap with number of spikes')
                disp('2 - Bargraph with number of spikes')
                disp('3 - Pattern of spikes firing at the same time')
                disp('4 - Pattern of spikes firing after a spike within a delta')
                disp('5 - Export to ToolConnect format ')
                disp('7 - Import Connectivity matrix from ToolConnect end plot graph')
                disp('0 - Go back ')
                method = input('Choose method: ');
                if ~isnumeric(method) || isempty(method)
                    method = -1;
                end
                switch(method)   
                    case  1
                        %% Generate heatmap
                        heatmapSpikes( timeStamps,(tEnd-tStart) )
                    case  2
                        %% Generate bar graph of spike count
                        bargraph( timeStamps )
                    case 3
                        %% Pattern of spikes firing at the same time
                        pattern = heatmapPattern(timeStamps,labels,0);
                    case  4
                        %% Pattern of spikes firing after a spike within a delta
                        while(1)
                            delta = input(['Choose delta [' char(956) 's]: ']);
                            if (~isnumeric(delta)) || isempty(delta) || delta <0
                                fprintf(2,'- Input a positive number\n');
                            else
                                break;
                            end
                        end
                        pattern = heatmapPattern(timeStamps,labels,delta);
                        clear delta;
                    case  5
                        %% Export to ToolConnect format
                        exportToolConnect(timeStamps,tStart,tEnd,fs)
                    case  6
                        %% Create Rasterplot
                        rasterplot(timeStampData);
                    case  7
                        %% Import Connectivity matrix from ToolConnect end plot graph
                        [filename, pathname] = uigetfile('*.txt','Select CM file to plot');
                        if isequal(filename,0) || isequal(pathname,0)
                           disp('User pressed cancel')
                        else
                           cm = load([pathname filename]);
                           dirGraph(cm,0,0);
                        end
                    case 0
                        % Go back to main manu
                        break
                    otherwise
                        % Do nothing
                end
            end

        case 0
            %% Clear workspace and exit
            clc;
            reply = input('Clear workspace on exit? [Y/n] ','s');
            if isequal(reply,'N') || isequal(reply,'n')
                return
            end
            clear;
            return

    end
end
    
    



