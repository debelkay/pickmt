function [smom,s,tsyn,dt,nt]=mij_TriangleMoRate(M0,f,n) 
% calculate the input moment rate function for mij as an isocelese triangle
% **************the area of this triangle should be 1.0!!!!****************
%
% function [smom,s,tsyn,dt]=mij_TriangleMoRate(M0,f,n) 
% inputs: 
%   M0,    moment in Nm
%   f,     corner frequency in Hz
%   n,     number of times to multiply the number of points in s to get the
%          total number of poins in the synthetic [optional, default value = 150]   
%
% outputs:
%   smom,  moment in Dyne-cm
%   s,     unit seismic moment rate function 
%   dt,    1/sample rate
%   nt,    total number of points in synthetic


    n = 150;            % default value for total number of points in synthetic output
    smom = M0*1e7;      %moment in dyne-cm
    T = 1/f;            %base of the triangle
    dt = T/100;          %1/sample rate -- defined such that the pulse is 100 samples wide
    
    
    tpulse = 0:dt:T;                  %time points in the moment rate function
    h = f*2;                          %height of the unit moment rate function
    dh = 2*h/(length(tpulse)-1);      %heights of points in the rate function
    shalf1 = 0:dh:h; shalf2 = fliplr(shalf1);   
    spulse = [shalf1 shalf2(2:end)];  %pulse shape
    
    tsyn = 0:dt:(T+dt);                                 %time points of the input function
    s = [spulse zeros(1,length(tsyn)-length(spulse))];  %input rate function 
    nt = n*length(s);                                 %the choice of this # must be tied to the corner frequency  
