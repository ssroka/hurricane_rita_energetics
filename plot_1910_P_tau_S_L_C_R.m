close all;clc
if pp~=1910
    return
    % this is for 1910 only for now
end
switch pp
    case 1740
        x_bnds = [27 36];
        y_bnds = [0.6 1];
        
    case 2030
        x_bnds = [31 45];
        y_bnds = [0.3 1];
        
    case 2145
        x_bnds = [32 45];
        y_bnds = [0.6 1];
        
    case 2050
        x_bnds = [26 40];
        y_bnds = [0.3 1];
        
         S_cntr = [7e-3 NaN NaN
                  5e-3 5e-4 NaN
                  0.06 0.12 0.05]';
    case 1910
        x_bnds = [38 54];
        y_bnds = [0.4 1];
        P_cntr = [0.08 NaN NaN
                  0.04 0.016 NaN
                  0.35 0.2 0.15]';
        tau_cntr = [25 NaN NaN
                  25 25 NaN
                  7 6 10]';
        S_cntr = [7e-3 NaN NaN
                  5e-3 5e-4 NaN
                  0.06 0.12 0.05]';
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
end

x_ids = (raddis>x_bnds(1)) & (raddis<x_bnds(2));
y_ids = (zc1>y_bnds(1)) & (zc1<y_bnds(2));

subplot_inds = reshape(1:9,3,3)';% because subplot doesn't go in column major order

calc_u_star;

%%
figure(100)
plot_cntr(raddis(x_ids),zc1(y_ids),tot_P(x_ids,y_ids)',x_bnds,y_bnds)
hold on
[c,hL] = contour(raddis(x_ids),zc1(y_ids),tot_P(x_ids,y_ids)',[0 0],'w-','linewidth',3);
title(sprintf('Production of SFS Energy, pass %d, [m$$^2$$ s$$^{-2}$$ s$$^{-1}$$]',pp),'interpreter','latex')
set(gcf,'color','w','position',[99         316        1086         271])
%%

sum_P_2_plot = tot_P(x_ids,y_ids)';

vars = {tot_P, Pro_red,Tau_red,Strain_red,Leo_red,Rey_red,Cro_red};
titles = {'totP','\mathcal{P}','\tau','\widetilde{\overline{S}}','L','R','C'};
units = {'[m$$^2$$ s$$^{-2}$$ s$$^{-1}$$]',...
    '[m$$^2$$ s$$^{-2}$$ s$$^{-1}$$]',...
    '[m$$^2$$ s$$^{-2}$$]',...
    '[s$$^{-1}$$]',...
    '[m$$^2$$ s$$^{-2}$$]',...
    '[m$$^2$$ s$$^{-2}$$]',...
    '[m$$^2$$ s$$^{-2}$$]'};
fig_name = {'totP','P','tau','S','L','R','C'};
vars_clim_cell = {[],P_cntr,tau_cntr,S_cntr,L_cntr,R_cntr,C_cntr};

for k = 4
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
            title(sprintf('$$%s_{%d %d}$$ %s, c = %3.2f',titles{k},i,j,units{k},cor_coef),'interpreter','latex')
            count = count + 1;
            set(gca,'ylim',[0.4 1])
        end
    end
    set(gcf,'color','w','position',[7          41        1396         764])
%     w = 0.3;
%     d = 0.35;
%     y1 = 0.58;
%     y2 = 0.11;
%     x1 = 0.05;
%     x2 = 0.4;
%     x3 = 0.75;
%     x4 = 0.225;
%     x5 = 0.575;
%     
%     h(1) = subplot(3,2,1);
%     h(2) = subplot(3,2,2);
%     h(3) = subplot(3,2,3);
%     h(4) = subplot(3,2,4);
%     h(5) = subplot(3,2,5); % the last (odd) axes
%     pos = get(h,'Position');
%     new = mean(cellfun(@(v)v(1),pos(1:2)));
%     set(h(5),'Position',[new pos{5}(2) pos{1}(3) pos{5}(4)])
%     drawnow
%     pos = get(h,'Position');
%     set(h(5),'Position',[new pos{5}(2) pos{1}(3) pos{1}(4)])
    

end

%%
k = 7;
k = k+1;
count = 1;
LRC_tot_bnd = [-10*ones(3,1) 40*ones(3,1)];
figure(k)
var = zeros(size(vars{5},1),size(vars{5},2));
for k0 = 1:3
    subplot(3,1,k0)
    for i = 1:3
        for j = 1:3
            var = var + vars{4+count}(:,:,i,j);
        end
    end
    
    var_clim = vars_clim_cell{4+count};
    Pro_2_plot = var(x_ids,y_ids)';
    plot_cntr(raddis(x_ids),zc1(y_ids),Pro_2_plot,x_bnds,y_bnds,LRC_tot_bnd(i,2),100)
    set(gca,'clim',LRC_tot_bnd(count,:));
    cor_coef = corr(sum_P_2_plot(:),Pro_2_plot(:),'rows','complete');
    hold on
    [c,hL] = contour(raddis(x_ids),zc1(y_ids),Pro_2_plot,[0 0],'w-','linewidth',3);
    title(sprintf('$$%s$$ %s, c = %3.2f',titles{4+count},units{4+count},cor_coef),'interpreter','latex')
    set(gca,'ylim',[0.4 1],'xtick',[40 45 50])
        set(gcf,'color','w','position',[428     4   902   801])

%     set(gcf,'position',[ 152          17        1209         362],'color','w')
  count = count + 1;
end
% uncomment to print
% update_figure_paper_size()
% print(sprintf('imgs/%d_LRC_total_%d%s',pp,window,mean_rm_str),'-dpdf')
  
%%
figure(k+1)
subplot(3,1,1)
plot_cntr(raddis(x_ids),zc1(y_ids),tot_P(x_ids,y_ids)',x_bnds,y_bnds)
title(sprintf('%d, $$\\mathcal{P}$$ [m$$^2$$ s$$^{-2}$$ s$$^{-1}$$]',pp),'interpreter','latex')
subplot(3,1,2)
Pro_red(x_ids,y_ids,1,3)';
Pro_2_plot = Pro_red(x_ids,y_ids,1,3)';
plot_cntr(raddis(x_ids),zc1(y_ids),Pro_2_plot,x_bnds,y_bnds)
title(sprintf('%d, $$-\\tau_{13}S_{13}$$ [m$$^2$$ s$$^{-2}$$ s$$^{-1}$$]',pp),'interpreter','latex')
subplot(3,1,3)
Pro_2_plot = Pro_red(x_ids,y_ids,2,3)';
plot_cntr(raddis(x_ids),zc1(y_ids),Pro_2_plot,x_bnds,y_bnds)
title(sprintf('%d, $$-\\tau_{23}S_{23}$$ [m$$^2$$ s$$^{-2}$$ s$$^{-1}$$]',pp),'interpreter','latex')

set(gcf,'color','w','position',[7          41        1396         764])
%%
vars_S_comp = {d_radl_dr_red,[],d_radl_dz_red;d_tang_dr_red,[],d_tang_dz_red;d_vert_dr_red,[],d_vert_dz_red};
vars_S_comp_name = {'d_radl_dr',[],'d_radl_dz';
    'd_tang_dr',[],'d_tang_dz';
    'd_vert_dr',[],'d_vert_dz'};


figure(k+2)
for j = 1:3
    for i = 1:3
        if (j==2)
            continue
        end
        var = vars_S_comp{i,j};
        subplot(3,3,subplot_inds(i,j))
        Pro_2_plot = var(x_ids,y_ids)';
        plot_cntr(raddis(x_ids),zc1(y_ids),Pro_2_plot,x_bnds,y_bnds)
        cor_coef = corr(sum_P_2_plot(:),Pro_2_plot(:),'rows','complete');
        hold on
        [c,hL] = contour(raddis(x_ids),zc1(y_ids),Pro_2_plot,[0 0],'w-','linewidth',3);
        title(vars_S_comp_name{i,j},'interpreter','none')
        %title(sprintf('$$%s_{%d %d}$$ %s, c = %3.2f',titles{k},i,j,units{k},cor_coef),'interpreter','latex')
    end
end
set(gcf,'color','w','position',[7          41        1396         764])

for i = 1:length(vars)
    figure(i)
    % uncomment to print
%     update_figure_paper_size()
%     print(sprintf('imgs/%d_%s_%d%s',pp,fig_name{i},window,mean_rm_str),'-dpdf')
end


function [] = plot_cntr(raddis,zc1,tot_P,x_bnds,y_bnds,c_bnd,n_lvl)
% c2 = prctile(tot_P(:),[5 95]);

if (nargin >6) & ~isnan(c_bnd)
        c = [-1 1]*c_bnd;
        [~,h] = contourf(raddis,zc1,tot_P,linspace(c(1),c(2),n_lvl));
    
elseif (nargin >5) & ~isnan(c_bnd)
    c = [-1 1]*c_bnd;
    [~,h] = contourf(raddis,zc1,tot_P,linspace(c(1),c(2),40));
    
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

































