function []=plotwfwithsynt(picks,mij)



Mw = picks(1).Mw;
%gamma = picks(1).AZ;    
gamma = picks(1).BAZ;


%% Standard Parameter Values in SI units:  (these can be changed here)
alpha = 5900;  %m/s 
beta = 3600;   %m/s
rho= 2640;     %should be densisity in kg/m3
Q = 200;       %attenuation

%% Calculate approximate seismic moment and corner frequency from Mw
M0 = 10.^(1.5*Mw+9.05);
sigma = 3e6;                           %assuming a stress drop of 3 MPa
r = (7/16*M0./sigma).^(1/3);           %radius of a circular crack (m)
%f0 = 2.01*alpha./(2*pi*r);             %corner frequency from Madariaga, 1976 (Hz)
f0 = 2.01*beta./(2*pi*r);             %corner frequency from Madariaga, 1976 (Hz)






% calculate input moment rate function
[smom,s,tsyn,dt,nt] = mij_TriangleMoRate(M0,f0);





for ii=1:length(picks)
    
    %% compute synthetics for each station and plot output


    xx = (picks(ii).evXYZ(1) - picks(ii).stXYZ(1))/1000;
    yy = (picks(ii).evXYZ(2) - picks(ii).stXYZ(2))/1000;
    zz = (picks(ii).evXYZ(3) - picks(ii).stXYZ(3))/1000;    
    R = sqrt(xx^2+yy^2+zz^2)*1000;

    
    [ux_orig,uy_orig,uz_orig,r,afsx,afsy]=synmom_comments(xx,yy,zz,mij,dt,nt*2,s,smom,alpha,beta,rho);
%     [ux_orig,uy_orig,uz_orig,r,afsx,afsy]=synmom_comments(xx,yy,zz,tempmij,dt,nt,s,smom,alph,beta,rho);

% keyboard
    tt = 0:dt:length(uz_orig)*dt-dt;
    %rotate synthetics to radial and transvrse knowing the  rotation angle from the sac rotations
%     g = gamma*pi/180;
%     rotmat = [cos(g) sin(g); -sin(g) cos(g)];
%     urot = rotmat*[ux_orig; uy_orig];
%     uh1_orig = urot(1,:)/100;
%     uh2_orig = urot(2,:)/100;
%     uz_orig=uz_orig/100;        

% DK RTZ ROTATION FIX APRIL 2012 (PRE-SSA)
            [r_ux,r_uy,r_uz] = rotatetoRTZ(ux_orig,uy_orig,uz_orig,gamma);
            uh1_orig = r_ux/100;
            uh2_orig = r_uy/100;
            uz_orig = r_uz/100;
            


    %--apply azimi q opporator to the synthetics (Q=200 default)--
    [Qop,t_Qop,arrival_index] = azimi_msb(dt/10,Q,R/1000,beta);
    qop = real(Qop(arrival_index:end))*dt/10;        
    tqop = t_Qop(arrival_index:end)-t_Qop(arrival_index);

    uh1=conv(qop,uh1_orig);
    uh2=conv(qop,uh2_orig);
    uz=conv(qop,uz_orig);        

    uh1=uh1(:,1:length(tt));
    uh2=uh2(:,1:length(tt));
    uz=uz(:,1:length(tt));        

    
    
    if isfield(picks,'f_dH1')==0
        picks(ii).f_dH1 = [];
        picks(ii).f_dH2 = [];
        picks(ii).f_dZ = [];
    end
    
    if length(picks(ii).f_dH1)>0
        f_dH1 = picks(ii).f_dH1;
        f_dH2 = picks(ii).f_dH2;
        f_dZ = picks(ii).f_dZ;        
    else
        f_dH1 = picks(ii).dH1;
        f_dH2 = picks(ii).dH2;
        f_dZ = picks(ii).dZ;
    end
    
    
    figure;
    subplot(311); plot(tt,uh1,'r'); hold on; plot(picks(ii).t,f_dH1)
    title([picks(ii).title])
    subplot(312); plot(tt,uh2,'r'); hold on; plot(picks(ii).t,f_dH2)
    subplot(313); plot(tt,uz,'r'); hold on; plot(picks(ii).t,f_dZ)
  
end


