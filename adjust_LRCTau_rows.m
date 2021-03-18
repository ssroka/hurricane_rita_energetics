
dx = 0.06;
dy = 0.02;
for i = 1:6
    for j = 1:4
        h = subplot(6,4,sub2ind([4,6],j,i));
        cp = get(h,'Position');
        if i == 1 && j ==1
            Lx = cp(3)*1.2;
            Ly = cp(4)*1.2;
        end
        % shift
        if false
            set(h,'position',[cp(1)-dx cp(2:4)])
        else
            set(h,'position',[cp(1)-dx cp(2)-dy Lx Ly])
            
        end
    end
    
end

















