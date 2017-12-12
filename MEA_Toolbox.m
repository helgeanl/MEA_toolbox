%% MEA Toolbox for analysing spike cutouts, analog data, and spike data

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
if ~file % Exit script if user canceled the open file dialog
    return
end

%% Load data
% Change the dataformat from double to single to use less memory, 
% this could however lead to too low precision when using PCA.
cfg = [];
cfg.dataType = 'double'; 

% Load recording info
try
    dataFile = McsHDF5.McsData([pathname file],cfg);
catch
    fprintf(2,'This is not a valid Mcs HDF5 file!\n')
    return
end
duration = double(dataFile.Recording{1,1}.Duration)*1e-6; % microsec -> sec
recordingDate = dataFile.Data.Date;
if contains(recordingDate,'?')
    recordingDate = replace(recordingDate,'?','_'); 
end

% Calculate sampling rate from recording time ticks
cfg = [];
cfg.timestamp = []; % channel indexes (1-60)
cfg.window = [0 1]; % time range in seconds
if ~isempty(dataFile.Recording{1}.AnalogStream)
    tick = dataFile.Recording{1}.AnalogStream{1}.Info.Tick(1);
    fs = 1/(double(tick)*1e-6);
elseif ~isempty(dataFile.Recording{1}.SegmentStream)
    tick = dataFile.Recording{1}.SegmentStream{1}.SourceInfoChannel.Tick(1);
    fs = 1/(double(tick)*1e-6);
else
    fprintf(2,'File format is incompatible with this toolbox!\n')
    return
end

clc;
fprintf('Recording: %s\n',file);
fprintf('- Date of recording: %s\n', recordingDate);
fprintf('- Duration: %0.2f s\n', duration);
fprintf('- Sampling rate: %d Hz\n', fs);
fprintf('- Number of raw data recordings: %d\n',size(dataFile.Recording{1,1}.AnalogStream,2));
fprintf('- Number of spike trains: %d\n',size(dataFile.Recording{1,1}.SegmentStream,2));
input('Press ENTER to continue...');

%% Choose recording
while 1
    
    clc;
    fprintf('Recording: %s \n',file);
    disp('1 - Spike cutout')
    disp('2 - Analog values')
    disp('3 - Timestamps (spike train)')
    disp('0 - Exit')
    reply = input('Choose recording type: ');
    if isempty(reply)
        reply = -1;
    end
    
    switch reply
        case 1 %% Load segments of spike cutouts    
            cfg = [];
            cfg.segment = []; % channel index ranging from i to j (1-60)
            spikecutData = dataFile.Recording{1}.SegmentStream{1}.readPartialSegmentData(cfg);
            spikecuts = spikecutData.SegmentData;
            labels = spikecutData.Info.Label;

            %% Choose method on spike cutouts
            while 1
                clc;
                fprintf('Recording: %s \n',file);
                disp('1 - PCA on spike cutouts')
                disp('0 - Go back ')
                reply = input('Choose method: ');
                if ~isnumeric(reply) || isempty(reply)
                    reply = -1;
                end
                switch reply
                    case 1
                        % PCA on spike cutouts
                        [ coeff,score,latent,tsquared,explained,mu ]=pcaSpikeCutout( spikecuts,labels,15 ,6);
                    case 0
                        % Go back to main menu
                        break;
                    otherwise % Do nothing 
                end
            end
        
        case 2 %% Load segments of analog channel data
            
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
            data = analogData.ChannelData';
            time = McsHDF5.TickToSec(analogData.ChannelDataTimeStamps);
            labels = analogData.Info.Label;

            %% Choose method on analog data
            while 1
                clc;
                fprintf('Recording: %s [%d - %ds]\n',file,tStart,tEnd);
                disp('1 - Cross correlation')
                disp('2 - PCA on timeseries')
                disp('3 - Export raw data to .mat')
                disp('4 - Filter the data with 1st order butterworth 300 Hz highpass filter')
                disp('5 - Filter the data with 1st order butterworth 300 Hz lowpass filter')
                disp('6 - Filter the data with 1st order butterworth 300-3000 Hz bandpass filter')
                disp('7 - Plot PDS of one channel')
                disp('8 - Plot energy for each electrode')
                disp('9 - Plot the analog value from one channel');
                disp('0 - Go back ')
                reply = input('Choose method: ');
                if ~isnumeric(reply) || isempty(reply)
                    reply = -1;
                end
                switch reply
                    case 1 % Create cross correlation map
                        crosscor(data,labels);
                    case 2 % PCA on timeseries
                        [ coeff,score,latent,tsquared,explained,mu ] = pcaTimeSeries(data,labels,15,10);
                    case 3 % Export raw data to .mat
                        [filename, pathname] = uiputfile('*.mat','Save file as');
                        if isequal(filename,0) || isequal(pathname,0)
                           disp('User pressed cancel')
                        else
                           save([ pathname filename ],'data');
                        end
                    case 4 % highpass filter
                        data = highpassFilter(1,300,fs,data);
                    case 5 % lowpass filter
                        data = lowpassFilter(1,300,fs,data);
                    case 6 % bandpass filter
                        data = bandpassFilter(1,300,3000,fs,data);
                    case 7 % Plot PDS of one channel 
                        reply = input('Choose channel: ');
                        if isnumeric(reply) && ~isempty(reply)
                            plotPDS(data(:,reply),num2str(reply)); 
                        end 
                    case 8 % Plot energy for each electrode
                        plotEnergy(data,labels,fs);	
                    case 9 % Plot the analog value from one channel
                        reply = input('Choose channel: ');
                        if isnumeric(reply) && ~isempty(reply)
                            plotAnalogdata(data,time,labels,reply)
                        end
                    case 0  % Go back to main menu
                        break;
                    otherwise % Do nothing 
                end
            end
        
        case 3 %% Load segments of time stamps (spike train)
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
                disp('1 - Plot mean firing rate')
                disp('2 - Bargraph with number of spikes')
                disp('3 - Connectivity from spikes firing after a spike within a delta')
                disp('4 - Export to ToolConnect format ') 
                disp('5 - Export to SpiCoDyn format ')
                disp('6 - Import Connectivity matrix from ToolConnect end plot graph')
                disp('7 - Rasterplot ')
                disp('0 - Go back ')
                reply = input('Choose method: ');
                if ~isnumeric(reply) || isempty(reply)
                    reply = -1;
                end
                switch(reply)   
                    case  1 % Generate heatmap
                        plotMFR( timeStamps,labels,(tEnd-tStart) )
                    case  2 % Generate bar graph of spike count
                        barGraph( timeStamps,labels )
                    case  3  % Spike counting
                        while(1)
                            delta = input(['Choose delta [' char(956) 's]: ']);
                            if (~isnumeric(delta)) || isempty(delta) || delta <0
                                fprintf(2,'- Input a positive number\n');
                            else
                                break;
                            end
                        end
                        spikecountConnectivity(timeStamps,labels,delta,(tEnd-tStart),1);
                        clear delta;
                    case  4 % Export to ToolConnect format
                        exportToolConnect(timeStamps,labels,tStart,tEnd,fs,recordingDate)
                    case  5 % Export to SpiCoDyn format
                        exportSpiCoDyn(timeStamps,labels,tStart,tEnd,fs,recordingDate)
                    case  6 % Import Connectivity matrix 
                        [filename, pathname] = uigetfile('*.txt','Select CM file to plot');
                        if isequal(filename,0) || isequal(pathname,0)
                           disp('User pressed cancel')
                        else
                           cm = load([pathname filename]);
                           dirgraph(cm,labels,0,0);
                        end
                    case 7 % Create Rasterplot
                        rasterplot(timeStampData);
                    case 0 % Go back to main menu
                        break
                    otherwise % Do nothing    
                end
            end

        case 0 %% Clear workspace and exit
            clc;
            reply = input('Clear workspace on exit? [Y/n] ','s');
            if isequal(reply,'N') || isequal(reply,'n')
                return
            end
            clear;
            return
        otherwise % Do nothing    
    end
end
    
    



