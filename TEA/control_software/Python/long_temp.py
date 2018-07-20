

import thorpy
import thorpy.message
import thorpy.comm.discovery as comm
import thorpy.stages
import agilent
from temp_conversion import steinhart
import os
import csv
import time
from time import sleep
import sys
import matlab.engine
eng = matlab.engine.start_matlab()
eng.cd(r'../Matlab')


duration = float(sys.argv[1])

temp_dir = "/home/krg/Transfer_ESIS_Alignment_GSE/control_software/Output/Temperature"

if not os.path.exists(temp_dir):
    os.makedirs(temp_dir)

timestr = time.strftime("%Y%m%d-%H%M%S")
exp_dir = temp_dir + "/" + timestr
os.makedirs(exp_dir)

# Open the Agilent 34970A for voltage measurements
voltmet = agilent.init_serial()

csv_fn = exp_dir + "/data.csv"
csvfile = open(csv_fn, 'w', newline='')
csv_writer = csv.writer(csvfile)

start_time=time.time()

dif = 0

while dif < duration:
    data = []
    raw = agilent.measure(voltmet,104,114)
    rawlist = raw.split(",")
    for k in range(0,(len(rawlist)+1)):
        if k == 0:  # photodiode & Vin measurement
            data.append(rawlist[k])
        elif k == 11:
            dif = time.time()-start_time
            data.append(dif)
        else:
            data.append(steinhart(float(rawlist[k]), float(rawlist[0])))
    sleep(1.0)

    csv_writer.writerow(data)  # write next row of data to file
    csvfile.flush()

eng.temp_long(csv_fn, nargout=0)

input("Press Enter to quit ...")