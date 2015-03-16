%make_pickstructure
%
% Creates space.
%
% DKane 20130620 verification update.

Nsta = length(sta);

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

