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
if len(sys.argv) != 5:
    sys.exit("Incorrect number of arguments! \n Calling sequence: python3 vis_euv_trans.py [start position] [end position] [number of steps] [number of measurements per step] \n" + str(sys.argv))

# Set up measurement variables
start_pos = float(sys.argv[1])    # Position where the sequence starts, measured from the home position
end_pos = float(sys.argv[2])     # Position where the sequence ends, measured from the home position
num_steps = int(sys.argv[3])    # Number of steps to take with the motor between start and end position
num_meas = int(sys.argv[4])       # Number of intensity measurements to take per step
dx = (end_pos - start_pos) / num_steps  # Amount to move for each step

# Open the Z812B motorized stage
motor = None
x = comm.discover_stages()
for i in x:
    motor = i

if motor == None:
    sys.exit("Z812 stage not connected")

# Check that the arguments are physically attainable
if start_pos == end_pos:
    sys.exit("Nothing to do. Start position equal to end position")

if min(start_pos, end_pos) < motor.home_offset_distance:
    sys.exit("Minimum value too close to end of motor")

if max(start_pos,end_pos) > (12.0 - motor.home_offset_distance):
    sys.exit("Maximum value too close to end of motor")

if num_meas <= 0:
    sys.exit("Number of measurements must be larger than zero")

if num_steps <= 0:
    sys.exit("Number of steps must be larger than zero")

# Open CSV file for writing output
timestr = time.strftime("%Y%m%d-%H%M%S")
csvfile =  open('output_csv/vis-euv_' + timestr + '.csv', 'w', newline='')
csv_writer = csv.writer(csvfile)

# Open the Agilent 34970A for voltage measurements
voltmet = agilent.init_serial()

# Prepare the motor for a sequence
motor.acceleration = 0.05
motor.max_velocity = 1.0    # Set max velocity parameter on Z812 (mm/s)
motor.print_state()
motor.home()                # Move the Z812 to the home position (position 0.0mm) before measurements


# Loop through the sequence
for num in range(0,num_steps+1):

    # Make sure the motor isn't going to be damaged by the move
    if(motor.status_motor_current_limit_reached or motor.status_motion_error or motor.status_forward_hardware_limit_switch_active or motor.status_reverse_hardware_limit_switch_active):
        sys.exit("Z812B encountered an error")

    # Move the motor to the new position and wait for completion
    motor.position = start_pos + num * dx
    sleep(0.2)
    while (motor.status_in_motion_forward or motor.status_in_motion_reverse or motor.status_in_motion_jogging_forward or motor.status_in_motion_jogging_reverse or motor.status_in_motion_homing):
        sleep(0.1)
        motor.print_state()

    # Take the intesity measurements
    data = []
    data.append(str(motor.position))
    data.append("")
    for j in range(0, num_meas):        # Take intensity measurements
        data.append(agilent.measure(voltmet))

    csv_writer.writerow(data)   # write next row of data to file





csvfile.close() # Close CSV file