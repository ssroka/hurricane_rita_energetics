
%{

pull out the line (all of the radial direction at one angle theta and one
height
above below and to the angular left and right (we already have the data in
the r direction)
and get the partial derivatives of the filtered quantities in each of these
spatial directions.

NOTE: TANG,RADL AND VERT WINDS USED HERE ARE FILTERED WINDS
%}

%Total sub-filter-scale fluxes, units of m^2 s^-2
Tau = Leo + Cro + Rey;

Strain = Leo*NaN;
gradients = NaN(nr,nz,10);
advection =  Leo*NaN;
utau =  Leo*NaN;

d_radl_dr_mat = NaN(nr,nz);
d_radl_dz_mat = NaN(nr,nz);
d_tang_dr_mat = NaN(nr,nz);
d_tang_dz_mat = NaN(nr,nz);
d_vert_dr_mat = NaN(nr,nz);
d_vert_dz_mat = NaN(nr,nz);

% true means that these profiles exist, false means use a one-sided
% difference
B_flag = 1;
T_flag = 1;
L_flag = 1;
R_flag = 1;

dwdr = zeros(size(tang));

for k=lo+1:hi-1 %height loop, using iwrap levels with good data

good = sum((~isnan(tang(:,k))));

if good > (3*window)


% ====================== try below ======================
if sum((~isnan(tang(:,k-1)))) > (3*window)
    k_b = k-1;
    
    ftang_b = tang(:,k_b);
    fradl_b = radl(:,k_b);
    fvert_b = vert(:,k_b);
    
    k_ind_b = k_b;
else
    B_flag = 0;  % indicates a 1-sided derivative will happen
    k_tt = k+2;
    
    ftang_b = tang(:,k_tt);
    fradl_b = radl(:,k_tt);
    fvert_b = vert(:,k_tt);
    
    k_ind_b = k_tt;
end

% ====================== try above ======================
if sum((~isnan(tang(:,k+1)))) > (3*window)
    k_t = k+1;
    
    ftang_t = tang(:,k_t);
    fradl_t = radl(:,k_t);
    fvert_t = vert(:,k_t);
    
    k_ind_t = k_t;
else
    T_flag = 0; % indicates a 1-sided derivative will happen
    
    k_bb = k-2;
    
    ftang_t = tang(:,k_bb);
    fradl_t = radl(:,k_bb);
    fvert_t = vert(:,k_bb);
    
    k_ind_t = k_bb;
end

% ================== radial profile ============================
ftang = tang(:,k);
fradl = radl(:,k);
fvert = vert(:,k);

%% compute all the derivatives

DR = delx*1000;              		% meters
DZ = delz*1000;             		% meters

[d_tang_dr] = ddr(ftang,DR);
[d_radl_dr] = ddr(fradl,DR);
[d_vert_dr] = ddr(fvert,DR);

dwdr(:,k) = d_vert_dr;

[d_tang_dz] = ddz(ftang,ftang_b,ftang_t,DZ,T_flag,B_flag);
[d_radl_dz] = ddz(fradl,fradl_b,fradl_t,DZ,T_flag,B_flag);
[d_vert_dz] = ddz(fvert,fvert_b,fvert_t,DZ,T_flag,B_flag);

%Resolved-scale strain rate tensor components, units of s^-1
Strain(:,k,1,1) = d_radl_dr;
Strain(:,k,1,2) = 0.5*(d_tang_dr - ftang./radius);
Strain(:,k,1,3) = 0.5*(d_radl_dz + d_vert_dr);
Strain(:,k,2,1) = Strain(:,k,1,2);
Strain(:,k,2,2) = fradl./radius;
Strain(:,k,2,3) = 0.5*(d_tang_dz);
Strain(:,k,3,1) = Strain(:,k,1,3);
Strain(:,k,3,2) = Strain(:,k,2,3);
Strain(:,k,3,3) = d_vert_dz;

gradients(:,k,1) = d_tang_dr;
gradients(:,k,2) = d_radl_dr;
gradients(:,k,3) = d_vert_dr;
gradients(:,k,4) = -1*(ftang./radius);
gradients(:,k,5) = fradl./radius;
gradients(:,k,6) = 0.0;
gradients(:,k,7) = d_tang_dz;
gradients(:,k,8) = d_radl_dz;
gradients(:,k,9) = d_vert_dz;

d_radl_dr_mat(:,k) = d_radl_dr;
d_radl_dz_mat(:,k) = d_radl_dz;
d_tang_dr_mat(:,k) = d_tang_dr;
d_tang_dz_mat(:,k) = d_tang_dz;
d_vert_dr_mat(:,k) = d_vert_dr;
d_vert_dz_mat(:,k) = d_vert_dz;

q_bar_sq   = fradl.*fradl+    ftang.*ftang+    fvert.*fvert;

q_bar_sq_b = fradl_b.*fradl_b+ftang_b.*ftang_b+fvert_b.*fvert_b;

q_bar_sq_t = fradl_t.*fradl_t+ftang_t.*ftang_t+fvert_t.*fvert_t;

advection(:,k,1,1) = ddr(q_bar_sq,DR).*fradl;
advection(:,k,1,2) = 0.0;
advection(:,k,1,3) = ddz(q_bar_sq,...
                         q_bar_sq_b,...
                         q_bar_sq_t,DZ,T_flag,B_flag).*fvert;

advection(:,k,2,1) = 0.0;
advection(:,k,2,2) = 0.0;
advection(:,k,2,3) = 0.0;
advection(:,k,3,1) = 0.0;
advection(:,k,3,2) = 0.0;
advection(:,k,3,3) = 0.0;

utau(:,k,1,1) = ddr(Tau(:,k,1,1).*fradl,DR);
utau(:,k,1,2) = -Tau(:,k,2,2).*fradl./radius;
utau(:,k,1,3) = ddz(Tau(:,k,1,3).*fradl,...
                    Tau(:,k_ind_b,1,3).*fradl_b,...
                    Tau(:,k_ind_t,1,3).*fradl_t,DZ,T_flag,B_flag);

utau(:,k,2,1) = ddr(Tau(:,k,2,1).*ftang,DR);
utau(:,k,2,2) = 0.0;
utau(:,k,2,3) = ddz(Tau(:,k,2,3).*ftang,...
                    Tau(:,k_ind_b,2,3).*ftang_b,...
                    Tau(:,k_ind_t,2,3).*ftang_t,DZ,T_flag,B_flag);

utau(:,k,3,1) = ddr(Tau(:,k,3,1).*fvert,DR);
utau(:,k,3,2) = 0.0;
utau(:,k,3,3) = ddz(Tau(:,k,3,3).*fvert,...
                    Tau(:,k_ind_b,3,3).*fvert_b,...
                    Tau(:,k_ind_t,3,3).*fvert_t,DZ,T_flag,B_flag);



end	%condition for good data

end	%height loop
