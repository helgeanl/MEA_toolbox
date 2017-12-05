function plotAnalogdata( data,time,labels,chan )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    figure
    chanIndex = getLabelIndex(chan,labels);
    plot(time,data(:,chanIndex).*1e-6);
    if isnumeric(chan)
        legend(num2str(chan'))
    else
        legend(chan)
    end
    
    xlim([time(1) time(end)])
    xlabel('Time [s]')
    ylabel('Voltage [\muV]')
end

