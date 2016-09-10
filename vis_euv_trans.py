import thorpy
import thorpy.message
import thorpy.comm.discovery as comm
import thorpy.stages

print("here")

x = comm.discover_stages()

stages = None

for i in x:
    stages = i

print(stages,x)