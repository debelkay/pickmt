function [rR,rT,rZ] = rotatetoRTZ(inE,inN,inZ,baz)
% ROTATETORTZ rotates data from ENZ to RTZ coordinates using a specified
% source-station *backazimuth* to get the great circle path.
%
% 
% All 3 components are required for this code, although no rotation
% is applied to the vertical component.
%
%
% DKane 20120330

% subaz = deg2rad(180-az);
subaz = deg2rad(baz);


% make sure waveforms are 1xN 
E(1,1:length(inE)) = inE;
N(1,1:length(inN)) = inN;
Z(1,1:length(inZ)) = inZ;

%RTZ = right-hand system, apparently not.
% rotmat = [-sin(subaz) -cos(subaz); cos(subaz) -sin(subaz)];

% RTZ = LHS
rotmat = [-sin(subaz) -cos(subaz); -cos(subaz) sin(subaz)];
% srot = rotmat*[inE'; inN'];
srot = rotmat*[E; N];

rR = srot(1,:);
rT = srot(2,:);
rZ = Z;



