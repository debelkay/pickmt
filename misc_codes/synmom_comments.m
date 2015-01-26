function [ux,uy,uz,r,afsx,afsy]=synmom_comments(x,y,z,mij,dt,nt,s,smom,alpha,beta,rho)
%synthetic seismograms for a whole space per aki and Richards
%at positiion x,y,z
%output ground motion xt, yt, zt
% -Joe Fletcher, 2007
%
%  Some more info/comments:  (Margaret 2007)
%   x,y,z = coordinents of station (in km)
%   mij = moment tensor  [xx,yy,zz,xy,xz,yz]
%   dt = 1/sample rate
%   nt =  number of points in the seismogram
%   ti =   start time for the seismogram
%   smom = M0 in dyne-cm
%   s = unit seismic moment rate function 
%   alpha = p-wave velocity in m/s  
%   beta = s-wave velocitiy in m/s   
%   rho = density in kg/m3   (e.g. 2.65)
%
%  Outputs:
%   ux,uy,uz = u in coordinate axis in cm
%   r = distance
%   afsx = radiation pattern   s, x-axis
%   afsy = radiation pattern   s, y-axis
%
%   inputs and outputs are in mKs units, but calculations are in cgs
%
% additional comments below added by Margaret Boettcher May 5, 2009


alpha = alpha*1e-3;                         %change p wave velocity to km/s
beta = beta*1e-3;                           %change s wave velocity to km/s
rho = rho*1e-3;                             %change rho to cgs...kg/cm3?

ns=length(s);                               %number of points in the unit moment rate function

x=x*10^5;  %convert km to cm                %station x location relative to the hypocenter in cm
y=y*10^5;                                   %station y location relatuve to the hypocenter in cm
z=z*10^5;                                   %station z location relative to the hypocenter in cm
r=sqrt(x^2+y^2+z^2);                        %hypocentral distance in cm
rx=x/r;                                     %hypocentral distance projected onto x dir
ry=y/r;                                     %hypocentral distance projected onto y dir
rz=z/r;                                     %hypocentral distance projected onto z dir

alpha1=alpha*10^5;                          %change p wave velocity to cm/s
beta1=beta*10^5;                            %change s wave velocity to km/s

smo = cumsum(s)*dt*smom;                    %Cummulative Moment 
for j=ns+1:nt                               %time after the rupture pluse
    smo(j)=smo(ns);                         %take the last point in the rupture pulse and give that
end                                         %  displacement to all future points 
                                            %  (i.e. make sure to end with a zero)                                            

ip=floor(r/(alpha1*dt))+1;                  %time of P wave arrival 
is=floor(r/(beta1*dt))+1;                   %time of S wave arrival 
isns=is+ns;                                 %time following the s wave arrival in the source pulse

ti = 0;                                     %start time of the seismogram (seems to need to be this value...)
ib=ti/dt;                                   %beginning point
if ib<=0;
    ib=1;
end
ie=ib+nt;                                   %ending point (removed "tf=ie*dt;  %final time" becuase it was never used!)
lie = length(ib:ie);

%% From equation 4.29 of Aki & Richards- Displacement Field: M_pq * G_np,q = u_n                

rhoin=1/(4*pi*rho);                         %denominator of first term in 4.29 Aki & Richards
rhoia=rhoin/(alpha1^2);                     %denominator of second term in 4.29 Aki & Richards
rhoib=rhoin/(beta1^2);                      %denominator of third term in 4.29 Aki & Richards
rfp=rhoia/alpha1;                           %denominator of fourth term in 4.29 Aki & Richards
rfs=rhoib/beta1;                            %denominator of fifth term in 4.29 Aki & Richards

% total displacement???
d1=(rx^2)*mij(1)+(ry^2)*mij(2)+(rz^2)*mij(3)+2*rx*ry*mij(4)+2*rx*rz*mij(5)...
   +2*ry*rz*mij(6);                         
dx=rx*d1;
dy=ry*d1;
dz=rz*d1;

% trace of moment tensor...
e1=mij(1)+mij(2)+mij(3);
ex=rx*e1;
ey=ry*e1;
ez=rz*e1;

% terms in each direction
fx=rx*mij(1)+ry*mij(4)+rz*mij(5);
fy=rx*mij(4)+ry*mij(2)+rz*mij(6);
fz=rx*mij(5)+ry*mij(6)+rz*mij(3);

%AN Term, near-field ramp term...
anx=15*dx-3*ex-6*fx;                        %
any=15*dy-3*ey-6*fy;
anz=15*dz-3*ez-6*fz;

%"Intermediate" (Nearfield-Term) for P
aipx=6*dx-ex-2*fx;
aipy=6*dy-ey-2*fy;
aipz=6*dz-ez-2*fz;

%"Intermediate" (Nearfield-Term) for S
aisx=-6*dx+ex+3*fx;
aisy=-6*dy+ey+3*fy;
aisz=-6*dz+ez+3*fz;

%Radiation pattern of P in the x, y, or z-dir
afpx=dx;
afpy=dy;
afpz=dz;

%Radiation pattern of S in the x, y, or z-dir
afsx=-dx+fx;
afsy=-dy+fy;
afsz=-dz+fz;

% keyboard
% counter = 0;

%% Displacement from Nearfield Ramp Term
tmi = zeros(lie,1);
for j=ip:isns;                              %p-wave arrival to end of s-wave pulse
    
%     counter = counter+1;
%     
%     if counter<=10
%         disp(['working on counter = ',num2str(counter)])
%     end
%     
%     if mod(counter,0.01*(isns-ip))==0
%         disp(['finished with ',num2str(100*counter/(isns-ip)),' percent'])
%     end
%     
    
    if j==ip
    disp(['start = ',num2str(ip),' and end = ',num2str(isns)])
    end


	k=j+1;                          
	Lp=k-ip;                                %point number between initial p and end of s
    if Lp<=0                              %i don't think it's possible to have Lp <= 0...
        sum=0;                              
    else
        sum=dt*ip*smo(Lp);                  %sum = ???  = timestep*time of pwave arrival*cummulative moment release until current point
    end

    Ls=k-is;                                %time relative to swave arrival
    if Ls <= 0                              %we are between p and s wave
        sum = 0;                                %reset sum to 0...
    else                                    %we are after s-wave before end of swave pulse
        sum=sum+dt*is*smo(Ls);                  %add old sum to timestep*point in s-wave pulse*cummulative moment release at this point in the moment rate function 
    end
        
    ip1=ip+1;                               %step in time beyond the intial pwave arrival
	is1=is-1;                               %step backward prior to swave arrival???
	for m=ip1:2:is1                         %time between beinging of p-wave and beginning of s-wave
		Lm=k-m;                             %                
        if Lm<=0
            sum=sum+0;
        else
            sum=sum+4*dt*m*smo(Lm);
        end
	end
	ip2=ip+2;
	is2=is-2;
	for m=ip2:2:is2
		Lm=k-m;
        if Lm <= 0
            sum=sum+0;
        else
            sum=sum+2*dt*m*smo(Lm);
        end
    end
	tmi(j)=dt*sum/3;                        %I think this might be the integral in the first term of eqn. 4.29
end

isp1=isns+1;
for j=isp1:ie
	tmi(j)=tmi(isns);
end
ipm1=ip-1;
for j=ib:ipm1
	tmi(j)=0;
end

unx = zeros(lie,1);              
uny = zeros(lie,1); 
unz = zeros(lie,1);
for j=ib:ie
	d=tmi(j)*rhoin/(r^4);
	unx(j)=anx*d;
	uny(j)=any*d;
	unz(j)=anz*d;
end

%% Displacement from intermediate nearfield P
uipx = zeros(lie,1);             
uipy = zeros(lie,1);
uipz = zeros(lie,1);
ip1=ip-1;
for j=ib:ip1
	uipx(j)=0;
	uipy(j)=0;
	uipz(j)=0;
end
for j=ip:ie
	k=j-ip+1;
	d=rhoia*smo(k)/(r^2);
	uipx(j)=aipx*d;
	uipy(j)=aipy*d;
	uipz(j)=aipz*d;
end

%% Displacement from intermediate nearfield S
uisx = zeros(lie,1);             
uisy = zeros(lie,1);
uisz = zeros(lie,1);
is1=is-1;
for j=ib:is1;
	uisx(j)=0;
	uisy(j)=0;
	uisz(j)=0;
end
for j=is:ie;
	k=j-is+1;
	d=rhoib*smo(k)/(r^2);
	uisx(j)=aisx*d;
	uisy(j)=aisy*d;
	uisz(j)=aisz*d;
end

%% Displacement from farfield P
ufpx = zeros(lie,1);             
ufpy = zeros(lie,1);
ufpz = zeros(lie,1);
for j=ib:ip1
	ufpx(j)=0;
	ufpy(j)=0;
	ufpz(j)=0;
end
ins1=ip+ns+1;
for j=ins1:ie
	ufpx(j)=0;
	ufpy(j)=0;
	ufpz(j)=0;
end
ipns=ip+ns-1;
for j=ip:ipns
	k=j-ip+1;
	d=rfp*s(k)*smom/r;
	ufpx(j)=afpx*d;
	ufpy(j)=afpy*d;
    ufpz(j)=afpz*d;
end

%% Displacement from farfield S
ufsx = zeros(lie,1);             
ufsy = zeros(lie,1);
ufsz = zeros(lie,1);
for j=ib:is1
	ufsx(j)=0;
	ufsy(j)=0;
	ufsz(j)=0;
end
ins1=is+ns+1;
for j=ins1:ie
	ufsx(j)=0;
	ufsy(j)=0;
	ufsz(j)=0;
end
isns=is+ns-1;
for j=is:isns
	k=j-is+1;
	d=rfs*s(k)*smom/r;
	ufsx(j)=afsx*d;
	ufsy(j)=afsy*d;
	ufsz(j)=afsz*d;
end

%% Putting all the terms together!
ux = zeros(1,lie);
uy = zeros(1,lie);
uz = zeros(1,lie);
for j=ib:ie                            
	ux(j)=unx(j)+uipx(j)+uisx(j)+ufpx(j)+ufsx(j);
	uy(j)=uny(j)+uipy(j)+uisy(j)+ufpy(j)+ufsy(j);
	uz(j)=unz(j)+uipz(j)+uisz(j)+ufpz(j)+ufsz(j);
end


