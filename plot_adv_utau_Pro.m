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
        FB_coords = [39.07 41.07 44.5 46.81];
        FB_height = [0.6];
        line_end = [46.1 0.78; 47.6 0.51];
        %                     line_end = [45.56 0.87; 47.8 0.45];
        
end

tot_P_plot = tot_P';
tot_P_plot(zc1>1.0,:) = NaN;
%%
subplot(3,2,1)
x_inds = (raddis>=x_bnds(1)) & (raddis<=x_bnds(2));
y_inds = (zc1>=y_bnds(1)) & (zc1<=y_bnds(2));
% adv_patch = tot_adv(y_inds,x_inds);
min_adv = min(tot_adv(:));
max_adv = max(tot_adv(:));
[c,h] = contourf(raddis,zc1,KE_bug_adv',[-20:0.5:20]);
set(h,'edgecolor','none')
editFig(1,x_bnds,y_bnds)
colormap('jet')
hold on
[c,h1] = contour(raddis,zc1,KE_bug_tot_P',[1 1]*0,'w-','linewidth',3);

title('$$-\overline{u_j}\frac{\partial}{\partial x_j} \overline{q}^2$$ [m$$^2$$s$$^{-3}$$]','interpreter','latex')
for i = 1:length(FB_coords)
    h = text(FB_coords(i),FB_height,FB(i),'fontsize',25);
end
% update_figure_paper_size()
% print(sprintf('imgs/advection_%d_%d',pp,window),'-dpdf')
%%
subplot(3,2,2)

min_uT = min(-2*tot_utau(:));
max_uT = max(-2*tot_utau(:));
[c,h] = contourf(raddis,zc1,KE_bug_uTau',[-15:0.1:15]);
set(h,'edgecolor','none')
editFig(1,x_bnds,y_bnds)
colormap('jet')
hold on
[c,h1] = contour(raddis,zc1,tot_P_plot,[1 1]*0,'w-','linewidth',3);

title('$$-2\frac{\partial}{\partial x_j} \overline{u_i} \tau_{ij}$$ [m$$^2$$s$$^{-3}$$]','interpreter','latex')
for i = 1:length(FB_coords)
    h = text(FB_coords(i),FB_height,FB(i),'fontsize',25);
end
% update_figure_paper_size()
% print(sprintf('imgs/utau_%d_%d',pp,window),'-dpdf')

%%
subplot(3,2,3)
[c,h] = contourf(raddis,zc1,KE_bug_tot_P',[-1.5:0.01:1.5]);
set(h,'edgecolor','none')
editFig(1,x_bnds,y_bnds)
colormap('jet')
hold on
[c,h1] = contour(raddis,zc1,tot_P_plot,[-1 1]*0.0,'w-','linewidth',3);

title('$$2 \overline{S_{ij}}\tau_{ij}$$ [m$$^2$$s$$^{-3}$$]','interpreter','latex')
for i = 1:length(FB_coords)
    h = text(FB_coords(i),FB_height,FB(i),'fontsize',25);
end
% update_figure_paper_size()
% print(sprintf('imgs/totP_%d_%d',pp,window),'-dpdf')

%%
subplot(3,2,4)
 % pressure term
[c,h] = contourf(raddis,zc1,KE_bug_dpdz',[-1.2:0.01:1.2]);
set(h,'edgecolor','none')
editFig(1,x_bnds,y_bnds)
title('$$ -\frac{2}{\rho}\overline{w}\frac{\partial p}{\partial z}  $$','interpreter','latex')
for i = 1:length(FB_coords)
    h = text(FB_coords(i),FB_height,FB(i),'fontsize',25);
end
hold on
[c,h1] = contour(raddis,zc1,tot_P_plot,[1 1]*0,'w-','linewidth',3);
% update_figure_paper_size()
% print(sprintf('imgs/dpdz_%d_%d',pp,window),'-dpdf')


%%
subplot(3,2,5)
 % pressure term
[c,h] = contourf(raddis,zc1,KE_bug_dpdr',[-1.2:0.01:1.2]);
set(h,'edgecolor','none')
editFig(1,x_bnds,y_bnds)
title('$$ -\frac{2}{\rho}\overline{u}\frac{\partial p}{\partial r}  $$','interpreter','latex')
for i = 1:length(FB_coords)
    h = text(FB_coords(i),FB_height,FB(i),'fontsize',25);
end
hold on
[c,h1] = contour(raddis,zc1,tot_P_plot,[1 1]*0,'w-','linewidth',3);
% update_figure_paper_size()
% print(sprintf('imgs/dpdr_%d_%d',pp,window),'-dpdf')

%%
subplot(3,2,6)

[c,h] = contourf(raddis,zc1,KE_bug_dqdt',[-20:1:20]);
set(h,'edgecolor','none')
editFig(1,x_bnds,y_bnds)
cmap = colormap('jet');
hold on
[c,h1] = contour(raddis,zc1,tot_P_plot,[1 1]*0,'w-','linewidth',3);

title(['$$- \frac{2}{\rho}u\frac{\partial p}{\partial r}+'...
       '- \frac{2}{\rho}w\frac{\partial p}{\partial z}+'...
       '-2\frac{\partial}{\partial x_j}\overline{u_i}\tau_{ij}'...
       '+2 \overline{S_{ij}}\tau_{ij}'...
       '-\overline{u_j}\frac{\partial}{\partial x_j}\overline{q}^2$$ [m$$^2$$s$$^{-3}$$]'],'interpreter','latex')
for i = 1:length(FB_coords)
    h = text(FB_coords(i),FB_height,FB(i),'fontsize',25);
end


update_figure_paper_size()
print(sprintf('imgs/totbudget_%d_%d',pp,window),'-dpdf')



%%
function [] = editFig(n,x_bnds,y_bnds)
if nargin <3
    y_bnds = [0.2 1];
end
if n == 1
    xlim(x_bnds)
    ylim(y_bnds)
    set(gca,'fontsize',15)
    set(gcf,'color','w','position',[85           4        1245         801])
    colorbar
    xlabel('Radius [km]','interpreter','latex')
    ylabel('Height [km]','interpreter','latex')
    
else
    for i = 1:3
        subplot(3,1,i)
        xlim(x_bnds)
        ylim(y_bnds)
        set(gca,'fontsize',15)
        colorbar
        xlabel('Radius [km]','interpreter','latex')
        ylabel('Height [km]','interpreter','latex')
    end
    set(gcf,'color','w','position',[85           4        1245         801])
end
colormap('jet')

end

