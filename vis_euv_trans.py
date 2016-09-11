# Python 3 Program for moving ThorLabs Z812B motorized stage and taking  intensity measurements with Agilent 34970A
# Calling sequence: python3 vis_euv_trans.py [start position] [end position] [number of steps] [number of measurements per step]

import thorpy
import thorpy.message
import thorpy.comm.discovery as comm
import thorpy.stages
import agilent
import csv
import time
from time import sleep
import sys

# Check if the program received the correct number of arguments
if len != 5:
    sys.exit("Incorrect number of arguments! \n Calling sequence: python3 vis_euv_trans.py [start position] [end position] [number of steps] [number of measurements per step]")

# Set up measurement variables
start_pos = sys.argv[1]     # Position where the sequence starts, measured from the home position
end_pos = sys.argv[2]       # Position where the sequence ends, measured from the home position
num_steps = sys.arg[3]      # Number of steps to take with the motor between start and end position
num_meas = sys.arg[4]       # Number of intensity measurements to take per step
dx = (end_pos - start_pos) / num_steps  # Amount to move for each step

# Open the Z812B motorized stage
motor = None
x = comm.discover_stages()
for i in x:
    motor = i

# Check that the arguments are physically attainable
if start_pos == end_pos:
    sys.exit("Nothing to do. Start position equal to end position")

if min(start_pos, end_pos) < motor.home_offset:
    sys.exit("Minimum value too close to end of motor")

if max(start_pos,end_pos) > (12.0 - motor.home_offset):
    sys.exit("Maximum value too close to end of motor")

if num_meas <= 0:
    sys.exit("Number of measurements must be larger than zero")

if num_steps <= 0:
    sys.exit("Number of steps must be larger than zero")

# Open CSV file for writing output
timestr = time.strftime("%Y%m%d-%H%M%S")
csvfile =  open('vis-euv_' + timestr + '.csv', 'w', newline='')
csv_writer = csv.writer(csvfile)

# Open the Agilent 34970A for voltage measurements
voltmet = agilent.init_serial()

# Prepare the motor for a sequence
motor.max_velocity = 1.0    # Set max velocity parameter on Z812 (mm/s)
motor.print_state()
motor.home()                # Move the Z812 to the home position (position 0.0mm) before measurements
motor.position = start_pos  # Move the Z812 to the start position

# Loop through the sequence
for i in range(num_steps):
    data = []
    data.append(str(motor.position))
    data.append("")
    for j in range(0, num_meas):        # Take intensity measurements
        data.append(agilent.measure(voltmet))

    csv_writer.writerow(data)   # write next row of data to file

    cur_pos = motor.position
    motor.position = cur_pos + dx

    while motor.settled == False:
        sleep(0.1)


csvfile.close() # Close CSV file