function [  ] = plot_spot( rays )
%plot_spot Makes a scatterplot of ray intercepts with image plane

% Extract each component from the ray data
[px, py, x, y, vig] = get_ray_data(rays);

figure(1)
scatter(x,y, 10, 'filled')

figure(2)
scatter(x(vig == 0), y(vig == 0), 10, 'filled')



end

