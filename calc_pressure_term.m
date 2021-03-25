

%{
% pressure term, 1/rho (u dpdr + v dpdtheta + w dpdz)

% digitizer data captured for region outside the eyewall, rmw = 10 km

% r [km] in 1st col
% P [hPa] in 2nd col
data = [30.047619047619047, 934.9999999999999
39.66666666666667, 939.4117647058822
50.90476190476191, 943.5294117647057
62.047619047619065, 947.3529411764705
69.2857142857143, 949.9019607843136]; 

% estimate slope
p = polyfit(data(:,1),data(:,2),1);

dpdr_SI = p(1)*(100)*(1/1000); % convert: 1 hPa = 100 Pa, 1 km = 1000 m

% dP/dr in Pa/m is
fprintf('The fitted slope is %f Pa/m\n',dpdr_SI)

% slope from Marks et al. 2008 is 0.037441
%}


% rho profile
rhoz_bar = 1.275;               %kg/m^3 (Wallace and Hobbs, 1977)
H = 6.90;                   %km, scale height (Wallace and Hobbs, 1977)
rhoz = rhoz_bar.*exp(-1*zc1/H);

one_over_rho = repmat(1./rhoz',1,length(raddis));

% 1/rho u dp/dr
dpdr = 0.037441; % Pa/m

% radl is the filtered u comp. of the wind (filtering_germano_azimean.m)
pgf_r = (radl'.*one_over_rho.*dpdr)';

if mean_rm
% 1/rho u dp/dz
dpdz = -0.5; % Pa/m
else
   % 1/rho u dp/dz
dpdz = -10; % Pa/m 
end

% vert is the filtered w comp. of the wind (filtering_germano_azimean.m)
% populate dpdz w/ dpdr for now so we can create plots
pgf_z = (vert'.*one_over_rho.*dpdz)';

