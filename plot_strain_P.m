close all;clc

switch pp
    case 1740
        x_bnds = [27 36];
        y_bnds = [0.6 1];
        
    case 2030
        x_bnds = [31 45];
        y_bnds = [0.3 1];
        
        
        S_cntr = [7e-3 NaN NaN
            5e-3 5e-4 NaN
            0.06 0.12 0.05]';
        P_cntr = [0.2 NaN NaN
            0.04 0.016 NaN
            0.35 0.2 0.15]';
                FB_coords = [35.2 38 41 43.57];
        FB_height = [0.69];
                FB = ['BFBF'];
        FB_clr = ['wkwk'];


    case 2145
        x_bnds = [32 45];
        y_bnds = [0.6 1];
        
    case 2050
        x_bnds = [26 40];
        y_bnds = [0.3 1];
        
        S_cntr = [7e-3 NaN NaN
            5e-3 5e-4 NaN
            0.06 0.12 0.05]';
        P_cntr = [0.2 NaN NaN
            0.04 0.016 NaN
            0.35 0.15 0.15]';
                FB_coords = [26.4 28 30.44 33.7];
        FB_height = [0.42];
                FB = ['BFBF'];

               FB_clr = ['wkwk'];

    case 1910
        x_bnds = [38 54];
        y_bnds = [0.4 1];
        
    
        tau_cntr = [25 NaN NaN
            25 25 NaN
            7 6 10]';
        
        %         L_cntr = [5 NaN NaN
        %                   2 NaN NaN
        %                   1 1.5 1];
        L_cntr = [8 NaN NaN
            8 8 NaN
            3.5 3.5 1]';
        R_cntr = [20 NaN NaN
            10 20 NaN
            5.5 5 6]';
        C_cntr = [7 NaN NaN
            7 11 NaN
            2.5 1.5 3]';
                line_end = [45.5 0.81; 47.8 0.48];
        FB_coords = [39.07 41.07 43.5 46.81];
        FB_height = [0.6];
                FB = ['BFBF'];
       FB_clr = ['wkkk'];


end
S_cntr = [7e-3 NaN NaN
            5e-3 5e-4 NaN
            0.06 0.05 0.05]';
P_cntr = [0.2 NaN NaN
            0.04 0.016 NaN
            0.4 0.4 0.3]';

P_clim_mag = 1200/(u_star_mean_global^3);
P_cntr = P_clim_mag*P_cntr;

x_ids = (raddis>x_bnds(1)) & (raddis<x_bnds(2));
y_ids = (zc1>y_bnds(1)) & (zc1<y_bnds(2));

tot_P_plot = tot_P';
tot_P_plot(zc1>1.0,:) = NaN;


subplot_inds = reshape(1:9,3,3)';% because subplot doesn't go in column major order
%% normalizing quantities
% 
% calc_u_star; % calculates u_star_mean 
% 
% % eddy length scale
% y_star = 2e3; % m or 2km which is the typical eddy length scale


%%
sum_P_2_plot = tot_P(x_ids,y_ids)';

vars = {Strain_red,Pro_red./norm_totP};
titles = {'\widetilde{\overline{S}}','\mathcal{P}'};
units = {'[s$$^{-1}$$]',...
         ''};
norm_str = {'','y_*/u_*^3'};
fig_name = {'S','P'};
vars_clim_cell = {S_cntr,P_cntr};

for k = 1:2
    count = 1;
    var = vars{k};
    figure(k)
    var_clim = vars_clim_cell{k};
    for j = 1:3
        for i = 1:j
            %             if (i==2) && (j==2)
            %                 continue
            %             end
            subplot(3,2,count)
            Pro_2_plot = var(x_ids,y_ids,i,j)';
            plot_cntr(raddis(x_ids),zc1(y_ids),Pro_2_plot,x_bnds,y_bnds,var_clim(i,j))
            cor_coef = corr(sum_P_2_plot(:),Pro_2_plot(:),'rows','complete');
            hold on
            [c,hL] = contour(raddis(x_ids),zc1(y_ids),Pro_2_plot,[0 0],'w-','linewidth',3);
            title(sprintf('$$%s_{%d %d}\\hspace{1mm}%s$$ %s, c = %3.2f',titles{k},i,j,norm_str{k},units{k},cor_coef),'interpreter','latex')
            count = count + 1;
            set(gca,'ylim',[0.4 1])
        end
    end
    set(gcf,'color','w','position',[7          41        1396         764])
    % uncomment to print
    update_figure_paper_size()
    print(sprintf('imgs/%s_%d_%d%s',fig_name{k},pp,window,mean_rm_str),'-dpdf')
    
end

%%
figure(3)
clim_bnd = P_clim_mag;
var_plot = (tot_P./norm_totP);
[c,h] = contourf(raddis,zc1,var_plot',[min(var_plot(:)) linspace(-clim_bnd,clim_bnd,150)]);
hold on
if pp == 1910
plot(line_end(:,1),line_end(:,2),'-','linewidth',6,'color',[1 1 1]*0.6)
end
% [c,h] = contourf(raddis,zc1,Tau_red(:,:,3,3)',-10:0.05:10);
set(h,'edgecolor','none')
set(gca,'clim',[-1 1]*clim_bnd,'ytick',[0.4:0.2:1])
editFig(1,x_bnds,y_bnds)
title('$$ \mathcal{P}\hspace{1mm}y_*/u_*^3 $$','interpreter','latex')
% h = text(FB_coords(1),FB_height,FB(1),'fontsize',30,'color',FB_clr(1));
for i = 1:length(FB_coords)
    h = text(FB_coords(i),FB_height,FB(i),'fontsize',30,'color',FB_clr(i));
end
hold on
[c,h1] = contour(raddis,zc1,tot_P_plot,[1 1]*0,'w-','linewidth',3);
set(gcf,'color','w','position',[428     4   902   300])
% uncomment to print
update_figure_paper_size()
print(sprintf('imgs/totP_norm_%d_%d%s',pp,window,mean_rm_str),'-dpdf')


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
    c = [-1 1]*c_bnd;
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















