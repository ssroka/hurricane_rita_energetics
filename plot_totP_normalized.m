close all

addpath /Users/ssroka/Documents/MATLAB/util/contourfcmap_dir/contourfcmap
addpath /Users/ssroka/Documents/MATLAB/util/contourfcmap_dir

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
x_ids = (raddis>x_bnds(1)) & (raddis<x_bnds(2));
y_ids = (zc1>y_bnds(1)) & (zc1<y_bnds(2));
tot_P_plot = tot_P';
tot_P_plot(zc1>1.0,:) = NaN;

calc_u_star;
%%
close all
figure(1)
y_star = 1000; % bndry layer height normalization
clim_bnd = 250;
var_plot = (tot_P./(u_star.^3./y_star));
[c,h] = contourf(raddis,zc1,var_plot',[min(var_plot(:)) linspace(-clim_bnd,clim_bnd,100)]);
% [c,h] = contourf(raddis,zc1,Tau_red(:,:,3,3)',-10:0.05:10);
set(h,'edgecolor','none')
set(gca,'clim',[-1 1]*clim_bnd)
editFig(1,x_bnds,y_bnds)
title('$$ \mathcal{P}/(\overline{u_*^3}y_*) $$','interpreter','latex')
for i = 1:length(FB_coords)
    h = text(FB_coords(i),FB_height,FB(i),'fontsize',25);
end
hold on
[c,h1] = contour(raddis,zc1,tot_P_plot,[1 1]*0,'w-','linewidth',3);
set(gcf,'position',[85         343        1195         462])
update_figure_paper_size()
print(sprintf('imgs/totP_div_full_u_star_%d_%d%s',pp,window,mean_rm_str),'-dpdf')
%%
figure(2)

u_star_mean = mean(u_star(x_ids,y_ids),'all');

y_star = 1000; % bndry layer height normalization
clim_bnd = 250;
var_plot = (tot_P./(u_star_mean.^3./y_star));
[c,h] = contourf(raddis,zc1,var_plot',[min(var_plot(:)) linspace(-clim_bnd,clim_bnd,100)]);
% [c,h] = contourf(raddis,zc1,Tau_red(:,:,3,3)',-10:0.05:10);
set(h,'edgecolor','none')
set(gca,'clim',[-1 1]*clim_bnd)
editFig(1,x_bnds,y_bnds)
title(['$$ \mathcal{P}/(\overline{u_*^3}y_*),   u_*= $$',num2str(u_star_mean),',  $$ y_*= $$',num2str(y_star)],'interpreter','latex')
for i = 1:length(FB_coords)
    h = text(FB_coords(i),FB_height,FB(i),'fontsize',25);
end
hold on
[c,h1] = contour(raddis,zc1,tot_P_plot,[1 1]*0,'w-','linewidth',3);
set(gcf,'position',[85         343        1195         462])
update_figure_paper_size()
print(sprintf('imgs/totP_div_mean_u_star_%d_%d%s',pp,window,mean_rm_str),'-dpdf')
%%
figure(3)
y_star = 1000; % bndry layer height normalization
clim_bnd = 3;
var_plot = u_star;
[c,h] = contourf(raddis,zc1,u_star',[min(var_plot(:)) linspace(0,clim_bnd,100)]);
% [c,h] = contourf(raddis,zc1,Tau_red(:,:,3,3)',-10:0.05:10);
set(h,'edgecolor','none')
set(gca,'clim',[0 1]*clim_bnd)
editFig(1,x_bnds,y_bnds)
title('$$ u_* $$','interpreter','latex')
for i = 1:length(FB_coords)
    h = text(FB_coords(i),FB_height,FB(i),'fontsize',25);
end
hold on
[c,h1] = contour(raddis,zc1,tot_P_plot,[1 1]*0,'w-','linewidth',3);
set(gcf,'position',[85         343        1195         462])
update_figure_paper_size()
print(sprintf('imgs/u_star_%d_%d%s',pp,window,mean_rm_str),'-dpdf')



%%
function [] = editFig(n,x_bnds,y_bnds)
if nargin <3
    y_bnds = [0.2 1];
end
if n == 1
    xlim(x_bnds)
    ylim(y_bnds)
    set(gca,'fontsize',20)
    set(gcf,'color','w','position',[85           4        1245         801])
    colorbar
    xlabel('Radius [km]','interpreter','latex')
    ylabel('Height [km]','interpreter','latex')
    
else
    for i = 1:3
        subplot(3,1,i)
        xlim(x_bnds)
        ylim(y_bnds)
        set(gca,'fontsize',20)
        colorbar
        xlabel('Radius [km]','interpreter','latex')
        ylabel('Height [km]','interpreter','latex')
    end
    set(gcf,'color','w','position',[85           4        1245         801])
end
colormap('jet')

end

