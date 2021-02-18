%Grid spacing is 250 m so 8 point window filters over 2.0 km, but the FiltFiltM function does a forward/backward filter 
%     so the spatial scale for damping is slightly larger.
window = 8;
%Running mean filter coefficients (a,b)
a = 1;
b = (1/window)*ones(1,window);

nr = size(tang,1);
Leo = NaN(nr,nz,3,3);Cro = NaN(nr,nz,3,3);Rey = NaN(nr,nz,3,3);

term1 =  NaN(nr,nz,3,3);
term2 =  NaN(nr,nz,3,3);
term3 =  NaN(nr,nz,3,3);
term4 =  NaN(nr,nz,3,3);
term5 =  NaN(nr,nz,3,3);
term6 =  NaN(nr,nz,3,3);
term7 =  NaN(nr,nz,3,3);
term8 =  NaN(nr,nz,3,3);
term9 =  NaN(nr,nz,3,3);
term10 =  NaN(nr,nz,3,3);

ttang = tang*NaN;
tradl = tang*NaN;
tvert = tang*NaN;

sfs_radl = tang*NaN;
sfs_tang = tang*NaN;
sfs_vert = tang*NaN;


for k=lo+1:hi-1	%height loop, iwrap levels with good data

good = sum((~isnan(tang(:,k))));

if good > (3*window)

%Pulling out radial profiles of winds
pullt = squeeze(tang(:,k));
pullr = squeeze(radl(:,k));
pullw = squeeze(vert(:,k));

totalt = pullt;totalr = pullr;totalw = pullw;

totalt(isnan(totalt)) = [];
totalr(isnan(totalr)) = [];
totalw(isnan(totalw)) = [];

%%%%rr = sx1;rr(isnan(pullt)) = [];

totwind(:,1) = totalr;
totwind(:,2) = totalt;
totwind(:,3) = totalw;

%Forward, then backward filter (zero phase shift) with extrapolation for edge effects
ftang = FiltFiltM(b,a,totalt);
fradl = FiltFiltM(b,a,totalr);
fvert = FiltFiltM(b,a,totalw);

%FFT filtering below...found that this method doesn't handle edges well (FiltFilt is better for that)
%%N = size(totalt,1);
%%half = floor(N/2);                      %truncate to integer
%%notrend = detrend(totalt);trend = totalt - notrend;
%%hat = fft(notrend);amp = real(hat);phase = imag(hat);

%%i = [0:1:half];
%%k = (2*pi*i)/(dx*1000*N);           %wavenumber, m^-1
%%l = (2*pi)./k;                      %wavelength, m
%%l = l/1000;                         %wavelength, km
%%clear i

%cutoff wavelength of ~ 10 km
%%cutoff = l(20)
%%cutind = 20;		
%New signal without energy below 5 km
%%hat(cutind:N-cutind+2) = 0;
%Inverse FFT to build new signal
%%notrend = ifft(hat);
%%ftang = notrend + trend;

%perturbation data, removing filtered data
sfs(:,1) = totalr - fradl;
sfs(:,2) = totalt - ftang;
sfs(:,3) = totalw - fvert;

%filtered perturbation data
fsfs(:,1) = FiltFiltM(b,a,sfs(:,1));
fsfs(:,2) = FiltFiltM(b,a,sfs(:,2));
fsfs(:,3) = FiltFiltM(b,a,sfs(:,3));


  for i=1:3
  for j=1:3

% I double checked the code below and it looks good.

  temp1 = FiltFiltM(b,a,totwind(:,i)).*FiltFiltM(b,a,totwind(:,j));
  temp2 = FiltFiltM(b,a,FiltFiltM(b,a,totwind(:,i))).*FiltFiltM(b,a,FiltFiltM(b,a,totwind(:,j)));
  Leo(~isnan(pullt),k,i,j) = FiltFiltM(b,a,temp1) - temp2;					%Leonard Stress (Germano), m^2/s^2

  term1(~isnan(pullt),k,i,j) = FiltFiltM(b,a,temp1);
  term2(~isnan(pullt),k,i,j) = -temp2;
  
  temp1 = FiltFiltM(b,a,totwind(:,i)).*sfs(:,j);
  temp2 = FiltFiltM(b,a,totwind(:,j)).*sfs(:,i);
  temp3 = FiltFiltM(b,a,FiltFiltM(b,a,totwind(:,i))).*fsfs(:,j);
  temp4 = FiltFiltM(b,a,FiltFiltM(b,a,totwind(:,j))).*fsfs(:,i);
  Cro(~isnan(pullt),k,i,j) = FiltFiltM(b,a,temp1) + FiltFiltM(b,a,temp2) - temp3 - temp4;	%Cross Stress (Germano), m^2/s^2
  
  term5(~isnan(pullt),k,i,j) = FiltFiltM(b,a,temp1);
  term6(~isnan(pullt),k,i,j) = FiltFiltM(b,a,temp2);
  term7(~isnan(pullt),k,i,j) = -temp3;
  term8(~isnan(pullt),k,i,j) = -temp4;
  
  temp1 = FiltFiltM(b,a,sfs(:,i).*sfs(:,j));
  temp2 = fsfs(:,i).*fsfs(:,j); 
  Rey(~isnan(pullt),k,i,j) = temp1 - temp2;	%Reynolds Stress (Germano), m^2/s^2

  term3(~isnan(pullt),k,i,j) = temp1;
  term4(~isnan(pullt),k,i,j) = -temp2;
  
  term9(~isnan(pullt),k,i,j) = FiltFiltM(b,a,totwind(:,i).*totwind(:,j));
  term10(~isnan(pullt),k,i,j) = -FiltFiltM(b,a,totwind(:,i)).*FiltFiltM(b,a,totwind(:,j));
  
  end
  end

%Assigning data to output variables...units of m/s

%Total winds
ttang(~isnan(pullt),k) = totalt;
tradl(~isnan(pullt),k) = totalr;
tvert(~isnan(pullt),k) = totalw;

%Filtered winds
tang(~isnan(pullt),k) = ftang;
radl(~isnan(pullt),k) = fradl;
vert(~isnan(pullt),k) = fvert;

%Perturbation winds
sfs_radl(~isnan(pullt),k) = sfs(:,1);
sfs_tang(~isnan(pullt),k) = sfs(:,2);
sfs_vert(~isnan(pullt),k) = sfs(:,3);

end	%condition for good data

clear totwind sfs fsfs
end	%height loop
