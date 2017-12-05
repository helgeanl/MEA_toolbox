function exportSpiCoDyn( timeStamps,labels,tStart,tEnd,fs,experiment)
%exportSpiCoDyn Export spike train data to SpiCoDyn format
%   exportSpiCoDyn( timeStamps,labels,tStart,tEnd,fs,experiment) will export the spike 
%   timestamps to one file for each electrode channel, with a header 
%   containing the number of samples (nSamples) in the recording and 
%   a '0' as an end marker. 
%
%   timeStamps is a cell array with 60 elements containing the spike data
%   for each channel.
%
%   ToolConnect expect the folder structure below. Export the spiketrain to
%   the phase folder corresponding to the spike train recording you want 
%   to export. One phase of the experiment represent one recording.
%       \Dataset
%           \experiment_1
%               ...
%           \experiment_n
%               \spikes
%                   \phase_1 % First phase of experiment with spikedata 
%                     ...
%                   \phase_m % Last phase of the experiment
%
  

    path = uigetdir('Select directory to export the data');
    if isequal(path,0)
        disp('User pressed cancel')
        return;
    end

    mkdir(path,experiment);
    mkdir([path '/' experiment],'spikes');
    mkdir([path '/' experiment '/spikes'],[num2str(round(tStart)) '-' num2str(round(tEnd))]);
    datapath = [path '/' experiment '/spikes/' num2str(tStart) '-' num2str(tEnd)];

    for index = 1:length(timeStamps)
        label = getLabel(index,labels);
        if isequal(label, 'Ref')
            label = '15';
        end
        % Multichannel Systems record the timestamps in microseconds,
        % with a tick of 100 us per sample with a sampling frequency of 10 000 Hz,
        % while SpiCoDyn expects a tick size of 1. Multiplying with fs 
        % and dividing with one million convert the tick size to one.
        spikeData = timeStamps{index}.*(fs/1e6)-tStart*fs;
        numSamples = num2str((tEnd-tStart)*fs);
        numSpikes = num2str(length(spikeData));
        fid=fopen([datapath '\' experiment '_' label '.txt'],'w');
        fprintf(fid, [ numSamples ' \n']);
         fprintf(fid, [ numSpikes ' \n']);
        fprintf(fid, '%d  \n', spikeData');
        fclose(fid);
    end
end