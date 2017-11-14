function exportToolConnect( timeStamps,tStart,tEnd,fs)
%exportToolConnect Export spike train data to ToolConnect format
%   exportToolConnect(timeStamps, nSamples) will export the spike 
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
    [~,dirName] = fileparts(path);
     
    for index = 1:length(timeStamps)
        % Replace channel label 'Ref' with '15'
        if index == 15
            label = '15';
        else
            label = getLabel(index);
        end
        % Multichannel Systems record the timestamps in microseconds,
        % with a sampling every 0.1ms, so devide by 100 to get a 
        % compatible format with ToolConnect
        spikeData = timeStamps{index}./100-tStart*fs;
        header = num2str((tEnd-tStart)*fs);

        fid=fopen([path '\' dirName '_' label '.txt'],'w');
        fprintf(fid, [ header ' \n']);
        fprintf(fid, '%d  \n', spikeData');
        fclose(fid);
    end
end