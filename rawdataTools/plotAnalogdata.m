function plotAnalogdata( data,time,labels,chan )
%plotAnalogdata Plot the analog value from one channel
%   plotAnalogdata( data,time,labels,chan )
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

