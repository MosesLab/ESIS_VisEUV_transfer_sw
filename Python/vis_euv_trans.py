# Python 3 Program for moving ThorLabs Z812B motorized stage and taking  intensity measurements with Agilent 34970A
# Calling sequence: python3 vis_euv_trans.py [start position] [end position] [number of steps] [number of measurements per step]

import thorpy
import thorpy.message
import thorpy.comm.discovery as comm
import thorpy.stages
import agilent

import os
import csv
import time
from time import sleep
import sys
import matlab.engine
eng = matlab.engine.start_matlab()
eng.cd(r'../Matlab')

# Check if the program received the correct number of arguments
if len(sys.argv) != 8:
    sys.exit("Incorrect number of arguments! \n Calling sequence: python3 vis_euv_trans.py [start position] [end position] [number of steps] [number of measurements per step] [VIS | EUV] [Grating #] [Comment] \n" + str(sys.argv))

# Set up measurement variables
start_pos = float(sys.argv[1])    # Position where the sequence starts, measured from the home position
end_pos = float(sys.argv[2])     # Position where the sequence ends, measured from the home position
num_steps = int(sys.argv[3])    # Number of steps to take with the motor between start and end position
num_meas = int(sys.argv[4])       # Number of intensity measurements to take per step

# Type of grating to analyze for this measurement (Visible or EUV)
grating_type = str(sys.argv[5])
if(grating_type != "VIS" and grating_type != "EUV"):
    sys.exit("Incorrect grating type argument, use 'VIS' or 'EUV'")

# Serial number of the grating under test
grating_num = int(sys.argv[6])
if(grating_num < 1 or grating_num > 6):
    sys.exit("Incorrect grating number specified. Use a value between 1 and 6")

# Comment associated with this test run
grating_comment = str(sys.argv[7])

# prepare the directory structure
grating_dir = "../Output/" + grating_type + "/" + "grating_" + str(grating_num)
if not os.path.exists(grating_dir):
    os.makedirs(grating_dir)

timestr = time.strftime("%Y%m%d-%H%M%S")
exp_dir = grating_dir + "/" + timestr
os.makedirs(exp_dir)

report_dir = exp_dir + "/reports"
os.makedirs(report_dir)
iter_dir = exp_dir + "/iterations"
os.makedirs(iter_dir)



cont_loop = 0      # 0 = for continuing adptive mesh refinement, 1 = for manual mesh refinement, 2 = bootstrapping converged, exit program.
iteration = 0

# Open the Z812B motorized stage
motor = None
x = comm.discover_stages()
for i in x:
    motor = i

if motor == None:
    sys.exit("Z812 stage not connected")

# Open the Agilent 34970A for voltage measurements
voltmet = agilent.init_serial()

# Prepare the motor for a sequence
motor.acceleration = 0.05
motor.max_velocity = 1.0    # Set max velocity parameter on Z812 (mm/s)
motor.print_state()

motor.home()

while(True):

    # Check the return value of Matlab script to determine what to do next
    if(cont_loop == 1):
        [start_pos, end_pos, num_steps, num_meas] = input("Adaptive grid selection failed, Please enter the new gridsize...")
    elif(cont_loop ==2):
        break

    dx = (end_pos - start_pos) / num_steps  # Amount to move for each step

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

    # Prepare directory for this iteration
    cur_dir = iter_dir + "/iteration_" + str(iteration)
    os.makedirs(cur_dir)

    # Open CSV file for writing output
    csv_fn = cur_dir + "/data.csv"
    csvfile =  open(csv_fn, 'w', newline='')
    csv_writer = csv.writer(csvfile)


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
            #motor.print_state()

        # Take the intesity measurements
        data = []
        data.append(str(motor.position))
        for j in range(0, num_meas):        # Take intensity measurements
            raw = agilent.measure(voltmet)
            rawlist = raw.split(",")
            for datum in rawlist:
                #print(datum)
                data.append(datum)

        csv_writer.writerow(data)   # write next row of data to file
        csvfile.flush()



    csvfile.close() # Close CSV file

    [cont_loop, start_pos, end_pos, num_steps, num_meas, iteration] = eng.complete_align(csv_fn, iteration,grating_num,grating_type, nargout=6)
    cont_loop = int(cont_loop)
    num_steps = int(num_steps)
    num_meas = int(num_meas)
    iteration= int(iteration)
    print(cont_loop, start_pos, end_pos, num_steps, num_meas,iteration)




input("Press Enter to quit...")