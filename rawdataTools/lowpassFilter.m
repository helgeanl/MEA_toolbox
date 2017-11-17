function y = lowpassFilter(n,wc,fs,x)
%lowpassFilter Filter signal with nth-order Butterworth lowpass filter
%   y  = lowpassFilter(n,wc,fs,x) filters the data in column vector x with  
%   a lowpass butterworth filter of order n.
%
%   Y = lowpassFilter(n,wc,fs,X) filters the data of each column in 
%   matrix X with a lowpass butterworth filter of order n. 
%
%   Both cases use a cutoff frequency wc with a sampling rate fs.

    [b,a]=butter(n,wc/(fs/2),'low');
    y = zeros(size(x));
    for i=1:size(x,2)
        y(:,i) = filter(b,a,x(:,i));
    end
end