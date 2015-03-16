function [frequencies] = frequencies(n,dt)

%  This function returns the frequencies of an fft given
% the duration of the input time series and the number of
% points.

for k=1:n
  frequencies(k) = (k-1)/(n*dt);
end


