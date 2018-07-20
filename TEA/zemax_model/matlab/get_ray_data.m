function [px, py, x, y, vig ] = get_ray_data( rays )

px = squeeze(rays(1,:));
py = squeeze(rays(2,:));
x = squeeze(rays(3,:));  % Array of x-coordinates of rays on detector
y = squeeze(rays(4,:));  % Array of y-coordinates of rays on detector
vig = squeeze(rays(5,:));  % vignetting code

end

