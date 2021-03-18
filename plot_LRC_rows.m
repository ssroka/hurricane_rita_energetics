close all;clc
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
        
    case 1910
        x_bnds = [38 54];
        y_bnds = [0.4 1];
        
end
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

x_ids = (raddis>x_bnds(1)) & (raddis<x_bnds(2));
y_ids = (zc1>y_bnds(1)) & (zc1<y_bnds(2));

subplot_inds = reshape(1:9,3,3)';% because subplot doesn't go in column major order

%%
figure(100)
plot_cntr(raddis(x_ids),zc1(y_ids),tot_P(x_ids,y_ids)',x_bnds,y_bnds)
hold on
[c,hL] = contour(raddis(x_ids),zc1(y_ids),tot_P(x_ids,y_ids)',[0 0],'w-','linewidth',3);
title(sprintf('Production of SFS Energy, pass %d, [m$$^2$$ s$$^{-2}$$ s$$^{-1}$$]',pp),'interpreter','latex')
set(gcf,'color','w','position',[99         316        1086         271])
%%

sum_P_2_plot = tot_P(x_ids,y_ids)';

vars = {Leo_red,Rey_red,Cro_red,Tau_red};
titles = {'L','R','C','\tau'};
units = {...
    '[m$$^2$$ s$$^{-2}$$]',...
    '[m$$^2$$ s$$^{-2}$$]',...
    '[m$$^2$$ s$$^{-2}$$]',...
    '[m$$^2$$ s$$^{-2}$$]'};
fig_name = {'L','R','C','tau'};
vars_clim_cell = {L_cntr,R_cntr,C_cntr,tau_cntr};

for k = 1:length(vars)
    count = 1;
    var = vars{k};
    %     figure(k)
    var_clim = vars_clim_cell{k};
    for j = 1:3
        for i = 1:j
            %             if (i==2) && (j==2)
            %                 continue
            %             end
            subplot(6,length(vars),sub2ind([4,6],k,count))
            Pro_2_plot = var(x_ids,y_ids,i,j)';
            plot_cntr(raddis(x_ids),zc1(y_ids),Pro_2_plot,x_bnds,y_bnds,10)
            cor_coef = corr(sum_P_2_plot(:),Pro_2_plot(:),'rows','complete');
            hold on
            [c,hL] = contour(raddis(x_ids),zc1(y_ids),Pro_2_plot,[0 0],'w-','linewidth',3);
            title(sprintf('$$%s_{%d %d}$$ %s, c = %3.2f',titles{k},i,j,units{k},cor_coef),'interpreter','latex')
            if k ==1
                set(gca,'ytick',y_bnds)
                ylabel('Height [km]','interpreter','latex')
            elseif k==length(vars)
                colorbar
            end
            if count == 6
                set(gca,'xtick',x_bnds)
                xlabel('Radius [km]','interpreter','latex')
            end
            
            count = count + 1;
            set(gca,'ylim',[0.4 1])
            
        end
    end
    set(gcf,'color','w','position',[-1903          12        1558         973])
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

addpath ~/Documents/MATLAB/util/tightfig/

% tightfig(gcf)
drawnow
adjust_LRCTau_rows
update_figure_paper_size()
print(sprintf('imgs/LRCTau_%d_%d%s',pp,window,mean_rm_str),'-dpdf')


function [] = plot_cntr(raddis,zc1,tot_P,x_bnds,y_bnds,c_bnd,n_lvl)
% c2 = prctile(tot_P(:),[5 95]);

if (nargin >6) & ~isnan(c_bnd)
    c = [-1 1]*c_bnd;
    [~,h] = contourf(raddis,zc1,tot_P,[min(tot_P(:)) linspace(c(1),c(2),n_lvl)]);
    
elseif (nargin >5) & ~isnan(c_bnd)
    c = [-1 1]*c_bnd;
    [~,h] = contourf(raddis,zc1,tot_P,[min(tot_P(:)) linspace(c(1),c(2),100)]);
    
else
    [~,h] = contourf(raddis,zc1,tot_P);
    
    current_clim = get(gca,'clim');
    current_LL = get(h,'levellist');
    
    if length(current_LL)>1
        set(h,'levellist',[linspace(current_LL(1),current_LL(end),15)])
    end
    c = [-1 1]*min(max(abs(current_clim)),20);
end
% colorbar
colormap('jet')
% set(h,'edgecolor',[0.5 0.5 0.5])
set(h,'edgecolor','none')
set(gca,'xtick',[],'ytick',[])
% xlabel('Radius [km]','interpreter','latex')
% ylabel('Height [km]','interpreter','latex')
set(gca,'ylim',y_bnds,'xlim',x_bnds,'clim',c,'fontsize',15)
%,'clim',[-1 1]*max(abs(current_clim)),'fontsize',25)
end




