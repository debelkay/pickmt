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

% Create fields for later
addfieldsneeded




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Step 1: Generate Fig 1, allow for selection of station from list. 
%% Other content in Fig 1 is static until figure is updated.

% %%%% Temporary approach: Loop over all stations in structure as in original code.
% %%%% Even more temporary: Use a single station:
% ista = 1;

donewithsta=0;
numstapicked=0;



while donewithsta==0
    % Step 1a,1b: Generate Fig 1, and allow for selection of station from list.
    % Other content in Fig 1 is static until figure is updated.
    f1 = gen_fig1(savepicks);
    uiwait(f1);


    % Step 1c: 
    % Parse station choice in Fig 1.
    temp = guidata(f1);
%     keyboard
    if isfield(temp,'sta')==1
        usesta = temp.sta;
        ista = find(cellfun(@(x) ~isempty(strfind(x,char(usesta))),[savepicks.sta])==1);
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
    [dH1,dH2,dZ] = rotatetoRTZ(savepicks(ista).dE,savepicks(ista).dN,savepicks(ista).dZ,savepicks(ista).BAZ);
    savepicks(ista).dR = dH1;
    savepicks(ista).dT = dH2;
    savepicks(ista).dZ = dZ;


    % Create synthetics
    createsynthetics
    savesynthetics
    



    % Plot waveforms and synthetics
    plotforpicking
    




    %% Generate Figure 3 (in fig window 22): Initialize picking menu and pick for station
    pickphases(f2,savepicks(ista));
    uiwait(22);
    numstapicked = numstapicked + 1;


    %% Save picks
    savepicks = save_pickdata(f2,savepicks,guidata(22),ista);


    
    %% Compute moment tensor if at least 3 stations have picks
    
    if numstapicked >= 3
        keyboard
        conflim = 0.90
        [mij,mij_zerotrace,deltaV,sVolRatio,mw_dev,mw_full,Nsta,Npicks,uu,ftest,stemij]=runmij(savepicks,conflim);
    end
    

    
    
end
