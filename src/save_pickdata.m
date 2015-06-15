function savepicks=save_pickdata(fh,savepicks,guiout,i)
% save_pickdata.m
%
% Saves picking info into structure
%
% Last updated 20150615 to fix unknown user problem
% Deborah Kane <deborah.kane@gmail.com>


%% save output from GUI
savepicks = saveguiout(savepicks,guidata(22),i);


%% Add some useful NaN values if not picked
if isempty(savepicks(i).t_P)==1; savepicks(i).t_P = nan; end;
if isempty(savepicks(i).t_nf)==1; savepicks(i).t_nf = nan; end;
if isempty(savepicks(i).t_S)==1; savepicks(i).t_S = nan; end;


% %% save filtered waveforms (must filter again since this information is only in GUI)
% if isempty(savepicks(i).FILTER)==0
%     [f_dH1,f_dH2,f_dZ] = filterandplot(fh,savepicks(i),[(savepicks(i).FILTER*savepicks(i).DELTA) 0.9999],0);
%     savepicks(i).f_dH1 = f_dH1;
%     savepicks(i).f_dH2 = f_dH2;
%     savepicks(i).f_dZ = f_dZ;
% end


%% add structure tag for person picking
%% NEED TO FIGURE OUT WHAT TO DO ABOUT NON-MAC OS
[tempa,tempb] = system('who -m');
if strcmp(tempb(1,1),'d')==1
    savepicks(i).auth = {'Deb'};
else
    savepicks(i).auth = {tempb(1:min(length(tempb),5))};
end


%%% NEED TO FIX TO OUTPUT SYNTHETIC AMPLITUDES FROM WAVEFORMS %%%
%% get synthetic amplitudes from picked phase times
if savepicks(i).FLAG==1
    savepicks(i).t_P = nan;
    savepicks(i).t_nf = nan;
    savepicks(i).t_S = nan;
    savesynamps(:,:,i) = zeros(9,6);
end
