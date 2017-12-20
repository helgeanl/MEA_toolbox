function plotSpikecutouts( data,chan,fs)
%plotSpikecutouts Plot the spike cutouts from channel CHAN
%   plotSpikecutouts( DATA,CHAN,Fs )

    figure
    time = (0:(size(data,1)-1))/fs*1e3;
    if ~isempty(data)
        plot(time, data);
        hold on
        plot(time,mean(data,2),'-k','LineWidth',2);
    else
        plot(time,zeros(1,length(time)) );
    end
    
    if isnumeric(chan)
        legend(num2str(chan'))
    else
        legend(chan)
    end
    xlim([time(1) time(end)])
    xlabel('Time [ms]')
    ylabel('Voltage [\muV]')
end