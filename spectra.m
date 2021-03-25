trend = 1                      %1 is remove linear trend, 0 is don't remove

%%sa = 2;ea = 230;	%start/end index for along-track	
%%level = 0.5;  %km
%%[n,il] = min(abs(sz-level));

for c=1:2       %FFT loop...1 and 2 is for u and v winds

if c == 1
field = radl;	%radial windspeed
disp('Processing Radial Wind')
else
field = tang;	%tangential windspeed
disp('Processing Tangential Wind')
end

if pp == 1910
  zi=8;zf=34;
%%  ai=3;af=238;
  ai=80;af=148;		%38 - 55 km radius
elseif pp == 2050
  zi=8;zf=34;
%%[a,i]=min(abs(radius/1000 - 26.0))	%find radius index	
  ai=207;af=263;	%26 - 40 km radius
elseif pp == 2030
  zi=8;zf=34;
  ai=90;af=147;		%31 - 45 km radius
end

field = field(ai:af,zi:zf);

na = size(field,1);	%along-track
nz = size(field,2);	%height
nx = nz;


%Removing linear trend in along-track direction...
if trend == 1

  for j=1:nx
    slope(j) = (field(na,j) - field(1,j))/(na-1);
  end

  slope = reshape(slope,1,nx);
  slope = repmat(slope,na,1);

  for i=1:na
    for j=1:nx
        fieldd(i,j) = field(i,j) - 0.5*(2*i - na - 1)*slope(i,j);
    end
  end

else

  fieldd = field;

end

%Computing 1D Fourier transform...x-direction for now
dx = 0.25;                          	%grid spacing, km
N = size(fieldd,1);
half = floor(N/2);                  	%truncate to integer

amp = abs(fft(fieldd,[],1)/N);          %discrete 1D Fourier transform, points = N
%amp = fft(fieldd,[],1)/N;              %discrete 1D Fourier transform, points = N
zero = amp(1,:,:);                      %mean wavenumber or frequency                  
asym = 2*amp(2:half+1,:,:);             %asymmetric wavenumbers or frequencies
spec = cat(1,zero,asym);                %total spectrum

if c == 1
uspec = spec;           		%spectrum of u velocity field
else c == 2
vspec = spec;           		%spectrum of v velocity field
end

clear slope
end     %FFT loop

%kinetic energy spectrum, m^2/s^2 per unit wavenumber or m^3/s^2...
kes = 0.5*(uspec.^2 + vspec.^2);

i = [0:1:half];
k = (2*pi*i)/(dx*1000*N);           %wavenumber, m^-1
l = (2*pi)./k;                      %wavelength, m
l = l/1000;                         %wavelength, km

%NOTE: Mean values do not show up on these plots because wavenumber 0 is undefined for wavelength.
%Only showing values for wavenumber 1 and larger (i.e. energy for 1 full wave across domain).


%Averaging spectra in height
mean0 = mean(kes,2);

%Plotting time mean spectra
figure(1)

loglog(l,mean0,'g','linewidth',2)
set(gca,'XDir','rev')
xlabel('Wavelength (km)');
ylabel('Kinetic Energy Density (m^3 s^-^2)');
%legend('1910-1920 UTC','2030-2040 UTC','2050-2100 UTC')
%legend('boxoff')
