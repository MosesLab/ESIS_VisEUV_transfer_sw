# ESIS_VisEUV_transfer_sw
This software moves a ThorLabs Z812B stepper motor and takes voltage measurements using an Agilent A/D board.

To install dependencies:
sudo apt-get install python-pip3
sudo pip3 install pyserial
sudo pip3 install pyusb

This program needs to be run using super-user privileges

Calling sequence:
sudo python3 vis_euv_trans.py [start distance] [end distance] [number of steps] [number of measurements per step]

Please note: from home position
0.4mm < start distance < end distance < (12.0mm -0.4mm)

Also, the Agilent 34970A must be connected to the computer first! The porgram assumes that the agilent is at /dev/ttyUSB0
