% createsynthetics.m
% Creates synthetic waveforms given event/station metadata
% 
% DKane 20150316


% Synmom code is written for source at origin, station at XYZ.
% Need x,y,z distances in kilometers, and R in meters.
% Note that depth is negative in this setup.
xx = savepicks(ista).distXYZ(1);
yy = savepicks(ista).distXYZ(2);
zz = savepicks(ista).distXYZ(3);
R = sqrt(xx^2 + yy^2 + zz^2)*1000;  % m for R



% calculate the input moment rate function as an isosceles triangle
% with duration chosen based on magnitude (input f0):
[smom,s,tsyn,dt,nt] = mij_TriangleMoRate(M0,f0);

ntmult = 10*nt;     % extend multiplier for number of points


% compute attenuation operator in advance:
[Qop,t_Qop,arrival_index] = azimi_msb(dt/10,Q,R/1000,bet);
qop = real(Qop(arrival_index:end))*dt/10;        
tqop = t_Qop(arrival_index:end)-t_Qop(arrival_index);



% create empty space for saving synthetics
r = zeros(1,6);     % source-sta distance
afsx = zeros(1,6);  % radiation pattern, x-axis
afsy = zeros(1,6);  % radiation pattern, y-axis
uhN_syn = zeros(6,ntmult+1);    % 6 synthetics, N component
uhE_syn = zeros(6,ntmult+1);    % 6 synthetics, E component
uZ_syn = zeros(6,ntmult+1);     % 6 synthetics, Z (Up) component
rcm_uh1 = []; rcm_uh2 = []; rcm_uz = [];
r_uh1 = []; r_uh2 = []; r_uz = [];
uh1 = []; uh2 = []; uz = [];


% create synthetic for each of the possible 6 unit moment tensor
% components:
%   (Note that output of synmom is NEU coordinate system because we swapped
%   station and source locations on SWD input.)

for k = 1:6
    mij = zeros(1,6);
    mij(k) = 1;
    
    [uhN_syn(k,:),uhE_syn(k,:),uZ_syn(k,:),r(k),afsx(k),afsy(k)] = synmom_comments(xx,yy,zz,mij,dt,ntmult,s,smom,alph,bet,rho);
    tt = 0:dt:length(uZ_syn)*dt-dt;
    
    % rotate to RTZ:
    [rcm_uh1,rcm_uh2,rcm_uz] = rotatetoRTZ(uhE_syn(k,:),uhN_syn(k,:),uZ_syn(k,:),savepicks(ista).BAZ);
    
    % convert from cm (output from synmom) to meters to match data:
    r_uh1 = rcm_uh1/100;
    r_uh2 = rcm_uh2/100;
    r_uz = rcm_uz/100;
    
    % apply attenuation operator:
    uh1(k,:) = conv(qop,r_uh1);
    uh2(k,:) = conv(qop,r_uh2);
    uz(k,:) = conv(qop,r_uz);
end


% cut synthetics
uh1 = uh1(:,1:length(tt));
uh2 = uh2(:,1:length(tt));
uz = uz(:,1:length(tt));
