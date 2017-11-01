function [ y ] = bandpassFilter( n,w1, w2,x )
%highpassFilter Filter signal with nth-order Butterworth bandpass filter
%   Input order n, lower cutoff frequency w1, and higher w2, 
%   with signal x : [num electrodes x timeseries]
    fs = 10000; % Sampling rate
    [b,a]=butter(n,[w1 w2]/(fs/2),'bandpass');
    y = zeros(size(x));
    for i=1:size(x,1)
        y(i,:) = filter(b,a,x(i,:));
    end
end