function [origVR,sVolRatio]=resampMij(orig_u,orig_A,M0,N)

    mij = [orig_A\orig_u']';


  sqmij = [mij(1) mij(4) mij(5); mij(4) mij(2) mij(6); mij(5) mij(6) mij(3)]*M0;
    trace_mij = trace(sqmij);
    eig_mij = eig(sqmij);     %diagonalized moment tensor
    dev = eig_mij - trace_mij/3;  % the deviatoric portion of the moment tensor
    scalerMo = sum(dev(dev>0));  %scaler seismic moment 
    mw_dev = 2/3*(log10(scalerMo)-9.1);
    mu = 3.76e10;  %shear modulus in Pa
    lamda = 2.9e10; %???
    mu_lamda = 1.63e11;
    deltaV = (trace_mij)/(mu_lamda);
    AD = scalerMo/mu;
    VolRatio = deltaV/AD;

origVR = VolRatio;








for ii=1:N
    clear userand u A VolRatio
    userand = ceil(length(orig_u)*rand(length(orig_u),1));
    u = orig_u(userand);
    A = orig_A(userand,:);



    mij = [A\u']';


  sqmij = [mij(1) mij(4) mij(5); mij(4) mij(2) mij(6); mij(5) mij(6) mij(3)]*M0;
    trace_mij = trace(sqmij);
    eig_mij = eig(sqmij);     %diagonalized moment tensor
    dev = eig_mij - trace_mij/3;  % the deviatoric portion of the moment tensor
    scalerMo = sum(dev(dev>0));  %scaler seismic moment 
    mw_dev = 2/3*(log10(scalerMo)-9.1);
    mu = 3.76e10;  %shear modulus in Pa
    lamda = 2.9e10; %???
    mu_lamda = 1.63e11;
    deltaV = (trace_mij)/(mu_lamda);
    AD = scalerMo/mu;
    VolRatio = deltaV/AD;
    
    sVolRatio(ii) = VolRatio;
end

    