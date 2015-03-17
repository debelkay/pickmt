function amps = getsynamps(tt,uh1,uh2,uz,pt,nft,st)
%keyboard
usetime = [pt; nft; st];
if length(usetime)~=3
    disp('error - must select all times')
end


% keyboard
% amps = [];
amps = nan(9,6);

for ii=1:3  %per pick type
    bt = usetime(ii);

    if isnan(bt)==1
        allsyn = nan(3,6);
    else        
        synH1 = uh1(:,logical(abs(tt-bt)==min(abs(tt-bt))))';
        synH2 = uh2(:,logical(abs(tt-bt)==min(abs(tt-bt))))';
        synZ =  uz(:,logical(abs(tt-bt)==min(abs(tt-bt))))';

%         allsyn = [synH1; synH2; synZ];
%         amps(3*(ii-1)+1,:) = synH1;
%         amps(3*(ii-1)+2,:) = synH2;
%         amps(3*(ii-1)+3,:) = synZ;

        startii = ii;
        amps(startii,:) = synH1;
        amps(startii+3,:) = synH2;
        amps(startii+6,:) = synZ;
    end
    
%     amps = [amps; allsyn];
    
    
    
end
    