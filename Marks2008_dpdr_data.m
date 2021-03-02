clear;close all;clc

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
