open imgs/spectra.fig

grid on
set(gcf,'color','w')
set(gca,'fontsize',20)
xlabel('Wavelength [km]','interpreter','latex')
ylabel('Kinetic Energy Density [m$^3$s$^{-2}$]','interpreter','latex')

% uncomment to print
% update_figure_paper_size()
% print(sprintf('imgs/spectra'),'-dpdf')
