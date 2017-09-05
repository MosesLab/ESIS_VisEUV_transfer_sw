# Python 3 Program for moving ThorLabs Z812B motorized stage and taking  intensity measurements with Agilent 34970A
# Calling sequence: python3 vis_euv_trans.py [start position] [end position] [number of steps] [number of measurements per step]


import thorpy.comm.discovery as comm
import thorpy.stages
import agilent
import os
import csv
import time
from time import sleep
import sys


# Set up measurement variables
num_meas = int(sys.argv[1])    # Position where the sequence starts, measured from the home position


# prepare the directory structure
cur_dir = "Output/NoiseTest"
if not os.path.exists(cur_dir):
    os.makedirs(cur_dir)

timestr = time.strftime("%Y%m%d-%H%M%S")


# Open the Agilent 34970A for voltage measurements
voltmet = agilent.init_serial()


# Open CSV file for writing output
csv_fn = cur_dir + "/" + timestr + ".csv"
csvfile =  open(csv_fn, 'w', newline='')
csv_writer = csv.writer(csvfile)


#for j in range(0, num_meas):        # Take intensity measurements
while True:
    data = []
    raw = agilent.measure(voltmet)
    rawlist = raw.split(",")
    for datum in rawlist:
        #print(datum)
        data.append(datum)

    csv_writer.writerow(data)   # write next row of data to file
    csvfile.flush()

csvfile.close() # Close CSV file






input("Press Enter to quit...")