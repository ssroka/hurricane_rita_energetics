clear;close all;clc

polar = false;
mean_rm_vec = false;

% plot u,v,w contour plots
plt_uvw = false;

% KE budget figures
plt_vert_prof = false;

% plot set of 6 Strain, 6 P, and 1 norm totP
plt_S_P = false;

% plot LRC tau figure
plt_LRCt = false;

% plot dw/dr
plt_vel = false;

% plot total LRC for reviewer
plt_totLRC = false;

% plot graphical abstract
plt_graphAbs = true;


u_star_mean_global = 0.9598; % mean of u_star from 1910, 2030, 2040
y_star = 2000; % eddy length scale [m]
norm_totP = u_star_mean_global.^3/y_star;
%% Begin

% NOTE: radl, tang, and vert are filtered
% radl2, tang2, and ww2 are unfiltered

if plt_vert_prof
    mean_rm_vec = [false true];
end

for i = [2]
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
    for i_mean_rm = 1:length(mean_rm_vec)
        mean_rm = mean_rm_vec(i_mean_rm);
        load(tc_file)
        
        get_rita_data	%module to read iwrap data and create mesh
        
        if ~polar	%across track mean = sector azimuthal mean
            tang2 = double(tang2);
            radl2 = double(radl2);
            ww2 = double(ww2);
            ref2 = double(ref2);
            raddis = double(raddis);
            
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
        
        if mean_rm
            % removing the r-mean at each vertical level
            %         tang2 = tang2 - repmat(nanmean(tang2),size(tang2,1),1);
            %         radl2 = radl2 - repmat(nanmean(radl2),size(radl2,1),1);
            %         ww2   = ww2   - repmat(nanmean(ww2),size(ww2,1),1);
            %         ref2  = ref2  - repmat(nanmean(ref2),size(ref2,1),1);
            
            % removing the r-z mean
            tang2 = tang2 - nanmean(tang2(:));
            radl2 = radl2 - nanmean(radl2(:));
            ww2   = ww2   - nanmean(ww2(:));
            ref2  = ref2  - nanmean(ref2(:));
            mean_rm_str = '_meanRM';
        else
            mean_rm_str = '';
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
        
        calc_pressure_term
        disp('Done Pressure')
        
        compute_fwd_back_scatter
        disp('Done Scatter')
        
        
        % ----- plotting -----
        if plt_uvw;       plot_velocity_uvw;       end
        
        if plt_vel;       plot_velocity;           end
        
        if plt_vert_prof; plot_vertical_profiles;  end
        
        if plt_LRCt;      plot_LRC_rows;           end
        
        if plt_S_P;       plot_strain_P;           end
        
        if plt_totLRC;    plot_1910_P_tau_S_L_C_R; end
        
        if plt_graphAbs;  plot_graphicalAbstract;  end
        %         plot_totP_normalized % use plot_strain_P
        %         plot_totP_P13_P23 % just to plot the 13 and 23 elements
        %         plot_totP_LRC % 
        %         plot_LCR_P13_P23 % just to plot the 13 and 23 elements
        %         plot_adv_utau_Pro % shows all the terms in their own
        %         subplot
%         calc_u_star
%         u_star_mean
%         
    end
end










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