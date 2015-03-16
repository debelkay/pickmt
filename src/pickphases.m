function pickphases(fh,wfdata)
%% PICKPHASES is a Matlab function for GUI control in phase picking.
%
% Last updated 20150209
% Deborah Kane <deborah.kane@gmail.com>




% Close old figures and generate GUI figure window
fw = 22;
f = figure(fw);
guidata(fw,wfdata)
set(f,'Visible','off','Position',[1360,500,300,650])
set(f,'Name','DATA PICKER')


% Construct with all parts:
h_t_P =     uicontrol('Style','pushbutton','String','time_P','Position',[25,550,50,50],'Callback',{@select_tP_Callback});
h_t_nf =    uicontrol('Style','pushbutton','String','time_nf','Position',[125,550,50,50],'Callback',{@select_tnf_Callback});
h_t_S =     uicontrol('Style','pushbutton','String','time_S','Position',[225,550,50,50],'Callback',{@select_tS_Callback});

h_R_P =     uicontrol('Style','pushbutton','String','R_P','Position',[25,425,50,50],'Callback',{@select_RP_Callback});
h_R_nf =    uicontrol('Style','pushbutton','String','R_nf','Position',[125,425,50,50],'Callback',{@select_Rnf_Callback});
h_R_S =     uicontrol('Style','pushbutton','String','R_S','Position',[225,425,50,50],'Callback',{@select_RS_Callback});

h_T_P =     uicontrol('Style','pushbutton','String','T_P','Position',[25,325,50,50],'Callback',{@select_TP_Callback});
h_T_nf =    uicontrol('Style','pushbutton','String','T_nf','Position',[125,325,50,50],'Callback',{@select_Tnf_Callback});
h_T_S =     uicontrol('Style','pushbutton','String','T_S','Position',[225,325,50,50],'Callback',{@select_TS_Callback});

h_V_P =     uicontrol('Style','pushbutton','String','V_P','Position',[25,225,50,50],'Callback',{@select_VP_Callback});
h_V_nf =    uicontrol('Style','pushbutton','String','V_nf','Position',[125,225,50,50],'Callback',{@select_Vnf_Callback});
h_V_S =     uicontrol('Style','pushbutton','String','V_S','Position',[225,225,50,50],'Callback',{@select_VS_Callback});

h_DONE =    uicontrol('Style','pushbutton','String','DONE','Position',[225,25,50,50],'Callback',{@select_DONE});
% h_FLAG =    uicontrol('Style','checkbox','String','BAD DATA','Position',[25,25,100,50],'Callback',{@select_FLAG});
h_dumpR =   uicontrol('Style','checkbox','String','R','Position',[25 25 50 50],'Callback',{@select_dumpR});
h_dumpT =   uicontrol('Style','checkbox','String','T','Position',[75 25 50 50],'Callback',{@select_dumpT});
h_dumpZ =   uicontrol('Style','checkbox','String','Z','Position',[125 25 50 50],'Callback',{@select_dumpZ});
h_dumplabel = uicontrol('Style','text','String','Bad trace:','Position',[25 70 75 25])


% % h_FILTER =  uicontrol('Style','popupmenu','String',{'no filter','HP 20Hz','HP 0.01'},'Position',[25,125,150,50],'Callback',{@select_FILTER});
% h_FILTER =  uicontrol('Style','popupmenu','String',{'no filter','HP 0.01Hz','HP 0.1Hz','HP 1Hz','HP 5Hz','HP 10Hz','HP 60Hz','HP 100Hz','LP 40Hz','LP 100Hz','BP 10-100Hz'},'Position',[25,125,150,50],'Callback',{@select_FILTER});
h_CLEAR = uicontrol('Style','popupmenu','String',{'Clear:','time_P','time_nf','time_S','R_P','R_nf','R_S','T_P','T_nf','T_S','V_P','V_nf','V_S'},'Position',[25 75 150 50],'Callback',{@select_CLEAR});
h_QUAL = uicontrol('Style','popupmenu','String',{'Qual','A','B','C'},'Position',[200 150 80 20],'Callback',{@select_QUAL});

h_label1 =  uicontrol('Style','text','String','Pick on synthetics:','Position',[25,600,250,20],'FontSize',14)
h_label2 =  uicontrol('Style','text','String','Pick on data:','Position',[25,475,250,20],'FontSize',14)

h_COMMENT = uicontrol('Style','pushbutton','String','COMMENT','Position',[200,100,80,20],'Callback',{@select_COMMENT});


    function select_tP_Callback(varargin)
        figure(fh); 
        [keep_tP,y] = ginput(1);        
        mydata = guidata(fw);
        mydata.t_P = keep_tP;
        guidata(fw,mydata)
        subplot(311); hold on
        pt_P = plot(keep_tP,0,'ko','MarkerSize',8,'MarkerFaceColor','k');
	disp('PICKED: time_P')
    end


    function select_tnf_Callback(varargin)
        figure(fh); 
        [keep_tnf,y] = ginput(1);
        mydata = guidata(fw);
        mydata.t_nf = keep_tnf;
        guidata(fw,mydata)
        subplot(311); hold on
        pt_nf = plot(keep_tnf,0,'kx','MarkerSize',8,'MarkerFaceColor','k');
	disp('PICKED: time_nf')
    end


    function select_tS_Callback(varargin)
        figure(fh); 
        [keep_tS,y] = ginput(1);
        mydata = guidata(fw);
        mydata.t_S = keep_tS;
        guidata(fw,mydata)
        subplot(311); hold on
        pt_S = plot(keep_tS,0,'kx','MarkerSize',8,'MarkerFaceColor','k');
	disp('PICKED: time_S')
    end


    function select_RP_Callback(varargin)
        figure(fh); 
        [timeRP,RP] = ginput(1);
        mydata = guidata(fw);
        mydata.R_P = RP;
        mydata.timeRP = timeRP;
        guidata(fw,mydata)
        subplot(311); hold on
        pRP = plot(timeRP,RP,'ro','MarkerFaceColor','r');
	disp('PICKED: R_P')
    end


    function select_Rnf_Callback(varargin)
        figure(fh); 
        [x,Rnf] = ginput(1);
        mydata = guidata(fw);
        mydata.R_nf = Rnf;
        guidata(fw,mydata)
        subplot(311); hold on
        pRnf = plot(x,Rnf,'ro','MarkerFaceColor','r');
	disp('PICKED: R_nf')
    end


    function select_RS_Callback(varargin)
        figure(fh); 
        [timeRS,RS] = ginput(1);
        mydata = guidata(fw);
        mydata.R_S = RS;
        mydata.timeRS = timeRS;
        guidata(fw,mydata)
        subplot(311); hold on
        pRS = plot(timeRS,RS,'ro','MarkerFaceColor','r');
	disp('PICKED: R_S')
    end


    function select_TP_Callback(varargin)
        figure(fh); 
        [timeTP,TP] = ginput(1);
        mydata = guidata(fw);
        mydata.T_P = TP;
        mydata.timeTP = timeTP;
        guidata(fw,mydata)
        subplot(312); hold on
        pTP = plot(timeTP,TP,'ro','MarkerFaceColor','r');
	disp('PICKED: T_P')
    end


    function select_Tnf_Callback(varargin)
        figure(fh)
        [x,Tnf] = ginput(1);
        mydata = guidata(fw);
        mydata.T_nf = Tnf;
        guidata(fw,mydata)
        subplot(312); hold on
        pTnf = plot(x,Tnf,'ro','MarkerFaceColor','r');
	disp('PICKED: T_nf')
    end


    function select_TS_Callback(varargin)
        figure(fh)
        [timeTS,TS] = ginput(1);
        mydata = guidata(fw);
        mydata.T_S = TS;
        mydata.timeTS = timeTS;
        guidata(fw,mydata)
        subplot(312); hold on
        pTS = plot(timeTS,TS,'ro','MarkerFaceColor','r');
	disp('PICKED: T_S')
    end


    function select_VP_Callback(varargin)
        figure(fh)
        [timeVP,VP] = ginput(1);
        mydata = guidata(fw);
        mydata.V_P = VP;
        mydata.timeVP = timeVP;
        guidata(fw,mydata)
        subplot(313); hold on
        pVP = plot(timeVP,VP,'ro','MarkerFaceColor','r');
	disp('PICKED: V_P')
    end

    
    function select_Vnf_Callback(varargin)
        figure(fh)
        [x,Vnf] = ginput(1);
        mydata = guidata(fw);
        mydata.V_nf = Vnf;
        guidata(fw,mydata)
        subplot(313); hold on
        pVnf = plot(x,Vnf,'ro','MarkerFaceColor','r');
	disp('PICKED: V_nf')
    end


    function select_VS_Callback(varargin)
        figure(fh)
        [timeVS,VS] = ginput(1);
        mydata = guidata(fw);
        mydata.V_S = VS;
        mydata.timeVS = timeVS;
        guidata(fw,mydata)
        subplot(313); hold on
        pVS = plot(timeVS,VS,'ro','MarkerFaceColor','r');
	disp('PICKED: V_S')
    end

%     function select_FLAG(h_FLAG,eventdata)
%         mydata = guidata(fw);
%         if (get(h_FLAG,'Value') == get(h_FLAG,'Max'))
%             mydata.FLAG=1;
%         else
%             mydata.FLAG=0;
%         end
%         guidata(fw,mydata)
%     end

    function select_dumpR(h_dumpR,eventdata)
        mydata = guidata(fw);
        if (get(h_dumpR,'Value') == get(h_dumpR,'Max'))
            mydata.dumpR=1;
        else
            mydata.dumpR=0;
        end
        guidata(fw,mydata)
    end

    function select_dumpT(h_dumpT,eventdata)
        mydata = guidata(fw);
        if (get(h_dumpT,'Value') == get(h_dumpT,'Max'))
            mydata.dumpT=1;
        else
            mydata.dumpT=0;
        end
        guidata(fw,mydata)
    end

    function select_dumpZ(h_dumpZ,eventdata)
        mydata = guidata(fw);
        if (get(h_dumpZ,'Value') == get(h_dumpZ,'Max'))
            mydata.dumpZ=1;
        else
            mydata.dumpZ=0;
        end
        guidata(fw,mydata)
    end



%     function select_FILTER(h_FILTER,eventdata)
%         str = get(h_FILTER,'String');
%         val = get(h_FILTER,'Value');
%         
%         switch str{val};
%             case 'no filter'
%                 figure(fh); clf
%                 filterandplot(fh,wfdata);
%                 mydata = guidata(fw); mydata.FILTER = []; guidata(fw,mydata)
%             case 'HP 0.01Hz'
%                 figure(fh); clf
%                 filterandplot(fh,wfdata,[0.01/(1/wfdata.DELTA) 0.9999],1);
%                 mydata = guidata(fw); mydata.FILTER=0.01; guidata(fw,mydata)
%                 
%             case 'HP 0.1Hz'
%                 figure(fh); clf
%                 filterandplot(fh,wfdata,[0.1/(1/wfdata.DELTA) 0.9999],1);
%                 mydata = guidata(fw); mydata.FILTER=0.1; guidata(fw,mydata)
% 
%             case 'HP 1Hz'
%                 figure(fh); clf
%                 filterandplot(fh,wfdata,[1/(1/wfdata.DELTA) 0.9999],1);
%                 mydata = guidata(fw); mydata.FILTER=1; guidata(fw,mydata)
%                 
%             case 'HP 5Hz'
%                 figure(fh); clf
%                 filterandplot(fh,wfdata,[5/(1/wfdata.DELTA) 0.9999],1);
%                 mydata = guidata(fw); mydata.FILTER=5; guidata(fw,mydata)
%                 
%             case 'HP 10Hz'
%                 figure(fh); clf
%                 filterandplot(fh,wfdata,[10/(1/wfdata.DELTA) 0.9999],1);
%                 mydata = guidata(fw); mydata.FILTER=10; guidata(fw,mydata)
%             
%             case 'HP 60Hz'
%                 figure(fh); clf
%                 filterandplot(fh,wfdata,[60/(1/wfdata.DELTA) 0.9999],1);
%                 mydata = guidata(fw); mydata.FILTER=60; guidata(fw,mydata)
%                 
%             case 'HP 100Hz'
%                 figure(fh); clf
%                 filterandplot(fh,wfdata,[100/(1/wfdata.DELTA) 0.9999],1);
%                 mydata = guidata(wf); mydata.FILTER=100; guidata(fw,mydata)
%                 
%             case 'LP 40Hz'
%                 figure(fh); clf
%                 filterandplot(fh,wfdata,[0.0001 40/(1/wfdata.DELTA)],1);
%                 mydata = guidata(wf); mydata.FILTER=-40; guidata(fw,mydata)
%                 
%             case 'LP 100Hz'
%                 figure(fh); clf
%                 filterandplot(fh,wfdata,[0.0001 100/(1/wfdata.DELTA)],1);
%                 mydata = guidata(wf); mydata.FILTER=-100; guidata(fw,mydata)
%                 
%             case 'BP 10-100Hz'
%                 figure(fh); clf
%                 filterandplot(fh,wfdata,[10/(1/wfdata.DELTA) 100/(1/wfdata.DELTA)],1);
%                 mydata = guidata(wf); mydata.FILTER=10-100i; guidata(fw,mydata)
%                 
%             
 
%             case 'HP 0.01'
%                 figure(fh); clf
%                 filterandplot(fh,wfdata,[0.01 0.9999])
%                 mydata = guidata(fw); mydata.FILTER=0.01; guidata(fw,mydata)
%         end
%     end
       
    function select_CLEAR(h_CLEAR,eventdata)
        str = get(h_CLEAR,'String')
        val = get(h_CLEAR,'Value')
        switch str{val};
            case 'Clear'
            case 'time_P'
                disp('!!!!')
                if exist('pt_P')==1; mydata = guidata(fw); mydata.t_P = []; guidata(fw,mydata); set(pt_P,'XData',[],'YData',[]); end
            case 'time_nf'
                if exist('pt_nf')==1; mydata = guidata(fw); mydata.t_nf = []; guidata(fw,mydata); set(pt_nf,'XData',[],'YData',[]); end
            case 'time_S'
                if exist('pt_S')==1; mydata = guidata(fw); mydata.t_S = []; guidata(fw,mydata); set(pt_S,'XData',[],'YData',[]); end
            case 'R_P'
                if exist('pRP')==1; mydata = guidata(fw); mydata.R_P = []; guidata(fw,mydata); set(pRP,'XData',[],'YData',[]); end
            case 'R_nf'
                if exist('pRnf')==1; mydata = guidata(fw); mydata.R_nf = []; guidata(fw,mydata); set(pRnf,'XData',[],'YData',[]); end
            case 'R_S'
                if exist('pRS')==1; mydata = guidata(fw); mydata.R_S = []; guidata(fw,mydata); set(pRS,'XData',[],'YData',[]); end
            case 'T_P'
                if exist('pTP')==1; mydata = guidata(fw); mydata.T_P = []; guidata(fw,mydata); set(pTP,'XData',[],'YData',[]); end
            case 'T_nf'
                if exist('pTnf')==1; mydata = guidata(fw); mydata.T_nf = []; guidata(fw,mydata); set(pTnf,'XData',[],'YData',[]); end
            case 'T_S'
                if exist('pTS')==1; mydata = guidata(fw); mydata.T_S = []; guidata(fw,mydata); set(pTS,'XData',[],'YData',[]); end
            case 'V_P'
                if exist('pVP')==1; mydata = guidata(fw); mydata.V_P = []; guidata(fw,mydata); set(pVP,'XData',[],'YData',[]); end
            case 'V_nf'
                if exist('pVnf')==1; mydata = guidata(fw); mydata.V_nf = []; guidata(fw,mydata); set(pVnf,'XData',[],'YData',[]); end
            case 'V_S'
                if exist('pVS')==1; mydata = guidata(fw); mydata.V_S = []; guidata(fw,mydata); set(pVS,'XData',[],'YData',[]); end
        end
    end

    function select_QUAL(h_QUAL,eventdata)
        str = get(h_QUAL,'String')
        val = get(h_QUAL,'Value')
        switch str{val};
            case 'Qual'
                mydata = guidata(fw); mydata.QUAL='none'; guidata(fw,mydata)
            case 'A'
                mydata = guidata(fw); mydata.QUAL='A'; guidata(fw,mydata)
            case 'B'
                mydata = guidata(fw); mydata.QUAL='B'; guidata(fw,mydata)
            case 'C'
                mydata = guidata(fw); mydata.QUAL='C'; guidata(fw,mydata)
        end
    end

    function select_COMMENT(h_COMMENT,eventdata)
        mydata = guidata(fw);
        mydata.COMMENT = input('Comment?  ','s');
        guidata(fw,mydata)
    end



    function select_DONE(varargin)
        uiresume(fw)
        return
    end

        


set(f,'Visible','on')

end

