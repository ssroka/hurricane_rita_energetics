close all

plot_full_flag = true;


fig_str = {...
    'uvw_velocity_full_w'
    'uvw_velocity_perturb_full'
    'uvw_velocity_crop'
    'uvw_velocity_perturb_crop'
    'Pro_total'
    'Pro_zero_cntr'
    'dvdr'
    'dwdr'
    'dPdr_vert_cntr'
    'dPdr_tang_cntr'
    };
p = 2;
switch p
    case 1
        switch pp
            case 1740
                x_bnds = [23 53];
                y_bnds = [0.3 1];
            case 2030
                x_bnds = [9 52];
                y_bnds = [0.3 1];
            case 2145
                x_bnds = [17 47];
                y_bnds = [0.3 1];
            case 2050
                x_bnds = [24 52];
                y_bnds = [0.3 1];
            case 1910
                x_bnds = [23 55];
                y_bnds = [0.3 1];
                y_bnds = [0.2 1];
        end
    case 2
        switch pp
            case 1740
                x_bnds = [27 36];
                y_bnds = [0.51 0.96];
                eddy_cntr = 52;
                
            case 2030
                x_bnds = [31 45];
                y_bnds = [0.3 0.96];
                eddy_cntr = 61;
                FB = ['BFBF'];
                FB_coords = [35.2 38 41 43.57];
                FB_height = [0.69];
                
            case 2145
                x_bnds = [32 45];
                y_bnds = [0.33 0.9];
                eddy_cntr = 52;
                
            case 2050
                x_bnds = [26 40];
                y_bnds = [0.21 0.96];
                eddy_cntr = 59;
                %                     FB = ['BFBFBF'];
                %                     FB_coords = [26 28 30.2 33.44 34.7 36.2];
                %                     FB_height = [0.33];
                
                FB = [' '];
                FB_coords = [];
                FB_height = [0.33];
                
            case 1910
                x_bnds = [38 54.8];
%                 y_bnds = [0.4 0.96];
%                 y_bnds = [0.2 1.0];
                y_bnds = [0.4 1.0]; % based on reviewer's comments
                eddy_cntr = 55;
                FB = ['BFBF'];
                FB_coords = [39.07 41.07 43.5 46.81];
                FB_height = [0.58];
        end
end

    f_size = 50;
    y_tick_vec = [0.2:0.2:1.0];

if plot_full_flag
%     x_bnds = [23 57.5];

%     y_bnds = [0.1 1.45]; % based on reviewer's comments
    for i = 1:length(fig_str)
        fig_str{i} = [fig_str{i} '_long'];
    end
    f_size = 25;
    y_tick_vec = 0.4:0.2:1;
    tot_P_plot = tot_P';
    tot_P_plot(zc1>1.0,:) = NaN;
    FB_coords = [39.8 41.5 43.5 46.81];

else
    tot_P_plot = tot_P;
end

cb = [-40 5;20 70;-6 6];

figure(1+2*(p-2))
subplot(3,1,1)
plot_rad(raddis,zc1,radl2_plot_uvw,cb(1,:))
for i = 1:length(FB_coords)
    h = text(FB_coords(i),FB_height,FB(i),'fontsize',f_size);
end
hold on
[c,h1] = contour(raddis,zc1,radl2_plot_uvw',[1 1]*0,'k:','linewidth',3);

subplot(3,1,2)
plot_tang(raddis,zc1,tang2_plot_uvw,cb(2,:))
for i = 1:length(FB_coords)
    h = text(FB_coords(i),FB_height,FB(i),'fontsize',f_size);
end


subplot(3,1,3)
plot_vert(raddis,zc1,ww2_plot_uvw,cb(3,:))
editFig(3,x_bnds,y_bnds)
for i = 1:length(FB_coords)
    h = text(FB_coords(i),FB_height,FB(i),'fontsize',f_size);
end


for i = 1:3
    subplot(3,1,i)
    hold on
    [c,h1] = contour(raddis,zc1,tot_P_plot,[1 1]*0,'w-','linewidth',3);
    set(gca,'clim',cb(i,:),'ytick',y_tick_vec)
    for i = 1:length(FB_coords)
        h = text(FB_coords(i),FB_height,FB(i),'fontsize',f_size);
    end
    
end



% 
update_figure_paper_size()
print(sprintf('imgs/%d_%s_%d',pp,fig_str{1},window),'-dpdf')

function [] = editFig(n,x_bnds,y_bnds)
if nargin <3
    y_bnds = [0.2 1];
end
if n == 1
    xlim(x_bnds)
    ylim(y_bnds)
    set(gca,'fontsize',24)
    set(gcf,'color','w','position',[428     4   902   300])
    color
    xlabel('Radius [km]','interpreter','latex')
    ylabel('Height [km]','interpreter','latex')
    
else
    for i = 1:3
        subplot(3,1,i)
        xlim(x_bnds)
        ylim(y_bnds)
        set(gca,'fontsize',24)
        colorbar
        xlabel('Radius [km]','interpreter','latex')
        ylabel('Height [km]','interpreter','latex')
    end
    set(gcf,'color','w','position',[428     4   902   801])
end
colormap('jet')

end

function [] = plot_rad(raddis,zc1,radl2_plot_uvw,cb)
[c,h] = contourf(raddis,zc1,radl2_plot_uvw',cb(1):0.5:cb(2));
set(h,'edgecolor','none')
title('Radial Winds [ms$^{-1}$]','interpreter','latex')
end

function [] = plot_tang(raddis,zc1,tang2_plot_uvw,cb)
[c,h] = contourf(raddis,zc1,tang2_plot_uvw',cb(1):0.25:cb(2));
set(h,'edgecolor','none')
title('Tangential Winds [ms$^{-1}$]','interpreter','latex')
end

function [] = plot_vert(raddis,zc1,ww2_plot_uvw,cb)
[c,h] = contourf(raddis,zc1,ww2_plot_uvw',cb(1):0.25:cb(2));
set(h,'edgecolor','none')
title('Vertical Winds [ms$^{-1}$]','interpreter','latex')
end

function [] = plot_radp(raddis,zc1,radl2_plot_uvw,cb)
[c,h] = contourf(raddis,zc1,radl2_plot_uvw',cb(1):0.1:cb(2));
set(h,'edgecolor','none')
title('Perturbation of the Radial Wind Field  [ms$^{-1}$]','interpreter','latex')
end

function [] = plot_tangp(raddis,zc1,tang2_plot_uvw,cb)
[c,h] = contourf(raddis,zc1,tang2_plot_uvw',cb(1):0.1:cb(2));
set(h,'edgecolor','none')
title('Perturbation of the Tangential Wind Field  [ms$^{-1}$]','interpreter','latex')
end

function [] = plot_vertp(raddis,zc1,ww2_plot_uvw,cb)
[c,h] = contourf(raddis,zc1,ww2_plot_uvw',cb(1):0.1:cb(2));
set(h,'edgecolor','none')
title('Perturbation of the Vertical Wind Field  [ms$^{-1}$]','interpreter','latex')
end

