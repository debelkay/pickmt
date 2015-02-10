function []=MTpick(indata)
%% MTpick is a Matlab function for initializing a GUI to pick phase amplitudes
% for moment tensor analysis.
%
% This function calls script pf_pick.m to allow changes to input parameters.
%
% Input:
% indata = Matlab structure for a single event with space to save picks, etc.
%		(has length Nsta)
%
%
% Last updated 20150209
% Deborah Kane <deborah.kane@gmail.com>



% Call script for parameter file
pf_pick


%%%% SKIP THIS STEP FOR NOW, ADD FEATURE AT LATER DATE.
%% Step 1: Generate Fig 1, allow for selection of station from list. 
%% Other content in Fig 1 is static until figure is updated.



%%%% Temporary approach: Loop over all stations in structure as in original code.
%%%% Even more temporary: Use a single station:
ista = 1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Step 2: Run GUI for picking input event.
%% Generate Figure 2: Waveforms
f2 = figure(2);
ax(1) = subplot(3,1,1);
filterandplot(f2,indata(ista));


%% Generate Figure 3 (in fig window 22): Initialize picking menu and pick for station
pickphases(f2,indata(sta));
uiwait(22);


%% Save picks
indata = save_pickdata(f2,indata,guidata(22),ista);



