import matlab.engine
eng = matlab.engine.start_matlab()

[cont_loop, new_grid] = eng.range_finder('test/dir', 1, nargout=2)

print(cont_loop)
print(new_grid)

