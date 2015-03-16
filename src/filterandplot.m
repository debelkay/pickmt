function [dH1,dH2,dZ] = filterandplot(waveformdata,freqbandfrac,replotcode)

xlimit = [0 1.5];
keyboard

if nargin==1
	dH1 = waveformdata.dH1;
	dH2 = waveformdata.dH2;
	dZ = waveformdata.dZ;
    replotcode=1;
end

DELTA = waveformdata.DELTA;
t = waveformdata.t;
tt = waveformdata.syn_t;
uh1 = waveformdata.syn_uh1;
uh2 = waveformdata.syn_uh2;
uz = waveformdata.syn_uz;
vH1 = waveformdata.vH1;
vH2 = waveformdata.vH2;
vZ = waveformdata.vZ;



if nargin>=2 & length(freqbandfrac)==2
    
%     keyboard
    
% FILTER OVER LP/HP/BP
	[b,a] = butter(2,freqbandfrac);     % use n=2 to better preserve impulse response!
%     [b,a] = butter(4,freqbandfrac);
%     [b,a] = butter(4,[freqband(1)/(1/DELTA) freqband(2)/(1/DELTA)]);
	tempdH1 = cumtrapz(filtfilt(b,a,vH1))*DELTA;
	tempdH2 = cumtrapz(filtfilt(b,a,vH2))*DELTA;
	tempdZ = cumtrapz(filtfilt(b,a,vZ))*DELTA;
    
    % REMOVE LINEAR TREND
    lindH1 = polyfit(t,tempdH1,1);
    lindH2 = polyfit(t,tempdH2,1);
    lindZ = polyfit(t,tempdZ,1);
    
    dH1 = tempdH1 - polyval(lindH1,t);
    dH2 = tempdH2 - polyval(lindH2,t);
    dZ = tempdZ - polyval(lindZ,t);
% 
% dH1 = tempdH1;
% dH2 = tempdH2;
% dZ = tempdZ;
    
%     keyboard
    % REMOVE PRE-P ARRIVAL FOR 0.005 S DURATION - CHECK THIS
    presampN = round(0.005/waveformdata.DELTA);
    flatH1 = mean(dH1(1:presampN));
    flatH2 = mean(dH2(1:presampN));
    flatZ = mean(dZ(1:presampN));
    
    dH1 = dH1 - flatH1;
    dH2 = dH2 - flatH2;
    dZ = dZ - flatZ;
    
    
    
    
	waveformdata.title = [waveformdata.title,'	filter [',num2str(freqbandfrac(1)),', ',num2str(freqbandfrac(2)),']'];
end



if replotcode==1

    %--------Plot data for making measurments--------
%    figure(1); clf
    ax(1)=subplot(311)
    plot(t,dH1,'linewidth',2)
    hold on
    plot(tt,uh1)
    xlabel('time (seconds)','FontSize',12);  
%    if strcmp(rotdir,'rtu') 
        ylabel('Radial (m)','FontSize',12)
%    elseif strcmp(rotdir,'enu')
%        ylabel('East (m)')
%    end
    grid; set(gca,'xlim',xlimit);
%    h_title = title([char(eveid),'    Mw = ',num2str(Mw),'    ',char(sta(i)),'    ', num2str(R),' m'])
    h_title = title([waveformdata.title])
    set(h_title,'FontSize',14)
    yl1 = get(gca,'ylim');
    set(gca,'FontSize',12)

    ax(2)=subplot(312)
    plot(tt,uh2)
    hold on
    plot(t,dH2,'linewidth',2)
    xlabel('time (seconds)','FontSize',12);  
%    if strcmp(rotdir,'rtu') 
        ylabel('Transverse (m)','FontSize',12)
%    elseif strcmp(rotdir,'enu')
%        ylabel('North (m)')
%    end
    grid; set(gca,'xlim',xlimit)  
    yl2 = get(gca,'ylim');
    set(gca,'FontSize',12)

    ax(3)=subplot(313)
    plot(tt,uz)
    hold on
    plot(t,dZ,'linewidth',2)
    xlabel('time (seconds)','FontSize',12);  ylabel('Vertical (m)','FontSize',12);
    grid; set(gca,'xlim',xlimit)  
    yl3= get(gca,'ylim');        
    set(gca,'FontSize',12)

    
    linkaxes([ax(3) ax(2) ax(1)],'x') 

end