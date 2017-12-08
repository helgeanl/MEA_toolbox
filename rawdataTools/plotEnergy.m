function ENERGY = plotEnergy(data,labels,fs)
%plotEnergy Plot the total energy from each electrode
%   ENERGY = plotEnergy(DATA,LABELS,FS) returns a vector containing the
%   energy in each electrode, sorted from lowest to highest electrode. 
%   
%   DATA is a NxM matrix where N is the timeseries and M electrodes. 
%   LABELS is a cell array containing all the string labels in the
%   recording. FS is the sampling rate.
%
%   The energy for each electrode is plotted on the 60MEA layout.
    
    % Replace channel label 'Ref' with '15'
    refIndex = find(contains(labels,'Ref'));
    if refIndex ~= 0 
        labels{refIndex} = '15'; 
    end
    [labels,s] = sort(labels);
    
    data = data(:,s);
    for i=1:length(labels)
        ENERGY(i) = sum(periodogram(data(:,i),[],[],fs,'power'));
    end
    cfg = [];
    cfg.title = 'Energy';
    plot_layout(ENERGY,labels,cfg);
    
   
end


