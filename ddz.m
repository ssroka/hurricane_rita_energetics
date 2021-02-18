function [dfdz] = ddz(f,f_b,f_t,dz,T_flag,B_flag)
% returns the second order point-wise derivative in the theta direction
% input:
%        f = vector along the radial direction
%        f_b = vector along the radial direction that is one dz below f
%        unless B_flag is false in which case it is 2dz above f
%        f_t = vector along the radial direction that is one dz above f
%        unless B_flag is false in which case it is 2dz above f
%        dtheta = equal spacing between each of the points of f wrt f_R/L
% output:
%        dfdtheta = a vector of equal length to f that is populated with
%                    the first derivative (2nd order accurate) along the
%                    f vector

%NOTE, this assumes that the vertical grid spacing is constant

if (size(f,1)>2) && (size(f,2)>2)
    error('ddz must take a vector')
end
f = f(:)'; % make it a row vector
f_b = f_b(:)'; % make it a row vector
f_t = f_t(:)'; % make it a row vector

if ~T_flag % there is no top segment, use two bottom segments
    % f_b is actually 2 dz's above f
    % one-sided 2nd order fwd difference going down
    dfdz = ( (3/2)*f - 2*f_b + (1/2)*f_t )/dz;
elseif ~B_flag % there is no bottom segment, use two top segments
    % f_t is actually 2 dz's below f
    % one-sided 2nd order fwd difference going up
    dfdz = ( (-3/2)*f + 2*f_t - (1/2)*f_b )/dz;
else
    % centered difference
    dfdz = (f_t-f_b)/(2*dz);
end

dfdz = shiftdim(dfdz);
end
