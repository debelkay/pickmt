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
    addfieldsneeded




    % Plot waveforms and synthetics
    plotforpicking
    




    %% Generate Figure 3 (in fig window 22): Initialize picking menu and pick for station
    pickphases(f2,indata(ista));
    uiwait(22);


    %% Save picks
    outdata = save_pickdata(f2,indata,guidata(22),ista);


end
