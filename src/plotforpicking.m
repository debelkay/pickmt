% plotforpicking.m


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
