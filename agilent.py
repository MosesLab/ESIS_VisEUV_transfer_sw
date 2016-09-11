# Impromptu library for taking voltage measurements with Agilent 34970A
import serial

# Commands the agilent to read voltage on specified number of ports
command = "MEASure:VOLTage:DC? (@101)\n"

#Function to Initialize the Serial Port
def init_serial():
    ser = serial.Serial()
    ser.baudrate = 9600   #Determines baud rate (rate at which information is transferred in a communication channel). 9600 bits/second.

    ser.port = '/dev/ttyUSB0'

    #Sets the TimeOut in seconds, so that SerialPort doesn't miscommunicate
    ser.timeout = 10
    ser.open()			#Opens SerialPort

    # print if port is open or closed
    if ser.isOpen():
        print('Open: ' + ser.portstr)

    return ser


# Reads one measurement from A/D
def measure(ser):
    ser.write(command)
    bytes = ser.readline()  #Reads from SerialPort
    return bytes