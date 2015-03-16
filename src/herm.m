function [herm] = herm(x)

%  This function is used to ensure that the Fourier spectrum
% of a time series that is purely real has Hermitian symmetry.
% It is typically used before applying an inverse Fourier transform
% to a theoretical spectrum using an fft. 
%
% From Bill Ellsworth who got it from Greg Beroza

n = length(x);
nyq = n/2;
nyqf = fix(nyq);

if nyqf==nyq      %  An even number of points.
  for k=1:nyq+1
    herm(k) = x(k);
  end
  for k=1:nyq-1
    herm(n-k+1) = conj(x(k+1));
  end

else              % an odd number of point
  nyqplus = nyqf + 1;
  for k=1:nyqplus
    herm(k) = x(k);
  end
  for k=1:nyqplus-1
    herm(n-k+1) = conj(x(k+1));
  end
end
