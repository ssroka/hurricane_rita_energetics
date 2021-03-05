% %Total sub-filter-scale fluxes, units of m^2 s^-2
% Tau = Leo + Cro + Rey;

%Production of sub-filter-scale energy by resolved scales, units of m^2 s^-2 s^-1 (kinetic energy time tendency)
Pro = -1*(Tau.*Strain);

Ndim = ndims(Pro);
d2 = Ndim - 1;

tot_P = sum(sum(Pro,Ndim),d2);
tot_adv =  sum(sum(advection,Ndim),d2);
tot_utau =  sum(sum(utau,Ndim),d2);

KE_bug_tot_P = -2*tot_P;
KE_bug_uTau = -2*tot_utau;
KE_bug_adv = -tot_adv;
KE_bug_dpdr = -2*pgf_r;
KE_bug_dpdz = -2*pgf_z;
KE_bug_dqdt = KE_bug_adv+KE_bug_dpdr+KE_bug_tot_P;

%%Pforward = 0.5*(tot_P + abs(tot_P));	%positive production of SFS energy, forwardscatter
%%Pbackward = 0.5*(tot_P - abs(tot_P));	%negative production of SFS energy, backscatter

raddis = squeeze(nanmean(raddis(20:22,:,8),1));
raddis = shiftdim(raddis);

raddis(isnan(raddis)) = [];
[raddis,ind] = sort(raddis);
ref2 = ref2(ind,:);
tang2 = tang2(ind,:);
radl2 = radl2(ind,:);
ww2 = ww2(ind,:);
tang2_plot_uvw = tang2_plot_uvw(ind,:);
radl2_plot_uvw = radl2_plot_uvw(ind,:);
ww2_plot_uvw = ww2_plot_uvw(ind,:);
tot_P = tot_P(ind,:);
tot_adv = tot_adv(ind,:);
tot_utau = tot_utau(ind,:);
sfs_radl = sfs_radl(ind,:);
sfs_tang = sfs_tang(ind,:);
sfs_vert = sfs_vert(ind,:);
KE_bug_tot_P = KE_bug_tot_P(ind,:);
KE_bug_uTau = KE_bug_uTau(ind,:);
KE_bug_adv = KE_bug_adv(ind,:);
KE_bug_dpdr = KE_bug_dpdr(ind,:);
KE_bug_dpdz = KE_bug_dpdz(ind,:);
KE_bug_dqdt = KE_bug_dqdt(ind,:);


clear Pro_red Tau_red Strain_red Leo_red Rey_red Cro_red  
clear term1_red term3_red term5_red term7_red term9_red
clear term2_red term4_red term6_red term8_red term10_red
for j = 1:3
    for k= 1:3
        Pro_red(:,:,j,k) = Pro(ind,:,j,k);
        Tau_red(:,:,j,k) = Tau(ind,:,j,k);
        Strain_red(:,:,j,k) = Strain(ind,:,j,k);
        Leo_red(:,:,j,k) = Leo(ind,:,j,k);
        Rey_red(:,:,j,k) = Rey(ind,:,j,k);
        Cro_red(:,:,j,k) = Cro(ind,:,j,k);

        term1_red(:,:,j,k) = term1(ind,:,j,k);
        term2_red(:,:,j,k) = term2(ind,:,j,k);
        term3_red(:,:,j,k) = term3(ind,:,j,k);
        term4_red(:,:,j,k) = term4(ind,:,j,k);
        term5_red(:,:,j,k) = term5(ind,:,j,k);
        term6_red(:,:,j,k) = term6(ind,:,j,k);
        term7_red(:,:,j,k) = term7(ind,:,j,k);
        term8_red(:,:,j,k) = term8(ind,:,j,k);
        term9_red(:,:,j,k) = term9(ind,:,j,k);
        term10_red(:,:,j,k) = term10(ind,:,j,k);
    end
end

d_radl_dr_red = d_radl_dr_mat(ind,:);
d_radl_dz_red = d_radl_dz_mat(ind,:);
d_tang_dr_red = d_tang_dr_mat(ind,:);
d_tang_dz_red = d_tang_dz_mat(ind,:);
d_vert_dr_red = d_vert_dr_mat(ind,:);
d_vert_dz_red = d_vert_dz_mat(ind,:);

if pp == 2050
%Bias was found in aircraft nav (lat/lon coords) so adding this back here
%radius for 9/23/05 @ 2100 utc is 16.2780 km in new IWRAP files and 23.9173 km in HRD files
raddis = raddis + 7.6393;
nrad = repmat(raddis,[1 numel(zc1)]);
miss = nrad<24.1|nrad>55;

elseif pp == 1910
%1910 - 1920 UTC pass needs radius offset for new file
raddis = raddis + 7.1967;
nrad = repmat(raddis,[1 numel(zc1)]);
miss = nrad>35&nrad<38|nrad>57.5;
    miss = false(size(nrad));

elseif pp == 2030
raddis = raddis - 1.4798;
nrad = repmat(raddis,[1 numel(zc1)]);
miss = nrad>26&nrad<31|nrad>53;

elseif pp == 1740

%Bias was found in aircraft nav (lat/lon coords) so adding this back here
raddis = raddis - 1.8040;
nrad = repmat(raddis,[1 numel(zc1)]);
miss = nrad>38&nrad<42;

else
    nrad = repmat(raddis,[1 numel(zc1)]);
    miss = false(size(nrad));

end


ref2(miss) = NaN;
tang2(miss) = NaN;
radl2(miss) = NaN;
ww2(miss) = NaN;
sfs_tang(miss) = NaN;
sfs_vert(miss) = NaN;
sfs_radl(miss) = NaN;
dwdr(miss) = NaN;

tang2_plot_uvw(miss) = NaN;
radl2_plot_uvw(miss) = NaN;
ww2_plot_uvw(miss) = NaN;

tot_P(isnan(tang2)) = NaN;

%{
figure(1);set(gcf,'Position',[0 0 1000 200 ])
[c,h] = contourf(raddis,zc1,tot_P',-1.0:0.02:1.0);set(h,'edgecolor','none')
colorbar;colormap hsv
caxis([-0.5 0.5])
xlim([15 55])
ylim([0 1.5])
xlabel('Radius (km)')
ylabel('Height (km)')
title('Production of SFS Energy by Resolved Scales (m^2 s^-^2 s^-^1)')

hold on
contour(raddis,zc1,tot_P',[0,0],'linewidth',2,'linecolor','k')   %adding z

figure(2);set(gcf,'Position',[0 0 1000 200 ])
[c,h] = contourf(raddis,zc1,tang2',30:1:80);set(h,'edgecolor','none')
colorbar;colormap jet
xlim([15 55])
ylim([0 1.5])
xlabel('Radius (km)')
ylabel('Height (km)')
title('Tangential Winds (m/s)')
%}
