function [dfdr] = ddr(f,dr)
% returns the second order point-wise derivative along the vector f
% input:
%         f = vector
%        dr = equal spacing between the points of f
% output:
%      dfdr = a vector of equal length to f that is populated with the
%                first derivative (2nd order accurate) along the f vector

if (size(f,1)>2) && (size(f,2)>2)
    error('ddr must take a vector')
end

f = f(:)'; % make it a row vector
dfdr = zeros(1,length(f));

% centered difference for the middle
dfdr(2:end-1) = ( f(3:end) - f(1:end-2) )/(2*dr);

% one-sided 2nd order fwd  difference on the left
dfdr(1) = ( (-3/2)*f(1) + 2*f(2) - (1/2)*f(3) )/dr;

% one-sided 2nd order bkwd difference on the right (hence the -dr)
dfdr(end) = ( (3/2)*f(end) - 2*f(end-1) + (1/2)*f(end-2) )/dr;

dfdr = shiftdim(dfdr);
end
