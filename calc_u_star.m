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
x_ids = (raddis>x_bnds(1)) & (raddis<x_bnds(2));
y_ids = (zc1>y_bnds(1)) & (zc1<y_bnds(2));

%% Reynolds term
u_star = ((Rey_red(:,:,1,3)).^2+(Rey_red(:,:,2,3)).^2).^.25;

u_star_mean = mean(u_star(x_ids,y_ids),'all');

%% logarithmic profile
%{
% at each radial location look at the vertical profile
u_bar = (radl_red.^2+tang_red.^2+vert_red.^2).^0.5;

Nr = size(radl_red,1);
Nz = size(radl_red,2);

kappa = 0.4;
% exclude z = 0

u_star = zeros(Nr,1);
STATS = zeros(Nr,4);
for i = 1:Nr
    u_bar_col = u_bar(i,:);
    inds = ~(isnan(u_bar_col) | isinf(u_bar_col));
    Y = u_bar(i,inds)';
    X = [log(zc1(inds)')./kappa -ones(sum(inds),1)];
    [b,BINT,R,RINT,STATS(i,:)] = regress(Y,X);
    u_star(i) = b(1);
end
u_star_mean = mean(u_star(x_ids));
yyaxis left
plot(raddis(x_ids),u_star(x_ids),'displayname','u* log profile')

set(gca,'xlim',x_bnds)
hold on
plot(x_bnds,[1 1]*1.16,'r--','linewidth',2,'displayname','1.16')
plot(x_bnds,[1 1]*u_star_mean,'m:','linewidth',2,'displayname',num2str(u_star_mean))

yyaxis right
plot(raddis(x_ids),STATS(x_ids,1),'g','displayname',"R^2")
ylabel('r squared log fit')

legend('location','best')
%}
%% AMS Glossery

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

% 
% 
% subplot(2,1,2)
% plot(raddis,(u_star))








