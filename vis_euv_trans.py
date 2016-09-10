import thorpy
import thorpy.message
import thorpy.comm.discovery as comm
import thorpy.stages

print("here")

x = comm.discover_stages()

stage = None

for i in x:
    stage = i

print(stage,x)

stage.max_velocity = 1.0
stage.acceleration = 1.0

stage.print_state()

stage.home()

stage.position = 2.0



stage.print_state()