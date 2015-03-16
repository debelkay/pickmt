% pf_pick.m
% 
% Parameter file for picking GUI
%


% Parameter values in SI:
alph = 5900;	% P-wave speed (m/s)
bet = 3600;	% S-wave speed (m/s)
rho = 2640;	% density (km/m^3)
Q = 200;	% attenuation Q-factor
sigm = 3e6;	% assumed stress drop for estimating corner frequency (Pa)

% Selections:
Qapp = 1;	% 1 = apply Azimi Q operator, 2 = do not apply (if attenuation already corrected)


% Use cataloged Mw to determine expected source duration.
% (Can manually change f0 here if needed).
M0 = 10 .^ (1.5 * indata(1).Mw + 9.05);		% in N-m
r = ((7/16) * (M0/sigm)) ^ (1/3);		% radius of circular crack in m
f0 = 0.32 * bet / r;				% corner frequency under assumptions.



