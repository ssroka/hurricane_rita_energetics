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
        FB_clr = ['kkkk'];

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
               FB_clr = ['wkwk'];

    case 1910
        x_bnds = [38 54.8];
        y_bnds = [0.4 1];

        eddy_cntr = 55;
        FB = ['BFBF'];
        %                     FB_coords = [39.07 41.07 43.31 46.81];
        %                     FB_coords = [39 41 43 45];
        %                     FB_height = [0.69];
%         FB_coords = [39.07 41.07 44.5 46.81];
        FB_coords = [39.07 41.07 43.5 46.81];
        
        FB_height = [0.6];
        line_end = [45.5 0.81; 47.8 0.48];
       FB_clr = ['kkkk'];
        %                     line_end = [45.56 0.87; 47.8 0.45];
        
end

P_clim_mag = 1000;

 P_cntr = P_clim_mag*[0.08 NaN NaN
            0.04 0.016 NaN
            0.35 0.2 0.15]';
        
x_ids = (raddis>x_bnds(1)) & (raddis<x_bnds(2));
y_ids = (zc1>y_bnds(1)) & (zc1<y_bnds(2));
tot_P_plot = tot_P';
tot_P_plot(zc1>1.0,:) = NaN;


%% normalizing quantities

calc_u_star; % calculates u_star_mean 

% eddy length scale
y_star = 2e3; % m or 2km which is the typical eddy length scale


u_star_mean
%%
close all
figure(1)
clim_bnd = P_clim_mag;
var_plot = (tot_P./(u_star_mean.^3./y_star));
[c,h] = contourf(raddis,zc1,var_plot',[min(var_plot(:)) linspace(-clim_bnd,clim_bnd,150)]);
hold on
if pp == 1910
plot(line_end(:,1),line_end(:,2),'-','linewidth',6,'color',[1 1 1]*0.6)
end
% [c,h] = contourf(raddis,zc1,Tau_red(:,:,3,3)',-10:0.05:10);
set(h,'edgecolor','none')
set(gca,'clim',[-1 1]*clim_bnd,'ytick',[0.4:0.2:1])
editFig(1,x_bnds,y_bnds)
title('$$ \mathcal{P}\hspace*{1mm}y_*/u_*^3 $$','interpreter','latex')
h = text(FB_coords(1),FB_height,FB(1),'fontsize',30,'color',FB_clr(1));
for i = 2:length(FB_coords)
    h = text(FB_coords(i),FB_height,FB(i),'fontsize',30,'color',FB_clr(1));
end
hold on
[c,h1] = contour(raddis,zc1,tot_P_plot,[1 1]*0,'w-','linewidth',3);
set(gcf,'color','w','position',[428     4   902   300])

% uncomment to print
% update_figure_paper_size()
% print(sprintf('imgs/totP_norm_%d_%d%s',pp,window,mean_rm_str),'-dpdf')

%%

figure(2)
sum_P_2_plot = tot_P(x_ids,y_ids)'./(u_star_mean.^3./y_star);

vars = {Pro_red./(u_star_mean.^3./y_star)};
titles = {'\mathcal{P}'};
units = {'[]'};
fig_name = {'P'};
vars_clim_cell = {P_cntr};

for k = 1
    count = 1;
    var = vars{k};
    var_clim = vars_clim_cell{k};
    for j = 1:3
        for i = 1:j
            subplot(3,2,count)
            Pro_2_plot = var(x_ids,y_ids,i,j)';
            plot_cntr(raddis(x_ids),zc1(y_ids),Pro_2_plot,x_bnds,y_bnds,var_clim(i,j))
            cor_coef = corr(sum_P_2_plot(:),Pro_2_plot(:),'rows','complete');
            hold on
            [c,hL] = contour(raddis(x_ids),zc1(y_ids),Pro_2_plot,[0 0],'w-','linewidth',3);
            title(sprintf('$$%s_{%d %d}\\hspace*{1mm}y_*/u_*^3$$, c = %3.2f',titles{k},i,j,cor_coef),'interpreter','latex')
            count = count + 1;
            set(gca,'ylim',[0.4 1])
        end
    end
    set(gcf,'color','w','position',[7          41        1396         764])

end

% uncomment to print
% update_figure_paper_size()
% print(sprintf('imgs/P_norm_%d_%d%s',pp,window,mean_rm_str),'-dpdf')


figure(2)
sum_P_2_plot = tot_P(x_ids,y_ids)'./(u_star_mean.^3./y_star);

vars = {Pro_red./(u_star_mean.^3./y_star),Strain_red};
titles = {'\mathcal{P}','\widetilde{\overline{S}}'};
units = {'[]','[s$$^{-1}$$]'};
fig_name = {'P'};
vars_clim_cell = {P_cntr};

for k = 1:2
    count = 1;
    var = vars{k};
    var_clim = vars_clim_cell{k};
    for j = 3
        for i = 1:2
            subplot(2,2,count)
            Pro_2_plot = var(x_ids,y_ids,i,j)';
            plot_cntr(raddis(x_ids),zc1(y_ids),Pro_2_plot,x_bnds,y_bnds,var_clim(i,j))
            cor_coef = corr(sum_P_2_plot(:),Pro_2_plot(:),'rows','complete');
            hold on
            [c,hL] = contour(raddis(x_ids),zc1(y_ids),Pro_2_plot,[0 0],'w-','linewidth',3);
            title(sprintf('$$%s_{%d %d}\\hspace*{1mm}y_*/u_*^3$$, c = %3.2f',titles{k},i,j,cor_coef),'interpreter','latex')
            count = count + 1;
            set(gca,'ylim',[0.4 1])
            
            subplot(2,2,count)
            Pro_2_plot = var(x_ids,y_ids,i,j)';
            plot_cntr(raddis(x_ids),zc1(y_ids),Pro_2_plot,x_bnds,y_bnds,var_clim(i,j))
            cor_coef = corr(sum_P_2_plot(:),Pro_2_plot(:),'rows','complete');
            hold on
            [c,hL] = contour(raddis(x_ids),zc1(y_ids),Pro_2_plot,[0 0],'w-','linewidth',3);
            title(sprintf('$$%s_{%d %d}\\hspace*{1mm}y_*/u_*^3$$, c = %3.2f',titles{k},i,j,cor_coef),'interpreter','latex')
            count = count + 1;
            set(gca,'ylim',[0.4 1])            
        end
    end
    set(gcf,'color','w','position',[7          41        1396         764])

end
% uncomment to print
% update_figure_paper_size()
% print(sprintf('imgs/P_norm_S_13_23_%d_%d%s',pp,window,mean_rm_str),'-dpdf')


%%
%{
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
% uncomment to print
% update_figure_paper_size()
% print(sprintf('imgs/totP_div_mean_u_star_%d_%d%s',pp,window,mean_rm_str),'-dpdf')
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
% uncomment to print
% update_figure_paper_size()
% print(sprintf('imgs/u_star_%d_%d%s',pp,window,mean_rm_str),'-dpdf')

%}

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

function [] = plot_cntr(raddis,zc1,tot_P,x_bnds,y_bnds,c_bnd,n_lvl)
% c2 = prctile(tot_P(:),[5 95]);

if (nargin >6) & ~isnan(c_bnd)
        c = [-1 1]*c_bnd;
        [~,h] = contourf(raddis,zc1,tot_P,[min(tot_P(:)) linspace(c(1),c(2),n_lvl)]);
    
elseif (nargin >5) & ~isnan(c_bnd)
    c = [-1 1]*c_bnd;
    [~,h] = contourf(raddis,zc1,tot_P,[min(tot_P(:)) linspace(c(1),c(2),40)]);
    
else
    [~,h] = contourf(raddis,zc1,tot_P);
    
    current_clim = get(gca,'clim');
    current_LL = get(h,'levellist');
    
    if length(current_LL)>1
        set(h,'levellist',[linspace(current_LL(1),current_LL(end),15)])
    end
    c = [-1 1]*min(max(abs(current_clim)),20);
end
colorbar
colormap('jet')
% set(h,'edgecolor',[0.5 0.5 0.5])
set(h,'edgecolor','none')
xlabel('Radius [km]','interpreter','latex')
ylabel('Height [km]','interpreter','latex')
set(gca,'ylim',y_bnds,'xlim',x_bnds,'clim',c,'fontsize',20)
%,'clim',[-1 1]*max(abs(current_clim)),'fontsize',25)
end


