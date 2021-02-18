close all
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
x_ids = (raddis>x_bnds(1)) & (raddis<x_bnds(2));
y_ids = (zc1>y_bnds(1)) & (zc1<y_bnds(2));

figure(1)
sum_P_2_plot = tot_P(x_ids,y_ids)';


subplot(2,3,1)
plot_cntr(raddis(x_ids),zc1(y_ids),Strain_red(x_ids,y_ids,1,3)',x_bnds,y_bnds)
hold on
[c,hL] = contour(raddis(x_ids),zc1(y_ids),Strain_red(x_ids,y_ids,1,3)',[0 0],'w-','linewidth',3);
Pro_2_plot = Strain_red(x_ids,y_ids,1,3)';
% plot_cntr(raddis(x_ids),zc1(y_ids),Pro_2_plot,x_bnds,y_bnds)
c = corr(sum_P_2_plot(:),Pro_2_plot(:),'rows','complete');
title(sprintf('%d, $$\\overline{S}_{13}$$ [s$$^{-1}$$] $$c = $$ %3.2f',pp,c),'interpreter','latex')
set(gca,'ytick',[0.4:0.2:1])

subplot(2,3,2)
plot_cntr(raddis(x_ids),zc1(y_ids),Tau_red(x_ids,y_ids,1,3)',x_bnds,y_bnds)
hold on
[c,hL] = contour(raddis(x_ids),zc1(y_ids),Tau_red(x_ids,y_ids,1,3)',[0 0],'w-','linewidth',3);
Pro_2_plot = Tau_red(x_ids,y_ids,1,3)';
% plot_cntr(raddis(x_ids),zc1(y_ids),Pro_2_plot,x_bnds,y_bnds)
c = corr(sum_P_2_plot(:),Pro_2_plot(:),'rows','complete');
title(sprintf('%d, $$\\tau_{13}$$ [m$$^2$$ s$$^{-2}$$] $$c = $$ %3.2f',pp,c),'interpreter','latex')
set(gca,'ytick',[0.4:0.2:1])

subplot(2,3,3)
plot_cntr(raddis(x_ids),zc1(y_ids),Pro_red(x_ids,y_ids,1,3)',x_bnds,y_bnds)
hold on
[c,hL] = contour(raddis(x_ids),zc1(y_ids),Pro_red(x_ids,y_ids,1,3)',[0 0],'w-','linewidth',3);
Pro_2_plot = Pro_red(x_ids,y_ids,1,3)';
% plot_cntr(raddis(x_ids),zc1(y_ids),Pro_2_plot,x_bnds,y_bnds)
c = corr(sum_P_2_plot(:),Pro_2_plot(:),'rows','complete');
title(sprintf('%d, $$\\mathcal{P}_{13}$$ [m$$^2$$ s$$^{-2}$$ s$$^{-1}$$] $$c = $$ %3.2f',pp,c),'interpreter','latex')
set(gca,'ytick',[0.4:0.2:1])

     
subplot(2,3,4)
plot_cntr(raddis(x_ids),zc1(y_ids),Strain_red(x_ids,y_ids,2,3)',x_bnds,y_bnds)
hold on
[c,hL] = contour(raddis(x_ids),zc1(y_ids),Strain_red(x_ids,y_ids,2,3)',[0 0],'w-','linewidth',3);
Pro_2_plot = Strain_red(x_ids,y_ids,2,3)';
% plot_cntr(raddis(x_ids),zc1(y_ids),Pro_2_plot,x_bnds,y_bnds)
c = corr(sum_P_2_plot(:),Pro_2_plot(:),'rows','complete');
title(sprintf('%d, $$\\overline{S}_{23}$$ [s$$^{-1}$$] $$c = $$ %3.2f',pp,c),'interpreter','latex')
set(gca,'ytick',[0.4:0.2:1])

subplot(2,3,5)
plot_cntr(raddis(x_ids),zc1(y_ids),Tau_red(x_ids,y_ids,2,3)',x_bnds,y_bnds)
hold on
[c,hL] = contour(raddis(x_ids),zc1(y_ids),Tau_red(x_ids,y_ids,2,3)',[0 0],'w-','linewidth',3);
Pro_2_plot = Tau_red(x_ids,y_ids,2,3)';
% plot_cntr(raddis(x_ids),zc1(y_ids),Pro_2_plot,x_bnds,y_bnds)
c = corr(sum_P_2_plot(:),Pro_2_plot(:),'rows','complete');
title(sprintf('%d, $$\\tau_{23}$$ [m$$^2$$ s$$^{-2}$$] $$c = $$ %3.2f',pp,c),'interpreter','latex')
set(gca,'ytick',[0.4:0.2:1])

subplot(2,3,6)
plot_cntr(raddis(x_ids),zc1(y_ids),Pro_red(x_ids,y_ids,2,3)',x_bnds,y_bnds)
hold on
[c,hL] = contour(raddis(x_ids),zc1(y_ids),Pro_red(x_ids,y_ids,2,3)',[0 0],'w-','linewidth',3);
Pro_2_plot = Pro_red(x_ids,y_ids,2,3)';
% plot_cntr(raddis(x_ids),zc1(y_ids),Pro_2_plot,x_bnds,y_bnds)
c = corr(sum_P_2_plot(:),Pro_2_plot(:),'rows','complete');
title(sprintf('%d, $$\\mathcal{P}_{23}$$ [m$$^2$$ s$$^{-2}$$ s$$^{-1}$$] $$c = $$ %3.2f',pp,c),'interpreter','latex')
set(gca,'ytick',[0.4:0.2:1])



set(gcf,'color','w','position',[7         344        1434         461])



update_figure_paper_size()
print(sprintf('imgs/%d_P13_P23',pp),'-dpdf')



function [] = plot_cntr(raddis,zc1,tot_P,x_bnds,y_bnds)
[c,h] = contourf(raddis,zc1,tot_P);
c2 = prctile(tot_P(:),[5 95]);
xlabel('Radius [km]','interpreter','latex')
ylabel('Height [km]','interpreter','latex')
current_clim = get(gca,'clim');
current_LL = get(h,'levellist');
colorbar
colormap('jet')
set(h,'edgecolor',[0.5 0.5 0.5])
c = [-1 1]*max(abs(current_clim));
if length(current_LL)>1
    set(h,'levellist',[linspace(current_LL(1),current_LL(end),15)])
end
c = [-1 1]*min(max(abs(current_clim)),20);

set(gca,'ylim',y_bnds,'xlim',x_bnds,'clim',c,'fontsize',20)
%,'clim',[-1 1]*max(abs(current_clim)),'fontsize',25)
end
