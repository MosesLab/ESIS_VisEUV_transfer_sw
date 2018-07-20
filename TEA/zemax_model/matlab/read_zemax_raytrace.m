function [ rays ] = read_zemax_raytrace( )

    % Open temporary files containing raytrace data
    meta_file = fopen('rays/meta.dat');
    ray_file = fopen('rays/rays.dat');

    % Read in metadata
    num_rays = fread(meta_file,1,'int32');

    % Read in ray data
    rays = fread(ray_file, [5, num_rays], 'double');
    
%     rays = reshape(rays, 5, 1, []);
    
end

