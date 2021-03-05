close all

% switch pp
%     case 1740
%         x_bnds = [23 53];
%         y_bnds = [0.3 1];
%     case 2030
%         x_bnds = [9 52];
%         y_bnds = [0.3 1];
%     case 2145
%         x_bnds = [17 47];
%         y_bnds = [0.3 1];
%     case 2050
%         x_bnds = [24 52];
%         y_bnds = [0.3 1];
%     case 1910
%         x_bnds = [23 55];
%         y_bnds = [0.3 1];
% end
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
                cntr_bnds = [34.5 37;36 40;40 42; 42 44];

        
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
                cntr_bnds = [26 27.5;27 29;29 32.7; 32.7 35];

        
    case 1910
        x_bnds = [38 54.8];
        y_bnds = [0.4 1];
        eddy_cntr = 55;
        FB = ['BFBF'];
        %                     FB_coords = [39.07 41.07 43.31 46.81];
        %                     FB_coords = [39 41 43 45];
        %                     FB_height = [0.69];
        FB_coords = [39.07 41.07 44.5 46.81];
        FB_height = [0.6];
        line_end = [46.1 0.78; 47.6 0.51];
        %                     line_end = [45.56 0.87; 47.8 0.45];
        cntr_bnds = [38 42;40 43;41 47; 44 49];
end

tot_P_plot = tot_P';
tot_P_plot(zc1>1.0,:) = NaN;

%%
figure(1)
for i = 1:size(cntr_bnds,1)
    if strcmp(FB(i),'B')
        s = -1;
    else
        s = 1;
    end
    subplot(2,2,i)
    r_ind_min = find(raddis > cntr_bnds(i,1),1,'first');
    r_ind_max = find(raddis < cntr_bnds(i,2),1,'last');
    P_inds = s*tot_P>0;
    
    eddy_inds = false(size(tot_P));
    % mark the region that bounds the current eddy true
    eddy_inds(r_ind_min:r_ind_max,:) = true;
    % only keep the parts of the eddy, and change to 1's and 0's so that NaN assignment can work
    eddy_inds = double(eddy_inds & P_inds);
    % change zeros to NaN so that nanmean works
    eddy_inds(eddy_inds==0) = NaN;
    
    % do a radial average, recall before transposing, 
    % radius changes down the rows
    tot_P_mean_prof = nanmean(KE_bug_tot_P.*eddy_inds);
    uTau_mean_prof  = nanmean(KE_bug_uTau.*eddy_inds);
    adv_mean_prof   = nanmean(KE_bug_adv.*eddy_inds);
    dpdr_mean_prof  = nanmean(KE_bug_dpdr.*eddy_inds);
    dpdz_mean_prof  = nanmean(KE_bug_dpdz.*eddy_inds);
    dqdt_mean_prof  = nanmean(KE_bug_dpdr.*eddy_inds);
    
    
    plot(dpdr_mean_prof,zc1,'linewidth',2,'displayname','$$-\frac{2}{\rho}u\frac{\partial p}{\partial r}$$');
    hold on
    plot(dpdz_mean_prof,zc1,'linewidth',2,'displayname','$$-\frac{2}{\rho}u\frac{\partial p}{\partial z}$$');
    plot(uTau_mean_prof,zc1,'linewidth',2,'displayname','$$-2\frac{\partial}{\partial x_j}\overline{u_i}\tau_{ij}$$');
    plot(adv_mean_prof,zc1,'linewidth',2,'displayname','$$-\overline{u_j}\frac{\partial}{\partial x_j}\overline{q}^2$$');
    plot(tot_P_mean_prof,zc1,'linewidth',2,'displayname','$$2 \overline{S_{ij}}\tau_{ij}$$');

    ylim(y_bnds)
    set(gca,'fontsize',24)
    ylabel('Height [km]','interpreter','latex')
    legend('location','eastoutside','interpreter','latex')
    title(sprintf('%d: %s eddy at %2.1f',pp,FB(i),mean(cntr_bnds(i,:))))
end
set(gcf,'color','w','position',[64           4        1266         791])
update_figure_paper_size()
print(sprintf('imgs/componsite_contours_%d_%d',pp,window),'-dpdf')

%%
figure(2)
[c,h] = contourf(raddis,zc1,2*(-tot_P)',[-1.5:0.01:1.5]);
set(h,'edgecolor','none')
editFig(1,x_bnds,y_bnds)
colormap('jet')
hold on
[c,h1] = contour(raddis,zc1,2*-tot_P_plot,[-1 1]*0.0,'w-','linewidth',3);

title('$$2 \overline{S_{ij}}\tau_{ij}$$ [m$$^2$$s$$^{-3}$$]','interpreter','latex')
for i = 1:length(FB_coords)
    h = text(FB_coords(i),FB_height,FB(i),'fontsize',50);
end
%%
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

