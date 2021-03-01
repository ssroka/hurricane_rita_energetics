ccc
addpath('~/Documents/MATLAB/util/othercolor/')
l = othercolor;
peaks
for i = 1:length(l)
    set(gca,'colormap',othercolor(i))
    i
    pause
end

    



