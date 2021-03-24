close all

fig_str = {...
    'uvw_velocity_full'
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

plot_figs = [6 8];

for p = [1 2]
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
            end
        case 2
            switch pp
                case 1740
                    x_bnds = [27 36];
                    y_bnds = [0.51 1];
                    eddy_cntr = 52;
                    
                case 2030
                    x_bnds = [31 45];
                    y_bnds = [0.3 1];
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
                    y_bnds = [0.21 1];
                    eddy_cntr = 59;
                    %                     FB = ['BFBFBF'];
                    %                     FB_coords = [26 28 30.2 33.44 34.7 36.2];
                    %                     FB_height = [0.33];
                    
                    FB = [' '];
                    FB_coords = [];
                    FB_height = [0.42];
                    FB = ['BFBF'];
                    FB_coords = [26.4 28 30.44 33.7];
                    
                case 1910
                    x_bnds = [38 54.8];
                    y_bnds = [0.4 1];
                    eddy_cntr = 55;
                    FB = ['BFBF'];
                    %                     FB_coords = [39.07 41.07 43.31 46.81];
                    %                     FB_coords = [39 41 43 45];
                    %                     FB_height = [0.69];
%                     FB_coords = [39.07 41.07 44.5 46.81];
                    FB_coords = [39.07 41.07 43.5 46.81];
                    FB_height = [0.6];
                    line_end = [46.1 0.78; 47.6 0.51];
%                     line_end = [45.56 0.87; 47.8 0.45];

            end
    end
    
    
    if ismember(2+2*(p-1),plot_figs)
        figure(2+2*(p-1))
        subplot(3,1,1)
        plot_radp(raddis,zc1,sfs_radl)
        
        subplot(3,1,2)
        plot_tangp(raddis,zc1,sfs_tang)
        
        subplot(3,1,3)
        plot_vertp(raddis,zc1,sfs_vert)
        editFig(3,x_bnds,y_bnds)
    end
    if p == 2 % only plot the section version
        if ismember(1+2*(p-2),plot_figs)
            figure(1+2*(p-2))
            subplot(3,1,1)
            plot_rad(raddis,zc1,radl2)
            for i = 1:length(FB_coords)
                h = text(FB_coords(i),FB_height,FB(i),'fontsize',50);
            end
            
            subplot(3,1,2)
            plot_tang(raddis,zc1,tang2)
            for i = 1:length(FB_coords)
                h = text(FB_coords(i),FB_height,FB(i),'fontsize',50);
            end
            
            subplot(3,1,3)
            plot_vert(raddis,zc1,ww2)
            editFig(3,x_bnds,y_bnds)
            for i = 1:length(FB_coords)
                h = text(FB_coords(i),FB_height,FB(i),'fontsize',50);
            end
        end
        
        if ismember(5,plot_figs)
            figure(5)
            [c,h] = contourf(raddis,zc1,tot_P',[-1:0.1:1]);
            set(h,'edgecolor','none')
            editFig(1,x_bnds,y_bnds)
            title('Production of SFS Energy by Resolved Scales (m^2 s^-^2 s^-^1)')
            
        end
        if ismember(6,plot_figs)
            figure(6)
            [c,h] = contourf(raddis,zc1,tot_P',[-1:0.01:1]);
            set(h,'edgecolor','none')
            hold on
            if pp == 1910
                plot(line_end(:,1),line_end(:,2),'-','linewidth',6,'color',[1 1 1]*0.6)
%                 plot(star_loc(:,1),star_loc(:,2),'p','markeredgecolor','k','markerfacecolor','m','markersize',25)
            end
            [c,hL] = contour(raddis,zc1,tot_P',[0 0],'w-','linewidth',3);
            for i = 1:length(FB_coords)
                h = text(FB_coords(i),FB_height,FB(i),'fontsize',50);
            end
            %         [c,hH] = contour(raddis,zc1,sfs_tang',[2 2],'k--','linewidth',1);
            editFig(1,x_bnds,y_bnds)
            caxis([-1 1])
            title(sprintf('$$\\mathcal{P}y_*/(u_*^3) $$',pp),'interpreter','latex')
            
            %             [c,h1] = contour(raddis,zc1,tot_P',[1 1]*0.27,'b-','linewidth',3);
            %             [c,h1] = contour(raddis,zc1,tot_P',[1 1]*-0.27,'m-','linewidth',3);
        end
    end
end

% dv/dr

dvdr =  (sfs_tang(2:end,:)'-sfs_tang(1:end-1,:)')./repmat(diff(raddis(:))',length(zc1),1);

tot_P_cntr = [-0.015 0 0.015];
%% dw/dr
if ismember(7,plot_figs)
    figure(7)
    
    x_inds = (raddis>=x_bnds(1)) & (raddis<=x_bnds(2));
    y_inds = (zc1>=y_bnds(1)) & (zc1<=y_bnds(2));
    dvdr_patch = dvdr(y_inds,x_inds);
    min_dvdr = min(dvdr_patch(:));
    max_dvdr = max(dvdr_patch(:));
    [c,h] = contourf(raddis(x_inds),zc1(y_inds),dvdr_patch,[min_dvdr -10:2:10 max_dvdr]);
    set(h,'edgecolor','none')
    editFig(1,x_bnds,y_bnds)
    colormap('jet')
    hold on
    [c,h1] = contour(raddis,zc1,tot_P',[0 0]*tot_P_cntr(1),'w-','linewidth',3);
    % [c,h2] = contour(raddis,zc1,tot_P',[1 1]*tot_P_cntr(2),'k-','linewidth',3);
    legend([h1],sprintf('totP = %g',tot_P_cntr(1)))
    title('$$\partial w/\partial r$$ [s$$^{-1}$$]','interpreter','latex')
    for i = 1:length(FB_coords)
        h = text(FB_coords(i),FB_height,FB(i),'fontsize',50);
    end
end
% 
%% dw/dz
if ismember(71,plot_figs)
    figure(71)
    
    x_inds = (raddis>=x_bnds(1)) & (raddis<=x_bnds(2));
    y_inds = (zc1>=y_bnds(1)) & (zc1<=y_bnds(2));
    dvdr_patch = dvdz(y_inds,x_inds);
    min_dvdr = min(dvdr_patch(:));
    max_dvdr = max(dvdr_patch(:));
    [c,h] = contourf(raddis(x_inds),zc1(y_inds),dvdr_patch,[min_dvdr -10:2:10 max_dvdr]);
    set(h,'edgecolor','none')
    editFig(1,x_bnds,y_bnds)
    colormap('jet')
    hold on
    [c,h1] = contour(raddis,zc1,tot_P',[0 0]*tot_P_cntr(1),'w-','linewidth',3);
    % [c,h2] = contour(raddis,zc1,tot_P',[1 1]*tot_P_cntr(2),'k-','linewidth',3);
    legend([h1],sprintf('totP = %g',tot_P_cntr(1)))
    title('$$\partial \overline{w}/\partial r$$ [s$$^{-1}$$]','interpreter','latex')
    for i = 1:length(FB_coords)
        h = text(FB_coords(i),FB_height,FB(i),'fontsize',50);
    end
end

%%
if ismember(81,plot_figs)
    dwdr =  (sfs_vert(2:end,:)'-sfs_vert(1:end-1,:)')./repmat(diff(raddis(:))',length(zc1),1);
    % dwdr =  (ww2(2:end,:)'-ww2(1:end-1,:)')./repmat(diff(raddis(:))',length(zc1),1);
    
    % dwdr = dwdr1-dwdr2;
    
    figure(81)
    x_inds = (raddis>=x_bnds(1)) & (raddis<=x_bnds(2));
    y_inds = (zc1>=y_bnds(1)) & (zc1<=y_bnds(2));
    dwdr_patch = dwdr(y_inds,x_inds);
    min_dwdr = min(dwdr_patch(:));
    max_dwdr = max(dwdr_patch(:));
    [c,h] = contourf(raddis(x_inds),zc1(y_inds),dwdr_patch,[min_dwdr -10:.2:10 max_dwdr]);
    set(h,'edgecolor','none')
    editFig(1,x_bnds,y_bnds)
    colormap('jet')
    hold on
    [c,h1] = contour(raddis,zc1,tot_P',[0 0]*tot_P_cntr(1),'w-','linewidth',3);
    title('$$ SFS vert \overline{w}/\partial r$$ [1/s]','interpreter','latex')
    for i = 1:length(FB_coords)
        h = text(FB_coords(i),FB_height,FB(i),'fontsize',50);
    end
    set(gca,'xtick',[40 45 50])

end
if ismember(8,plot_figs)
    % dwdr1 =  (sfs_vert(2:end,:)'-sfs_vert(1:end-1,:)')./repmat(diff(raddis(:))',length(zc1),1);
    %     dwdr =  (ww2(3:end,:)'-ww2(1:end-2,:)')./repmat(diff(raddis(:))',length(zc1),1);
    [dwdr] = CD(repmat(raddis(:)',length(zc1),1),ww2');
    % dwdr = dwdr1-dwdr2;
    
    figure(8)
    x_inds = (raddis>=x_bnds(1)) & (raddis<=x_bnds(2));
    y_inds = (zc1>=y_bnds(1)) & (zc1<=y_bnds(2));
    dwdr_patch = dwdr(y_inds,x_inds);
    min_dwdr = min(dwdr_patch(:));
    max_dwdr = max(dwdr_patch(:));
    [c,h] = contourf(raddis(x_inds),zc1(y_inds),dwdr_patch,[min_dwdr -10:.2:10 max_dwdr]);
    set(h,'edgecolor','none')
    editFig(1,x_bnds,y_bnds)
    colormap('jet')
    hold on
    if pp == 1910
        plot(line_end(:,1),line_end(:,2),'-','linewidth',6,'color',[1 1 1]*0.6)
%         plot(star_loc(:,1),star_loc(:,2),'p','markeredgecolor','k','markerfacecolor','m','markersize',25)
    end
    [c,h1] = contour(raddis,zc1,tot_P',[0 0]*tot_P_cntr(1),'w-','linewidth',3);
    %     [c,h1] = contour(raddis,zc1,tot_P',[1 1]*0.27,'b-','linewidth',3);
    %     [c,h1] = contour(raddis,zc1,tot_P',[1 1]*-0.27,'m-','linewidth',3);
    title('$$\partial \overline{w}/\partial r$$ [s$$^{-1}$$]','interpreter','latex')
    for i = 1:length(FB_coords)
        h = text(FB_coords(i),FB_height,FB(i),'fontsize',50);
    end
        set(gca,'xtick',[40 45 50])

end

if ismember(83,plot_figs)
    % dwdr1 =  (sfs_vert(2:end,:)'-sfs_vert(1:end-1,:)')./repmat(diff(raddis(:))',length(zc1),1);
    dwdr =  (d_vert_dr_red(2:end,:)'-d_vert_dr_red(1:end-1,:)')./repmat(diff(raddis(:))',length(zc1),1);
    
    % dwdr = dwdr1-dwdr2;
    
    figure(83)
    x_inds = (raddis>=x_bnds(1)) & (raddis<=x_bnds(2));
    y_inds = (zc1>=y_bnds(1)) & (zc1<=y_bnds(2));
    dwdr_patch = dwdr(y_inds,x_inds);
    min_dwdr = min(dwdr_patch(:));
    max_dwdr = max(dwdr_patch(:));
    [c,h] = contourf(raddis(x_inds),zc1(y_inds),dwdr_patch,[min_dwdr -10:.2:10 max_dwdr]);
    set(h,'edgecolor','none')
    editFig(1,x_bnds,y_bnds)
    colormap('jet')
    hold on
    [c,h1] = contour(raddis,zc1,tot_P',[0 0]*tot_P_cntr(1),'w-','linewidth',3);
    title('$$ from strain term \partial \overline{w}/\partial r$$ [1/s]','interpreter','latex')
    for i = 1:length(FB_coords)
        h = text(FB_coords(i),FB_height,FB(i),'fontsize',50);
    end
    set(gca,'xtick',[40 45 50])
end
%%
% d totP /dr
if ismember(9,plot_figs)
    dtotPdr =  (tot_P(2:end,:)'-tot_P(1:end-1,:)')./repmat(diff(raddis(:))',length(zc1),1);
    
    figure(9)
    x_inds = (raddis>=x_bnds(1)) & (raddis<=x_bnds(2));
    y_inds = (zc1>=y_bnds(1)) & (zc1<=y_bnds(2));
    dtotPdr_patch = dtotPdr(y_inds,x_inds);
    min_dtotPdr = min(dtotPdr_patch(:));
    max_dtotPdr = max(dtotPdr_patch(:));
    [c,h] = contourf(raddis(x_inds),zc1(y_inds),dtotPdr_patch,[min_dtotPdr -1:0.1:1 max_dtotPdr]);
    set(h,'edgecolor','none')
    editFig(1,x_bnds,y_bnds)
    colormap('parula')
    hold on
    [c,h1] = contour(raddis,zc1,sfs_vert',[1 1]*-0.75,'w-','linewidth',3);
    [c,h2] = contour(raddis,zc1,sfs_vert',[1 1]*0,'k-','linewidth',3);
    legend([h1 h2],sprintf('w'' = %g',-0.75),...
        sprintf('w'' = %g',0))
    title('$$\partial \mathcal{P}/\partial r$$ ','interpreter','latex')
end
% d totP /dr
if ismember(10,plot_figs)
    
    dtotPdr =  (tot_P(2:end,:)'-tot_P(1:end-1,:)')./repmat(diff(raddis(:))',length(zc1),1);
    
    figure(10)
    x_inds = (raddis>=x_bnds(1)) & (raddis<=x_bnds(2));
    y_inds = (zc1>=y_bnds(1)) & (zc1<=y_bnds(2));
    dtotPdr_patch = dtotPdr(y_inds,x_inds);
    min_dtotPdr = min(dtotPdr_patch(:));
    max_dtotPdr = max(dtotPdr_patch(:));
    [c,h] = contourf(raddis(x_inds),zc1(y_inds),dtotPdr_patch,[min_dtotPdr -1:0.1:1 max_dtotPdr]);
    set(h,'edgecolor','none')
    editFig(1,x_bnds,y_bnds)
    colormap('parula')
    hold on
    [c,h1] = contour(raddis,zc1,sfs_tang',[1 1]*-0.5,'w-','linewidth',3);
    [c,h2] = contour(raddis,zc1,sfs_tang',[1 1]*0,'k-','linewidth',3);
    legend([h1 h2],sprintf('v'' = %g',-0.75),...
        sprintf('v'' = %g',0))
    title('$$\partial \mathcal{P}/\partial r$$ ','interpreter','latex')
end

for i = 1:10
    if ~ismember(i,plot_figs)
        continue
    end
    figure(i)
    % uncomment to print
%     update_figure_paper_size()
%     print(sprintf('imgs/%d_%s_%d%s',pp,fig_str{i},window,mean_rm_str),'-dpdf')
end

function [] = editFig(n,x_bnds,y_bnds)
if nargin <3
    y_bnds = [0.2 1];
end
if n == 1
    xlim(x_bnds)
    ylim(y_bnds)
    set(gca,'fontsize',24)
    set(gcf,'color','w','position',[428     4   902   300])
    colorbar
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

function [] = plot_rad(raddis,zc1,radl2)
[c,h] = contourf(raddis,zc1,radl2',-40:1:1);
set(h,'edgecolor','none')
title('Radial Winds [m/s]','interpreter','latex')
end

function [] = plot_tang(raddis,zc1,tang2)
[c,h] = contourf(raddis,zc1,tang2',30:1:80);
set(h,'edgecolor','none')
title('Tangential Winds [m/s]','interpreter','latex')
end

function [] = plot_vert(raddis,zc1,ww2)
[c,h] = contourf(raddis,zc1,ww2',-8:1:10);
set(h,'edgecolor','none')
title('Vertical Winds [m/s]','interpreter','latex')
end

function [] = plot_radp(raddis,zc1,radl2)
[c,h] = contourf(raddis,zc1,radl2',-10:0.1:10);
set(h,'edgecolor','none')
title('Perturbation of the Radial Wind Field  [m/s]','interpreter','latex')
end

function [] = plot_tangp(raddis,zc1,tang2)
[c,h] = contourf(raddis,zc1,tang2',-10:0.1:10);
set(h,'edgecolor','none')
title('Perturbation of the Tangential Wind Field  [m/s]','interpreter','latex')
end

function [] = plot_vertp(raddis,zc1,ww2)
[c,h] = contourf(raddis,zc1,ww2',-10:0.1:10);
set(h,'edgecolor','none')
title('Perturbation of the Vertical Wind Field  [m/s]','interpreter','latex')
end

function [dydx] = CD(x_grid,y_grid)
dydx = zeros(size(y_grid));
for i = 1:size(x_grid,1)
    dydx(i,1) = (y_grid(i,2)-y_grid(i,1))/(x_grid(i,2)-x_grid(i,1));
    dydx(i,end) = (y_grid(i,end)-y_grid(i,end-1))/(x_grid(i,end)-x_grid(i,end-1));
    dydx(i,2:end-1) =  (y_grid(i,3:end)-y_grid(i,1:end-2))./(x_grid(i,3:end)-x_grid(i,1:end-2));
end

end
