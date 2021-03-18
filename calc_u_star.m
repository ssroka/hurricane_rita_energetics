% calculate the friction velocity


% https://glossary.ametsoc.org/wiki/Friction_velocity

% u_star = sqrt(Tau_red)./rhoz_bar;
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

u_star = ((Rey_red(:,:,1,3)).^2+(Rey_red(:,:,2,3)).^2).^.25;

% 
% u_star_perturb = ((sfs_radl.*sfs_vert).^2+(sfs_tang.*sfs_vert).^2).^.25;
% Tau_tot = zeros(size(Tau_red(:,:,1,1)));
% for i = 1:3
%     for j= 1:3
%         Tau_tot = Tau_tot + Tau_red(:,:,i,j);
%     end
% end
% figure
% [c,h] = contourf(raddis,zc1,Tau_tot',-30:0.5:30);
% colorbar
% set(gca,'ylim',y_bnds,'xlim',x_bnds,'fontsize',20)
% set(h,'edgecolor','none')
% 
% figure
% subplot(2,1,1)
% [c,h] = contourf(raddis,zc1,(u_star_perturb_R)',-5:0.1:5);
% colorbar
% set(gca,'ylim',y_bnds,'xlim',x_bnds,'fontsize',20)
% set(h, 'edgecolor','none')
% % logarithmic profile
% 
% % at each radial location look at the vertical profile
% u_bar = (radl_red.^2+tang_red.^2+vert_red.^2).^0.5;
% 
% Nr = size(radl_red,1);
% Nz = size(radl_red,2);
% 
% kappa = 0.4;
% % exclude z = 0
% 
% u_star = zeros(Nr,1);
% for i = 1:Nr
%     u_bar_col = u_bar(i,:);
%     inds = ~(isnan(u_bar_col) | isinf(u_bar_col));
%     Y = u_bar(i,inds)';
%     X = [log(zc1(inds)')./kappa -ones(sum(inds),1)];
%     b = X\Y;
%     u_star(i) = b(1);
% end
% 
% 
% subplot(2,1,2)
% plot(raddis,(u_star))








