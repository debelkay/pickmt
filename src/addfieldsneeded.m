% add necessary fields and create output structure
Nsta = length(indata);



savepicks(Nsta).sta = nan;
savepicks(Nsta).t_P = nan;
savepicks(Nsta).t_nf = nan;
savepicks(Nsta).t_S = nan;
savepicks(Nsta).R_P = nan;
savepicks(Nsta).R_nf = nan;
savepicks(Nsta).R_S = nan;
savepicks(Nsta).T_P = nan;
savepicks(Nsta).T_nf = nan;
savepicks(Nsta).T_S = nan;
savepicks(Nsta).V_P = nan;
savepicks(Nsta).V_nf = nan;
savepicks(Nsta).V_S = nan;
savepicks(Nsta).FLAG = [];
savepicks(Nsta).COMMENT = [];
savepicks(Nsta).FILTER = [];
savepicks(Nsta).dumpR = [];
savepicks(Nsta).dumpT = [];
savepicks(Nsta).dumpZ = [];


savepicks = arrayfun(@(s) setfield(s,'M0',M0),savepicks)
savepicks = arrayfun(@(s) setfield(s,'eveid','1234'),savepicks)   %placeholder

[savepicks(1:numel(savepicks)).sta] = indata.sta;
[savepicks(1:numel(savepicks)).t] = indata.t;
[savepicks(1:numel(savepicks)).Mw] = indata.Mw;
[savepicks(1:numel(savepicks)).BAZ] = indata.BAZ;
[savepicks(1:numel(savepicks)).DELTA] = indata.DELTA;
[savepicks(1:numel(savepicks)).dE] = indata.dE;
[savepicks(1:numel(savepicks)).dN] = indata.dN;
[savepicks(1:numel(savepicks)).dZ] = indata.dZ;
[savepicks(1:numel(savepicks)).distXYZ] = indata.distXYZ;







