import thorpy
import thorpy.message
import thorpy.comm.discovery as comm
import thorpy.stages

print("here")

x = comm.discover_stages()

stages = []

for i in x:
    stages.append(i)

print(stages)