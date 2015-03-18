function f1=gen_fig1(savepicks)
% Preliminary attempt to create new control menu.
% Note that output of this is automatically stored in variable: 
% guidata(f1)


f1 = figure(1);
guidata(f1)
set(f1,'Position',[1360,500,300,650])
f1x = 3;
f1y = 4;

% Event metadata
%subplot(f1x,f1y,[1 2])
%text(0,0.5,'eventID')
%text(0,0.3,'event Mw')
%text(0,0.1,'Nsta')
%axis off

% Map of event and stations
%subplot(f1x,f1y,[5 6 9 10])
%hold on

% mij solution info
%subplot(f1x,f1y,[3 4])
%text(0,0.5,'space for mij solution')
%axis off

% mij analysis
%subplot(f1x,f1y,7)
%text(0,0.5,'mij error analysis')
%axis off

% beachballs
%subplot(f1x,f1y,8)
%text(0,0.5,'future beachball here')



% dropdown menu
stalist = [savepicks.sta];
%h1 = subplot(f1x,f1y,[11 12]);
%set(h1,'Units','pixels')
h_sta = uicontrol('Style','popupmenu',...
			'String', stalist,...
			'Position', [25,125,150,50],...
			'Callback',{@select_STA})

	function select_STA(h_sta,eventdata)		
		ab = guidata(f1)
		allsta = get(h_sta,'String')
		ab.sta = allsta(get(h_sta,'Value'))
		guidata(f1,ab)
	end

h_USESTA =  uicontrol('Style','pushbutton',...
			'String','Select station','Position',[150,25,50,50],...
			'Callback',{@select_USESTA});

function select_USESTA(varargin)
    uiresume(f1)
    return
end



% finish with stations

h_DONE =  uicontrol('Style','pushbutton',...
			'String','DONE','Position',[225,25,50,50],...
			'Callback',{@select_DONE});

function select_DONE(varargin)
    ab = guidata(f1)
    ab.done = 1;
    guidata(f1,ab)
    uiresume(f1)
    return
end







%uiresume(f1)
%return
	



end