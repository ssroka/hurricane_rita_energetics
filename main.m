clear;close all;clc

polar = false;

for i = [5]
    switch i
        case 1
            tc_file = 'newiwrap-output-ku1-dz30m-rita9231740.mat';
            pp = 1740;
        case 2
            tc_file = 'newiwrap-output-ku1-dz30m-rita9222030.mat';
            pp = 2030;
        case 3
            tc_file = 'newiwrap-output-ku1-dz30m-rita9222140.mat';
            pp = 2145;
            %%tc_file2 = 'newiwrap-output-ku1-dz30m-rita9222150.mat';pp = 2145; %this represents a small portion of the total leg
        case 4
            tc_file = 'newiwrap-output-ku1-dz30m-rita9232050.mat';
            pp = 2050;
        case 5
            tc_file = 'newiwrap-output-ku1-dz30m-rita9221910.mat';
            pp = 1910;
    end
    
    load(tc_file)
    
    get_rita_data	%module to read iwrap data and create mesh
    
    if ~polar	%across track mean = sector azimuthal mean
        tang2_plot_uvw = squeeze(nanmean(tang2(21,:,:),1));
        radl2_plot_uvw = squeeze(nanmean(radl2(21,:,:),1));
        ww2_plot_uvw = squeeze(nanmean(ww2(21,:,:),1));
        ref2_plot_uvw = squeeze(nanmean(ref2(21,:,:),1));
        
        tang2 = squeeze(nanmean(tang2(20:22,:,:),1));
        radl2 = squeeze(nanmean(radl2(20:22,:,:),1));
        ww2 = squeeze(nanmean(ww2(20:22,:,:),1));
        ref2 = squeeze(nanmean(ref2(20:22,:,:),1));
        radius = squeeze(nanmean(raddis(20:22,:,8),1))*1000;		%radius from storm center vector, m
    end
    
    tang = tang2;
    radl = radl2;
    vert = ww2;
    ref = ref2;
    radius = shiftdim(radius);
    
    if polar
        polargrid
        disp('Done polar grid')
    end
    
    if polar
        filtering_germano
    else
        filtering_germano_azimean
    end
    
    disp('Done SFS Fluxes')
    
    if polar
        calc_strain_rate_tensor
    else
        calc_strain_rate_tensor_azimean
    end
    
    disp('Done Strain')
    
    compute_fwd_back_scatter
    disp('Done Scatter')
    
    calc_pressure_term
    
    % ----- plotting -----
%     plot_velocity_uvw
%     plot_totP_P13_P23
%     plot_totP_LRC
%     plot_LCR_P13_P23
%     plot_1910_P_tau_S_L_C_R
%     plot_adv_utau_Pro
%     plot_velocity
plot_vertical_profiles
    
%     figure(1);set(gcf,'Position',[0 0 1000 200 ])
%     [c,h] = contourf(raddis,zc1,tot_P',-1.0:0.02:1.0);set(h,'edgecolor','none')
%     colorbar;colormap jet
%     caxis([-1 1])
%     xlim([15 55])
%     ylim([0 1.5])
%     xlabel('Radius (km)')
%     ylabel('Height (km)')
%     title('Production of SFS Energy by Resolved Scales (m^2 s^-^2 s^-^1)')
%     
%     hold on
%     contour(raddis,zc1,tot_P',[0,0],'linewidth',2,'linecolor','k')   %adding z
%     
%     figure(2);set(gcf,'Position',[0 0 1000 200 ])
%     [c,h] = contourf(raddis,zc1,tang2',30:1:80);set(h,'edgecolor','none')
%     colorbar;colormap jet
%     xlim([15 55])
%     ylim([0 1.5])
%     xlabel('Radius (km)')
%     ylabel('Height (km)')
%     title('Tangential Winds (m/s)')
%     
%     
%     save('new_mat','tang2','tot_P')
end