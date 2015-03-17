function [mij,mij_zerotrace,deltaV,sVolRatio,mw_dev,mw_full,ftest,norm_ste_mij]=compute_mij(utemp,Atemp,M0,conflim)
% Compute moment tensor using phase amplitude picks
%
% Input:
%   u = data amplitude picks (12 x Nsta)
%   A = single component moment tensor picks (9 x 6 x Nsta)
%
% Output:
%   mij = full moment tensor
%   mij_zero = zero trace moment tensor
%   deltaV = [deltaV deltaV_lowerlimit deltaV_higherlimit]
%   restest = results of statistical test (1=sig,0=not sig)
%
% DKane 20110923
% MSB changed quite a bit 20140729



%% Reorganize data and synthetic picks into proper format for inversion:
% Get rid of pick times; they are unnecessary for the inversion:
uamps = utemp(4:end,:);
N = size(Atemp,3);


% Rearrange and determine where there are no picks and dump those data/synthetics
uvec = uamps(:);
Avec = [];
for i=1:N
    Avec = [Avec; Atemp(:,:,i)];
end

keepthese = find(isnan(uvec)==0);
u = uvec(keepthese)';   % change orientation of u to match Margaret's stuff
A = Avec(keepthese,:);


% Also dump any NaN values in A in case synthetic times were not picked
clear keepthese
keepthese = find(isnan(A(:,1))==0);
u = u(keepthese);
A = A(keepthese,:);

testsumu = sum(isnan(u));
testsumA = sum(isnan(A(:)));
if testsumu>0 || testsumA>0
    disp('problem with NaN values')
    disp('exiting to keyboard')
    keyboard
end


% keyboard

%% Perform inversion

% Full tensor:
mij = (A\u')';
    
% Zero-trace tensor:
Azero = [A(:,1)-A(:,3) A(:,2)-A(:,3) A(:,4:6)];
mijzero = (Azero\u')';
mij_zerotrace = [mijzero(1:2) -1*(mijzero(1)+mijzero(2)) mijzero(3:5)];

% Calculate errors and confidence intervals:
    Y = u' - A*mij';    % Residuals
    Yzero = u' - Azero*mijzero';    % Residuals

    %calculating the F-test using an equation in tables 5.12/5.13 in Davis p. 217
    Fdata=(sum(Yzero.^2)-sum(Y.^2))/(sum(Y.^2)/(length(u)-6));
    Fcrit=finv(conflim,1,length(u)-6);
    if Fdata>Fcrit
        ftest = 1
    else
        ftest = 0
    end
    
    %Standar Error and Standard Error normalized by the range of pick amplitues
    steY = std(Y)/sqrt(length(u));
    norm_ste_mij = steY/(max(u)-min(u));    
    C = (A'*A)^-1;
    t975 = tinv(.975,length(u)-6);
    for ii = 1:6
        ste_mij(ii) = steY*sqrt(C(ii,ii));
        confint(ii,:) = [mij(ii)-t975*ste_mij(ii) mij(ii)+t975*ste_mij(ii)];
        if mij_zerotrace(ii) >= min(confint(ii,:)) & mij_zerotrace(ii) < max(confint(ii,:))
            zt(ii) = 1;
        else
            zt(ii) = 0;
        end
    end
    pm975 = t975*ste_mij;
    confint;
    if sum(zt) == 6
        disp('mij is indistinguishable from deviatoric')
        
        restest = 0;    %not sig
    else
        restest = 1;    %sig
        
    end

    

%% Compute volume change for the full tensor:

    sqmij = [mij(1) mij(4) mij(5); mij(4) mij(2) mij(6); mij(5) mij(6) mij(3)]*M0;
    trace_mij = trace(sqmij);
    eig_mij = eig(sqmij);     %diagonalized moment tensor
    dev = eig_mij - trace_mij/3;  % the deviatoric portion of the moment tensor
    scalerMo = sum(dev(dev>0));  %scaler seismic moment 
    mw_dev = 2/3*(log10(scalerMo)-9.1);

    mu = 3.76e10;  %shear modulus in Pa
    lamda = 2.9e10; %Lame's parameter
    mu_lamda = 1.63e11; %(2*mu+3*lamda)
    deltaV = (trace_mij)/(mu_lamda);
    AD = scalerMo/mu;
    VolRatio = deltaV/AD

    MoFull = scalerMo+abs(scalerMo*VolRatio);
    mw_full = 2/3*(log10(MoFull)-9.1);
    
 %---- confindence limits on the volume change calulation----
    c1 = confint(1,1):diff(confint(1,1:2))/4:confint(1,2);
    c2 = confint(2,1):diff(confint(2,1:2))/4:confint(2,2);
    c3 = confint(3,1):diff(confint(3,1:2))/4:confint(3,2);
    c4 = confint(4,1):diff(confint(4,1:2))/4:confint(4,2);
    c5 = confint(5,1):diff(confint(5,1:2))/4:confint(5,2);
    c6 = confint(6,1):diff(confint(6,1:2))/4:confint(6,2);
	VolRatioL = VolRatio;
    VolRatioH =VolRatio;
    scalerMoH = scalerMo;
    for ii=1:length(c1)
        for j =  1:length(c2)
            for k = 1:length(c3)
                for l = 1:length(c4)
                    for p = 1:length(c5)
                        for q = 1:length(c6)
                            mijtest = [c1(ii) c2(j) c3(k) c4(l) c5(p) c6(q)];
                            sqmijtest =[mijtest(1) mijtest(4) mijtest(5); mijtest(4) mijtest(2) ...
                                mijtest(6); mijtest(5) mijtest(6) mijtest(3)]*M0;
                            tr = trace(sqmijtest);
                            ei = eig(sqmijtest);
                            de = ei-tr/3;
                            scalerMotest = sum(de(de>0));  %scaler seismic moment          
                            deltaVtest = tr/mu_lamda; 
                            VolRatiotest = deltaVtest/(scalerMotest/mu);
                            if VolRatiotest < VolRatioL
                                VolRatioL = VolRatiotest;
                            elseif VolRatiotest > VolRatioH
                                VolRatioH = VolRatiotest;                                
                            end
                        end
                    end
                end
            end
        end
    end
    VolRange = [VolRatioL VolRatioH];
    
    
deltaV = [VolRatio VolRange];



% keyboard
[origdeltaV,sVolRatio] = resampMij(u,A,M0,1000);



