function [ ] = zemax_raytrace( ray_den, d, alpha )

% Construct call to Zemax
path = "..\c++\CppStandaloneApplication\Debug\CppStandaloneApplication ";
args = strcat(num2str(ray_den), " ", num2str(d), " ", num2str(alpha));

% Call zemax c++ code with the above arguments
system(char(strcat(path, args)));

end

