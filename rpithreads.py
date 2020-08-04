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
#incubator_name = "Carrot 2"
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
device_queue = queue.Queue()
registered_queue = queue.Queue()

cred = credentials.Certificate("/home/pi/Downloads/capst0ned-firebase-adminsdk-oxj6s-7003ae62a1.json")
firebase_admin.initialize_app(cred,{'databaseURL': 'https://capst0ned.firebaseio.com/'})

'''' helper functions '''
def read_inc_data(username,incubator_name):
    ref = db.reference(username + "/" + incubator_name)
    return ref.get()
    # print()
    
def send_command(port,command):
    ser = serial.Serial("/dev/"+port,115200, timeout =1)
    ser.write(str.encode(command))
    
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

'''raw startup : worker definitions '''
def incubator_subprocess():
    #name = register_new_incubator(new_incubator_name, pwd)
    read_inc_data_every_n_seconds(name,new_incubator_name,5)

def thread_function(name):
    logging.info("Central Thread: starting")
    incubator_subprocess()
    logging.info("Central Thread: finishing")

def updates_handler():
    logging.info("Update thread: starting")
    handle_updates()
    logging.info("Update thread: finishing")

def usb_handler():
    logging.info("USB Handling Thread : starting")
    usb_detection()
    logging.info("USB Handling Thread : finishing")

def registration_handler():
    logging.info("Registration Thread : starting")
    registration()
    logging.info("Registration Thread : finishing")

'''actual work'''
def handle_updates():
    ##setup
    duration = 5
    attached_devices = {}
    active_devices = {}
    while True:
        #poll both queues for any updates
        if device_queue.empty() != True:
            (new_device,action) = device_queue.get()
            if action == "added":
                attached_devices[new_device] = action
                print(new_device+ " connection added",attached_devices,active_devices)
            elif action == "removed":
                del attached_devices[new_device]
                del active_devices[new_device]
                print(new_device + " removed",attached_devices,active_devices)
        else:
            print("Update thread: no new connections")
        if registered_queue.empty() != True:
            (inc_name,user_name) = registered_queue.get()
            if attached_devices[inc_name] == "added":
                attached_devices[inc_name] = "active" #change state, make active instead of just added
                active_devices[inc_name] = user_name
                print("active devices : ",active_devices)
        else:
            print("Update thread: no new registration confirmations")
        time.sleep(duration)
        
def usb_detection():
    plant_units = {}
    usb_conns = {}
    cmd = "./dmsgts.sh 5"
    old_results= [""]
    while True:
        print("USB Handler: checking USB devices")
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
                         removed_device = usb_conns[location]
                         del usb_conns[location]
                         del plant_units[removed_device]
                         device_queue.put((removed_device,"removed"))
                     elif "attached" in thing:
                         print("attempting to query " + location)
                         namequery = False
                         ser = serial.Serial("/dev/"+location,115200, timeout =1)
                         ser.write(str.encode('i'))
                         while namequery == False:
                                 namepwd = ser.readline().decode().rstrip().split(",")
                                 print(namepwd)
                                 name = namepwd[0]
                                 pwd = namepwd[1]
                                 if name:
                                     print("NAME FOUND: NAME IS " + name, "PWD IS : " + pwd)
                                     plant_units[name] = location
                                     usb_conns[location] = name
                                     print(plant_units.items())
                                     device_queue.put((name,"added"))
                                     registration_queue.put((name,pwd))
                                     namequery = True
                     else:
                          print(thing)
            old_results.append(thing)
        if commands.empty() != True:
            item = commands.get()
            print("Got new command, ", item)
            commands.task_done()
        else:
            print("USB Handler : No new commands at the time")
        time.sleep(3)

def registration():
    # cred = credentials.Certificate("/home/pi/Downloads/capst0ned-firebase-adminsdk-oxj6s-7003ae62a1.json")
    # firebase_admin.initialize_app(cred,{'databaseURL': 'https://capst0ned.firebaseio.com/'})
    while True:
        if registration_queue.empty() != True:
            item = registration_queue.get()
            incubator_name,new_pwd = item
            print("checking if " + incubator_name + " is registered")
            incref = db.reference("Active Incubators/"+incubator_name)
            activeinc = incref.get()
            print("ACTIVE INC",activeinc)
            if activeinc != None:
                if "registered" not in activeinc:
                    print(incubator_name + " still pending registration...")
                else:
                    print(incubator_name + " already " + activeinc)
                    user_name = " ".join(activeinc.split(" ")[2:])
                    registered_queue.put((incubator_name,user_name))
            else:
                print("registering new incubator " + incubator_name)
                user_name = register_new_incubator(incubator_name,new_pwd)
                print(incubator_name + " successfully registered under " + user_name)
                registered_queue.put((incubator_name,user_name))

if __name__ == "__main__":
    format = "%(asctime)s: %(message)s"
    logging.basicConfig(format=format, level=logging.INFO,
                        datefmt="%H:%M:%S")
    logging.info("Main    : before creating thread")
    # x = threading.Thread(target=thread_function, args=(1,),daemon=True)
    # logging.info("Main    : before running thread")
    # x.start()
    x = threading.Thread(target=updates_handler,daemon=True)
    logging.info("Main    : before running update thread")
    x.start()
    usbhandler = threading.Thread(target=usb_handler,daemon=True)
    logging.info("Main    : before running usb thread")
    usbhandler.start()
    registrationhandler = threading.Thread(target=registration_handler,daemon=True)
    logging.info("Main    : before running registration thread")
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
