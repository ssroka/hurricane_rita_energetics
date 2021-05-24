
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
if ismember(pp,[1910 2030])
addpath ~/Documents/MATLAB/util
switch pp
    case 1740
        x_bnds = [27 36];
        y_bnds = [0.51 1];
        eddy_cntr = 52;
        
    case 2030
        x_bnds = [31 45];
        y_bnds = [0.3 1];
        eddy_cntr = 61;
        %         FB = ['BFBF'];
        FB = ['BF'];
        %         FB_coords = [35.2 38 41 43.57];
        %         FB_height = [0.69];
        %                 cntr_bnds = [34.5 37;36 40;40 42; 42 44];
        
%         FB_coords = [41 43];
%         FB_height = [0.69];
%         cntr_bnds = [40 42; 42 44];
        
                FB_coords = [41 38];
        FB_height = [0.69];
        cntr_bnds = [40 42; 36 40];
        
        
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
        %         FB = ['BFBF'];
        FB = ['BF'];
        %                     FB_coords = [39.07 41.07 43.31 46.81];
        %                     FB_coords = [39 41 43 45];
        %                     FB_height = [0.69];
        %         FB_coords = [39.07 41.07 44.5 46.81];
        
%         FB_coords = [39 41.5];
%         FB_height = [0.6];
%         line_end = [46.1 0.78; 47.6 0.51];
%         %                     line_end = [45.56 0.87; 47.8 0.45];
%         %         cntr_bnds = [38 42;40 43;41 47; 44 49];
%         cntr_bnds = [38 42;40 43];
        
        FB_coords = [39 47];
        FB_height = [0.6];
        line_end = [46.1 0.78; 44 49];
        %                     line_end = [45.56 0.87; 47.8 0.45];
        %         cntr_bnds = [38 42;40 43;41 47; 44 49];
        cntr_bnds = [38 42;44 50];
        
end

tot_P_plot = tot_P';
tot_P_plot(zc1>1.0,:) = NaN;

%%
figure(pp)
for i = 1:size(cntr_bnds,1)
    if strcmp(FB(i),'B')
        s = -1;
    else
        s = 1;
    end
    if mean_rm
        row_const = 2; % plot mean removed in second row
    else
        row_const = 0; % plot mean not removed in first row
    end
    subplot(2,2,i+row_const)
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
    tot_P_mean_prof = nanmean(KE_bug_tot_P.*eddy_inds)./norm_totP;
    uTau_mean_prof  = nanmean(KE_bug_uTau.*eddy_inds)./norm_totP;
    adv_mean_prof   = nanmean(KE_bug_adv.*eddy_inds)./norm_totP;
    dpdr_mean_prof  = nanmean(KE_bug_dpdr.*eddy_inds)./norm_totP;
    dpdz_mean_prof  = nanmean(KE_bug_dpdz.*eddy_inds)./norm_totP;
    dqdt_mean_prof  = nanmean(KE_bug_dqdt.*eddy_inds)./norm_totP;
    g_mean_prof  = nanmean(KE_bug_g.*eddy_inds)./norm_totP;
    
    % combine pressure terms
    pgf_mean_prof = dpdr_mean_prof + dpdz_mean_prof;
    
    if mean_rm
        plot(uTau_mean_prof,zc1,'m','linewidth',2,'displayname','SFS transport $\times y_*/u_*^3$');
        hold on
        plot(adv_mean_prof,zc1,'g','linewidth',2,'displayname','$$-$$ADV $\times y_*/u_*^3$');
        plot(tot_P_mean_prof,zc1,'b','linewidth',2,'displayname','$$2 \mathcal{P}$$ $\times y_*/u_*^3$');
        plot(dqdt_mean_prof,zc1,'k--','linewidth',2,'displayname','$$\frac{\partial \widetilde{\overline{q}}^2}{\partial t}$$ $\times y_*/u_*^3$');
        
        uTau_avg_prof = nanmean(uTau_mean_prof);
        adv_avg_prof = nanmean(adv_mean_prof);
        tot_P_avg_prof = nanmean(tot_P_mean_prof);
        dqdt_avg_prof = nanmean(dqdt_mean_prof);
        
        save(sprintf('%d_%s',pp,FB(i)),'uTau_avg_prof','adv_avg_prof',...
            'tot_P_avg_prof','dqdt_avg_prof');
        
    else
        plot(g_mean_prof,zc1,'color',[128,128,128]./256,'linewidth',2,'displayname','$$-2g\widetilde{\overline{w}}$$ $\times y_*/u_*^3$');
        hold on
        plot(pgf_mean_prof,zc1,'color',[255, 165, 0]./256,'linewidth',2,'displayname','PGF $\times y_*/u_*^3$');
        plot(uTau_mean_prof,zc1,'m','linewidth',2,'displayname','SFS transport $\times y_*/u_*^3$');
        plot(adv_mean_prof,zc1,'g','linewidth',2,'displayname','$$-$$ADV $\times y_*/u_*^3$');
        plot(tot_P_mean_prof,zc1,'b','linewidth',2,'displayname','$$2 \mathcal{P}$$ $\times y_*/u_*^3$');
        plot(dqdt_mean_prof,zc1,'k--','linewidth',2,'displayname','$$\frac{\partial \widetilde{\overline{q}}^2}{\partial t}$$ $\times y_*/u_*^3$');
    end
    
    ylim(y_bnds)
    set(gca,'fontsize',24)
    xlabel('[m$$^2$$ s$$^{-3}$$]','interpreter','latex')
    if ismember(i,[1 3])
        ylabel('Height [km]','interpreter','latex')
    end
    title(sprintf('%s at r=%2.1f km',FB(i),FB_coords(i)),'interpreter','latex')
end

if mean_rm
    plt_title_2 = sprintf('Mean Removed');
    set(gcf,'color','w','position',[64         115        1184         680])
    subplot(2,2,1)
    lh = legend('location','northwest','interpreter','latex');
    h = gcf;
    drawnow
    rearrange_figure(h,lh,'2x2_1_legend',plt_title_1,plt_title_2)
    % drawnow
    
    
    %uncomment to print
    update_figure_paper_size()
    print(sprintf('imgs/componsite_contours_%d_%d%s',pp,window,mean_rm_str),'-dpdf')
    %}
else
    plt_title_1 = sprintf('%d, KE Budget Terms',pp);
end
else
    disp('only vertical profiles for 1910 or 2030')
end
%%
%{
% plot diff between dqdt and the SFS production
figure(2)
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
    dqdt_mean_prof = nanmean(KE_bug_dqdt.*eddy_inds);
    dqdt_mPro_mean_prof = nanmean((KE_bug_dqdt-KE_bug_tot_P).*eddy_inds);

    plot(dqdt_mean_prof,zc1,'linewidth',2,'displayname','$$\frac{\partial q}{\partial t}$$');
    hold on
    plot(dqdt_mPro_mean_prof,zc1,'linewidth',2,'displayname','$$\frac{\partial q}{\partial t}-2 \overline{S_{ij}}\tau_{ij}$$');

    ylim(y_bnds)
    set(gca,'fontsize',24)
    ylabel('Height [km]','interpreter','latex')
    legend('location','eastoutside','interpreter','latex')
    title(sprintf('%d: %s eddy at %2.1f',pp,FB(i),mean(cntr_bnds(i,:))))
end
set(gcf,'color','w','position',[64           4        1266         791])
% uncomment to print
% update_figure_paper_size()
% print(sprintf('imgs/Pro_contrib_%d_%d%s',pp,window,mean_rm_str),'-dpdf')
%
%%

%}
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

