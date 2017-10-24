function [  ] = exportToolConnect( timeStampData,duration)
%exportToolConnect Export spike train data to ToolConnect format
%   ToolConnect expect the folder structure below. Export the spiketrain to
%   the phase folder corresponding to the spike train recording you want 
%   to export.
%       \Dataset
%           \experiment_1
%               ...
%           \experiment_n
%               \spikes
%                   \phase_1 % First phase of experiment with spikedata 
%                     ...
%                   \phase_m % Last phase of the experiment

    path = uigetdir('Select directory to export the data');
    [~,dirName] = fileparts(path);
    for index = 1:60
        if index == 15
            label = '15';
        else
            label = getLabel(index);
        end
        spikeData = timeStampData.TimeStamps{1,index};
        header = num2str(duration);

        fid=fopen([path '\' dirName '_' label '.txt'],'w');
        fprintf(fid, [ header ' \n']);
        fprintf(fid, '%d  \n', spikeData');
        fclose(fid);
    end
end