%THIS CODE MAKES PLOTS FOR IWRAP PASSES
d2r = pi/180;

%Making nadir grid (units of km)
%Track-relative grid, km. %IWRAP along-track sampling = 100 - 150 m
delx = 0.25;delz = 0.03;
sx = -5.0:delx:5.0;      %across-track
enda = atdis{1};
xc1 = 0;yc1 = 0:delx:100;yc1 = double(yc1);
low = 0;high = 2;
zc1 = low:delz:high;
[xc,yc,zc]=meshgrid(sx,yc1,zc1);
zc = permute(zc,[2 1 3]);
yc = permute(yc,[2 1 3]);

nz = numel(zc1);nx = numel(sx);ny = numel(yc1);

iwrapws = sqrt(varu.^2 + varv.^2);                      %horizontal wind speed, m/s
ref = 10*log10(ref);

%Recompute iwrap u and v using wind direction bias correction
%%iwrapdir = 270 - (atan2d(varv,varu));           %meteorological convention (where wind is coming FROM)
%%iwrapdir = iwrapdir - 180;                      %vector convention (where wind is blowing TO)
%%iwrapdir = iwrapdir + bias;                  	%bias correction for 2050 utc
%%iwrapu = iwrapws.*sin(iwrapdir*d2r);    %bias corrected zonal wind
%%iwrapv = iwrapws.*cos(iwrapdir*d2r);    %bias corrected meridional wind

iwrapu = varu;
iwrapv = varv;

if pp == 2050
%Storm motion estimate for 1700 - 2200 UTC 9/23/05
stormu = -3.17;               %m/s
stormv = 4.11;                %m/s
%Storm center at 2050 UTC 9/23/05
slat = 28.1825;
slon = 360 - 92.643;
elseif pp == 1910
%Storm motion estimate for 1700 - 2200 UTC 9/22/05
stormu = -3.70;         %m/s
stormv = 2.05;          %m/s
%Storm center at 1910 UTC 9/22/05
slat = 25.73500;	
slon = 270.77899;
elseif pp == 2030
%Storm motion estimate for 1700 - 2200 UTC 9/22/05
stormu = -3.70;         %m/s
stormv = 2.05;          %m/s
%Storm center at 2030 UTC 9/22/05
slat = 25.84100;	
slon = 270.59399;
elseif pp == 2145
%Storm motion estimate for 1700 - 2200 UTC 9/22/05
stormu = -3.70;         %m/s
stormv = 2.05;          %m/s
%Storm center at 2145 UTC 9/22/05
slat = 25.9330;
slon = 270.4160;
elseif pp == 1740
%Storm motion estimate for 1700 - 2200 UTC 9/23/05
stormu = -3.17;               %m/s
stormv = 4.11;                %m/s
%Storm center at 1740 UTC 9/22/05
slat = 27.740;
slon = 360 - 92.217;
end


%Storm relative horizontal wind components
iwrapu = iwrapu - stormu;
iwrapv = iwrapv - stormv;


%Removing low SNR data
% iwrapws(ppccg<0.15|zc>1.0) = NaN;
% varw(ppccg<0.15|zc>1.0) = NaN;
% SS - remove z>0.1 only
iwrapws(zc>1.0) = NaN;
varw(zc>1.0) = NaN;

%Pulling out data at nadir and from 1.4 km and below (data bad above ~ 1.4 km)
ref2 = ref;
ws2 = iwrapws;
ww2 = varw;

if pp == 2030
%IWRAP vertical winds found to be biased high, applying correction here
ww2 = ww2 - 2.8319;
end

%storm-relative coordinates
xx = (lont - slon)*110.85*cos(slat*d2r);   	%km
yy = (latt - slat)*110.85;                    	%km

theta = atan2(yy,xx);
tang2 = -1*iwrapu.*sin(theta) + iwrapv.*cos(theta);    %tangential wind speed, m/s
radl2 = iwrapu.*cos(theta) + iwrapv.*sin(theta);       %radial wind speed, m/s

raddis = (xx.^2 + yy.^2).^0.5;          %radial distance from storm center, km



%[a,i] = mn(raddis);
%raddis = raddis(i:401);
%ref2 = ref2(:,i:401);
%ws2 = ws2(:,i:401);
%ww2 = ww2(:,i:401);

%%raddis(isnan(raddis)) = [];
%%[raddis,i] = sort(raddis);
%%ref2 = ref2(:,i);
%%ws2 = ws2(:,i);
%%ws2(ref2 < 25) = NaN;
%%ww2 = ww2(:,i);
ww2(ref2 < 25) = NaN;
%%tang2 = tang(:,i);
%%radl2 = radl(:,i);
tang2(ref2 < 25) = NaN;
radl2(ref2 < 25) = NaN;


windowh = 2;windowv = 4;

for k=1:nz
  for i=1:nx    %along-track filter
  radl2(i,:,k) = filter(ones(1,windowh)/windowh,1,radl2(i,:,k));
  tang2(i,:,k) = filter(ones(1,windowh)/windowh,1,tang2(i,:,k));
  ww2(i,:,k) = filter(ones(1,windowh)/windowh,1,ww2(i,:,k));
  ref2(i,:,k) = filter(ones(1,windowh)/windowh,1,ref2(i,:,k));
  end
end

for j=1:ny
  for i=1:nx	%vertical filter
  radl2(i,j,:) = filter(ones(1,windowv)/windowv,1,radl2(i,j,:));
  tang2(i,j,:) = filter(ones(1,windowv)/windowv,1,tang2(i,j,:));
  ww2(i,j,:) = filter(ones(1,windowv)/windowv,1,ww2(i,j,:));
  ref2(i,j,:) = filter(ones(1,windowv)/windowv,1,ref2(i,j,:));
  end
end

%Removing wind data below ~ 200 m height (k=7) and above ~ 1.4 km height (k=48)
lo = 7;hi = 48;
ww2(:,:,1:lo) = NaN;ww2(:,:,hi:nz) = NaN;
tang2(:,:,1:lo) = NaN;tang2(:,:,hi:nz) = NaN;
radl2(:,:,1:lo) = NaN;radl2(:,:,hi:nz) = NaN;

%Masking radial/tangential/vertical winds to match other data
mask = isnan(tang2) | isnan(radl2) | isnan(ww2);

tang2(mask) = NaN;
radl2(mask) = NaN;
ww2(mask) = NaN;

xc = permute(xc,[2 1 3]);
xc(isnan(ww2)) = NaN;
