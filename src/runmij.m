function out=runmij(picks,conflim)
% function [mij,mij_zerotrace,deltaV,sVolRatio,mw_dev,mw_full,Nsta,Npicks,uu,ftest,varmij]=runmij(picks,conflim)
% runmij.m -- cleaned up
% script to load stuff to compute moment tensor after saving as structures

% clear, then load something first - just a structure of picks

counter = 0;
savecount = [];
tempM0 = [];
tempMw = [];
numpicks = 0;


for i=1:length(picks)

    if isempty(tempM0)==1
        if isempty(picks(i).M0)==0
            tempM0 = picks(i).M0;
            tempMw = picks(i).Mw;
            tempeveid = picks(i).eveid;
        end
    end
    
    
    %% NOTE THAT STATION TAU091 IS EXCLUDED HERE:
%     if strcmp(picks(i).sta,'tau091')==1
%         continue
%     end

    % skip if no picks
    if isempty(picks(i).sta)
        continue

    % skip if no pick for synthetic P peak time
    elseif isnan(picks(i).t_P)==1 & isnan(picks(i).t_S)==1
        disp(['skipping station ',char(picks(i).sta)]);
        continue

    % skip if no pick for synthetic P peak time
    elseif isempty(picks(i).t_P) & isempty(picks(i).t_S)
        disp(['skipping station ',char(picks(i).sta)]);
        continue
        
    % otherwise, grab pick data and compute synthetic amplitudes based on
    % times
    else
        counter = counter+1;
        savecount = [savecount; i];
        savesynamps(:,:,counter) = newgetsynamps(picks(i).syn_t,picks(i).syn_uh1,picks(i).syn_uh2,picks(i).syn_uz,picks(i).t_P,picks(i).t_nf,picks(i).t_S);
        disp(['station = ',char(picks(i).sta),', ista = ',num2str(i)]);
    end
end

% keyboard

pickscells = squeeze(struct2cell(picks(savecount)));
pickssta = pickscells(1,:);
pickscells = pickscells(2:13,:);


findempty = cellfun(@isempty,pickscells);
pickscells(findempty) = {nan};
vpicks = cell2mat(pickscells);

uu = vpicks;
AA = savesynamps;

% added to check for not enough data
uu_sizetest = uu(4:end,:);
uu_sizetestval = sum(abs(isnan(uu_sizetest)-1),1);

if min(size(uu))<2 || length(find(uu_sizetestval>0))<2
    disp('Not enough data to use!')
    mij = nan(1,6);
    mij_zerotrace = nan(1,6);
    deltaV = nan(1,3);
    sVolRatio = nan(1,1000);
    mw_dev = nan;
    mw_full = nan;
    ftest = nan;
    varmij = nan;
    
else
    [mij,mij_zerotrace,deltaV,sVolRatio,mw_dev,mw_full,ftest,varmij] = compute_mij(uu,AA,tempM0,conflim);
    % [origdeltaV,sVolRatio] = resampMij(uu,AA,picks(1).M0,1000);
end


% figure out number of data picks going in:
Nsta = size(uu,2);
tempu = uu(4:end,:);
tempunantest = abs(isnan(tempu)-1);
Npicks = sum(tempunantest(:));


% reformat stuff to save into a structure:
out.mij = mij;
out.mij_zerotrace = mij_zerotrace;
out.deltaV = deltaV;
out.sVolRatio = sVolRatio;
out.mw_dev = mw_dev;
out.mw_full = mw_full;
out.Nsta = Nsta;
out.Npicks = Npicks;
out.uu = uu;
out.ftest = ftest;
out.varmij = varmij;


end

