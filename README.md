# ESIS_VisEUV_transfer_sw
This software moves a ThorLabs Z812B stepper motor and takes voltage measurements using an Agilent ADC board.

## Installation Instructions
This software uses Matlab to determine the confidence levels and Python3 to move the stepper motor and take measurements using the ADC.
This software was developed on Linux Mint 18.1 and the following installation instructions are for this OS. 

### Installing Matlab
Matlab is available through [MSU ITC](http://www.montana.edu/itcenter/purchase/matlab/index.html). Follow the instructions provided in
the link to install Matlab on Linux Mint.

### Installing Python3 Dependencies
Python3 is already installed in Linux Mint by default. However, there are a few needed dependencies to use the Agilent ADC and the
ThorLabs stepper motor. These dependencies are installed using the command
```
sudo apt install python3-pip
sudo pip3 install pyserial
sudo pip3 install setuptools
sudo pip3 install pyusb
```

### Installing the Matlab-Python engine
The instructions for installing the Matlab-Python engine can be found [here](https://www.mathworks.com/help/matlab/matlab_external/install-the-matlab-engine-for-python.html),
but the commands are as follows:
```
cd /usr/local/MATLAB/extern/engines/python/
python3 setup.py install
```

### Running Without Superuser Privledges
By default, the USB system requires sudo privledges to access. We can circumvent this by copying the file '51-thorpy.rules' in the root of this repo into the directory '/etc/udev/rules.d/' and adding the desired user to the 'usbusers' group. This is done by:
```
sudo addgroup usbusers
sudo usermod -a -G usbusers <myUsername>
```
After a system restart, the system should be ready to take measurements.

