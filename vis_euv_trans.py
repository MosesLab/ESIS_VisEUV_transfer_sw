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

print(stage.status_channel_enabled)