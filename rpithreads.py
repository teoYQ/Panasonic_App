# -*- coding: utf-8 -*-
"""
Created on Sun Jun 28 14:57:37 2020

@author: Jen Yang
"""

# -*- coding: utf-8 -*-
"""
Created on Sat Jun 27 15:35:12 2020

@author: Jen Yang
"""
import firebase_admin
from firebase_admin import db
from firebase_admin import credentials
import threading, queue
import time
import logging
import sys
import os
import pyudev
import pprint
import subprocess
import shlex
import serial

name = "duckduckgoat"
incubator_name = "Carrot 2"
new_incubator_name = "Technical Unit"
pwd = "109db4a63b9cbdf01e3d74e3406baadwadwaedf"
current_config = {
    "dose" : 0,
    "lights" : "On",
    "temperature" : "25",
    }
stop_threads = False

q = queue.Queue()
commands = queue.Queue()
registration_queue = queue.Queue()

cred = credentials.Certificate("/home/pi/Downloads/capst0ned-firebase-adminsdk-oxj6s-7003ae62a1.json")
firebase_admin.initialize_app(cred,{'databaseURL': 'https://capst0ned.firebaseio.com/'})
def read_inc_data(username,incubator_name):
    ref = db.reference(username + "/" + incubator_name)
    return ref.get()
    # print()

# class IncubatorData(username,incubator_name):
#     def __init__(self):
#         self.object_lock = threading.Lock()
#         self.data = {}
#         self.username = username
#         self.incubator_name = incubator_name
    
#     def get_data(self):
#         if self.object_lock != "available":
#             return "Object in use; please try again later"
#         else:
#             return self.data        
        
#     def set_data(self,new_data):
#         if self.object_lock != "available":
#             return "Object in use; please try again later"
#         else:
#             return "ok"

def compare_jsons(old_data,new_data):
    ok = set(old_data.keys())
    nk = set(new_data.keys())
    addedkeys = ok-nk
    removedkeys = nk-ok
    # print(addedkeys,removedkeys)
    ans1p2 = addedkeys,removedkeys
    if len(addedkeys) + len(removedkeys) == 0:
        print("Data sanity check")
        ans1p1 = "No keys changed"
        ##all clear, continue with checking values change
        changed_values = []
        for key in nk:
            ov = old_data[key]
            nv = new_data[key]
            if nv != ov:
                changed_values.append((key,nv))
        ans2 = changed_values
    else: 
        print("New elements,",addedkeys,removedkeys)
        ans1p1 = "Key change found"
        ans2 = "emptystr"
    ans1 = ans1p1,ans1p2
    return ans1,ans2
    
    
def read_inc_data_every_n_seconds(username,incubator_name,n):
    old_data = read_inc_data(username,incubator_name)
    while stop_threads != True:
        time.sleep(n)
        new_data = read_inc_data(username,incubator_name)
        ans1,ans2 = compare_jsons(old_data,new_data)
        #do stuff with new data
        if type(ans2) == list:
            if len(ans2) != 0:
                print(ans2)
                q.put(ans2)
            else:
                print("No changes observed")
        #done with stuff, reset data
        old_data = new_data
    else:
        print("TERMINATING SUBPROCESS")
        return "Exited subprocess cleanly"
        # sys.exit()
        # print(list(q))
        # print(ans2)
        
# n = 5
# read_inc_data_every_n_seconds(username, incubator_name, n)

def register_new_incubator(incubator_name,new_pwd):
    submitted_pwds = db.reference("Submitted Passwords")
    airef = db.reference("Active Incubators")
    airef.child(incubator_name).set(new_pwd)
    found = False
    while found == False:
        #check_active_users_for_pwd
        time.sleep(5)
        user_and_pwd = submitted_pwds.get()
        for item in user_and_pwd.items():
            print(item)
            name,pwd = item
            if pwd == new_pwd:
                airef.child(incubator_name).set("registered to " + name)
                userref = db.reference(name)
                userref.child(incubator_name).set(current_config)
                print("New incubator registered under user " + name)
                found = True
    return name

#raw startup
def incubator_subprocess():
    #name = register_new_incubator(new_incubator_name, pwd)
    read_inc_data_every_n_seconds(name,new_incubator_name,5)

def thread_function(name):
    logging.info("Central Thread: starting")
    incubator_subprocess()
    logging.info("Central Thread: finishing")


def usb_handler():
    logging.info("Thread %s: starting", name)
    usb_detection()
    logging.info("Thread %s: finishing", name)

def registration_handler():
    logging.info("Thread %s: starting", name)
    registration()
    logging.info("Thread %s: finishing", name)

def usb_detection():
    plant_units = {}
    active_workers = []
    cmd = "./dmsgts.sh 5"
#    cmd = "ls"
    old_results= [""]
#     for thing in result:
#         print(thing) 
#     result = subprocess.run(['lsusb'],stdout=subprocess.PIPE).stdout.decode('utf-8').split("\n")
#     print("checking USB devices")
#     for thing in result:
#         print(thing)
#         if thing not in old_results:
#              print("WAO " + thing)
#         old_results.append(thing)
    while True:
        print("checking USB devices")
        result = subprocess.run(cmd,stdout=subprocess.PIPE,shell=True).stdout.decode('utf-8').split("\n")
        for thing in result:
            if thing not in old_results:
                 if "ch341-uart converter" in thing:
#                      location = thing.split(":")[0].split(" ")[-1]
                     location = thing.split(" ")[-1]
                     print(location)
                     #prefix = "/dev/serial/by-path/platform-fd500000.pcie-pci-0000:01:00.0-usb-0:"+location+".0-port0"
                     if "disconnected" in thing:
                         print(thing)
                     elif "attached" in thing:
                         print("attempting to query " + location)
                         namequery = False
                         ser = serial.Serial("/dev/"+location,115200, timeout =1)
                         ser.write(str.encode('i'))
                         while namequery == False:
                                 namepwd = ser.readline().decode().strip().split(",")
                                 name = namepwd[0]
                                 pwd = namepwd[1]
                                 print(name)
                                 if name:
                                     print("NAME FOUND: NAME IS " + name, "PWD IS : " + pwd)
                                     plant_units[name] = location
                                     print(plant_units.items())
                                     registration_queue.add((name,pwd))
                                     namequery = True
                     else:
                          print(thing)
            old_results.append(thing)
        if commands.empty() != True:
            item = commands.get()
            print("Got new command, ", item)
            commands.task_done()
        else:
            print("No new commands at the time")
        time.sleep(3)

def registration(inc_name):
    cred = credentials.Certificate("/home/pi/Downloads/capst0ned-firebase-adminsdk-oxj6s-7003ae62a1.json")
    firebase_admin.initialize_app(cred,{'databaseURL': 'https://capst0ned.firebaseio.com/'})
    while True:
        if registration_queue.empty() != True:
            item = registration_queue.get()
            incubator_name,new_pwd = item
            print("checking if " + item + " is registered")
            incref = db.reference("Active Incubators/"+item)
            activeinc = incref.get()
            if activeinc != None:
                if "registered" not in activeinc:
                    register_new_incubator(incubator_name,new_pwd)
                else:
                    print(incubator_name + " already " + activeinc)
def specific_worker(port):
    namequery = False
    send_command(location)
    while namequery == False:
        name = ser.readline()
        namequery = True
    
    send_command
def send_command(port):
    ser = serial.Serial("/dev/"+port,115200, timeout =1)
    ser.write('i')
    
#         if "QinHeng Electronics HL-340 USB-Serial" in thing:
#            plant_unit
#     cmd = "dmesg | grep tty"
#     process = subprocess.Popen(shlex.split(cmd),stdout=subprocess.PIPE,shell=True)
#     while True:
#         output = process.stdout.readline()
#         if output == '' and process.poll() is not None:
#             break
#         if output:
#             print(output.strip())
        
    
    print(result)
#     context = pyudev.Context()
#     old_devices = context.list_devices()
#     
#     for device in old_devices:
#         pprint.pprint(dict(device))
#     while True:
#         for device in context.list_devices():
#             if device not in old_devices:
#                 print("new device found: " + ppprint.pprint(dict(device)))
#                 old_devices.append(device)

if __name__ == "__main__":
    format = "%(asctime)s: %(message)s"
    logging.basicConfig(format=format, level=logging.INFO,
                        datefmt="%H:%M:%S")
    logging.info("Main    : before creating thread")
    x = threading.Thread(target=thread_function, args=(1,),daemon=True)
    logging.info("Main    : before running thread")
    x.start()
    usbhandler = threading.Thread(target=usb_handler,daemon=True)
    logging.info("Main    : before running thread")
    usbhandler.start()
    registrationhandler = threading.Thread(target=registration_handler,daemon=True)
    logging.info("Main    : before running thread")
    registrationhandler.start()
    # while True:
    #     if q.empty() != True:
    #         item = q.get()
    #         print("Got item from queue, ", item)
    #         q.task_done()
    try:
        while True:
            if q.empty() != True:
                item = q.get()
                print("Got item from queue, ", item)
                commands.put(item)
                q.task_done()
    except (KeyboardInterrupt,SystemExit):
        print("Stopping main process;killing threads...")
        stop_threads = True
        x.join()
        logging.info("Main    : all done")
        sys.exit()
        

# firebase_admin.initialize_app(cred, {    'databaseURL': 'https://capst0ned.firebaseio.com/'})
# var database = firebase.database();
# mainref = db.reference(username)
# print(ref.get())