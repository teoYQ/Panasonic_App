import serial

port = "ttyACM0"
ser = serial.Serial("/dev/"+port,115200, timeout =1)
ser.write("i")
while True:
    ser.readline().decode()
