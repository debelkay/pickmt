function [Qop,t_Qop,arrival_index]=azimi_msb(dt,Q,R,Vref)
%	Matlab macro from Bill Ellsworth from Greg Beroza for Q operator
%
%   Calculate Impulse Response for the Azimi Operator.
% 
%   Inputs:
%   dt = sampling interval
%   Q = quality factor
%   R = propagation distance in km
%   Vref = reference velocity (should be p-wave for p-waves, or s-wave
%           velocity for s-waves [km/s]
%
%   Output:
%   Qop = Q opperator
%   t_Qop = time for help with plotting
%   arrival_time = approximate arrival time 
%
%   Calls the functions:  frequencies, herm
%   Editted by Margaret Boettcher on July 27, 2009

fref = 2/dt;
nfft = 2^(ceil(log2(R/Vref/dt)));  % # points in fft

qfac = 1./(pi*Q);
f = frequencies(nfft,dt);
w = 2*pi*f;

atten(1) = 1.;
for k=2:nfft
    v(k) = Vref*(1.0 + (qfac*log(f(k)/fref)));
    atten(k) = exp(-w(k)*R/(2*v(k)*Q))*exp(-w(k)*i*(R/v(k)));
end

z1 = herm(atten);
qop = ifft(z1);
Qop = qop/dt;         %Divide qop by dt to normalize area

for k=1:nfft
    t_Qop(k) = (k-1)*dt;
end         

arrival_time = R/Vref;
d = t_Qop-arrival_time;
arrival_index = find(min(abs(d))==abs(d));


% figure(20); clf;
% plot(t_Qop,Qop)
% xlabel('time')
% ylabel('Qopperator')
