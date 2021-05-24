clear;close all;clc




FB = 'BF';
pp = [1910 2030];
for j = 1:2
    for i = 1:2
    load(sprintf('%d_%s',pp(j),FB(i)))
    [uTau_avg_prof;
        adv_avg_prof ;
        tot_P_avg_prof;
        dqdt_avg_prof]
    p2(i+2*(j-1)) = abs(tot_P_avg_prof/dqdt_avg_prof);
    p3(i+2*(j-1)) = abs(tot_P_avg_prof/(adv_avg_prof+uTau_avg_prof));
    end
end

plot(p3)









