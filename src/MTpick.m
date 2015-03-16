function [outdata]=MTpick(indata)
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





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% SKIP THIS STEP FOR NOW, ADD FEATURE AT LATER DATE.
%% Step 1: Generate Fig 1, allow for selection of station from list. 
%% Other content in Fig 1 is static until figure is updated.

% %%%% Temporary approach: Loop over all stations in structure as in original code.
% %%%% Even more temporary: Use a single station:
% ista = 1;

donewithsta=0;

while donewithsta==0
    % Step 1a,1b: Generate Fig 1, and allow for selection of station from list.
    % Other content in Fig 1 is static until figure is updated.
    f1 = gen_fig1(indata);
    uiwait(f1);


    % Step 1c: 
    % Parse station choice in Fig 1.
    temp = guidata(f1);
    keyboard
    if isfield(temp,'sta')==1
        usesta = temp.sta;
        ista = find(cellfun(@(x) ~isempty(strfind(x,char(usesta))),[indata.sta])==1);
    end
    
    if isfield(temp,'done')==1
        donewithsta = temp.done;
    end
    
    
    if donewithsta==1
        return
    end




    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Step 2: Run GUI for picking input event.
    %% Generate Figure 2: Waveforms

    % Rotate waveforms to radial-transverse directions
    [dH1,dH2,dZ] = rotatetoRTZ(indata(ista).dE,indata(ista).dN,indata(ista).dZ,indata(ista).BAZ);
    indata(ista).dR = dH1;
    indata(ista).dT = dH2;
    indata(ista).dZ = dZ;


    % Create synthetics
    createsynthetics

    % Create fields for later
    Nsta = length(indata);
    indata(Nsta).sta = nan;
    indata(Nsta).t_P = nan;
    indata(Nsta).t_nf = nan;
    indata(Nsta).t_S = nan;
    indata(Nsta).R_P = nan;
    indata(Nsta).R_nf = nan;
    indata(Nsta).R_S = nan;
    indata(Nsta).T_P = nan;
    indata(Nsta).T_nf = nan;
    indata(Nsta).T_S = nan;
    indata(Nsta).V_P = nan;
    indata(Nsta).V_nf = nan;
    indata(Nsta).V_S = nan;
    indata(Nsta).FLAG = [];
    indata(Nsta).COMMENT = [];
    indata(Nsta).FILTER = [];
    indata(Nsta).dumpR = [];
    indata(Nsta).dumpT = [];
    indata(Nsta).dumpZ = [];




    % Plot waveforms and synthetics 
    f2 = figure(2); clf;
    ax(1) = subplot(3,1,1);
    plot(indata(ista).t,indata(ista).dR,'linewidth',2)
    hold on
    plot(tt,uh1)
    ylabel('Radial (m)', 'FontSize', 12)

    ax(2) = subplot(3,1,2);
    plot(indata(ista).t,indata(ista).dT,'linewidth',2)
    hold on
    plot(tt,uh2)
    ylabel('Transverse (m)', 'FontSize', 12)

    ax(3) = subplot(3,1,3);
    plot(indata(ista).t,indata(ista).dZ,'linewidth',2)
    hold on
    plot(tt,uz)
    xlabel('time (seconds)', 'FontSize',12)
    ylabel('Vertical (m)', 'FontSize', 12)

    linkaxes([ax(1) ax(2) ax(3)],'x')




    %% Generate Figure 3 (in fig window 22): Initialize picking menu and pick for station
    pickphases(f2,indata(ista));
    uiwait(22);


    %% Save picks
    outdata = save_pickdata(f2,indata,guidata(22),ista);


end
