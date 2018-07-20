function [] = plot_throughput()
% Plots throughput curves of TEA_GSE instrument as a function of test
% mirror distance and tilt.

% User defined parameters
min_d = 9.0;    % (mm)
max_d = 12.0;
num_d = 20;
% min_alpha = 0.0;    % (deg)
% max_alpha = 1.0;
% num_alpha = 3;
alpha = 0.0;
ray_den = 20;

% Calculate step sizes
delta_d = (max_d - min_d) / num_d;
% delta_alpha = (max_alpha - min_alpha) / num_alpha;

% Create arrays where each element represents each step
d = min_d:delta_d:max_d;
% alpha = min_alpha:delta_alpha:max_alpha

I = zeros(numel(alpha), numel(d));


for i = 1:numel(alpha)     % Loop over all mirror angles
     for j = 1:numel(d)    % Loop over all mirror distances
         
        % Run raytrace of system in current configuration
        zemax_raytrace(ray_den, d(j), alpha(i));
        
        % Read rays from predefined disk storage space
        rays = read_zemax_raytrace();
        
        % Find the unvignetted rays
        [~,~,~,~,vig] = get_ray_data(rays);
        
        I(i,j) = numel(find(vig==0));
        
     end
end

plot(d, I(1,:))

end

