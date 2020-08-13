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
from signal import pause
import rpiSelenium
from datetime import datetime
#name = "duckduckgoat"
#incubator_name = "Carrot 2"
new_incubator_name = "Technical Unit"
pwd = "109db4a63b9cbdf01e3d74e3406baadwadwaedf"
current_config = {
    "dose" : 0,
    "lights" : "Off",
    "temperature" : 25,
    "sensor" : 0,
    "fertiliser" : 1,
    }
stop_threads = False

q = queue.Queue()
commands = queue.Queue()
registration_queue = queue.Queue()
device_queue = queue.Queue()
registered_queue = queue.Queue()
tech_queue = queue.Queue()
temp_queue = queue.Queue()
feedback_queue = queue.Queue()

cred = credentials.Certificate("/home/pi/Downloads/capst0ned-firebase-adminsdk-oxj6s-7003ae62a1.json")
firebase_admin.initialize_app(cred,{'databaseURL': 'https://capst0ned.firebaseio.com/'})

'''' helper functions '''
def read_inc_data(username,incubator_name):
    ref = db.reference(username + "/" + incubator_name)
    return ref.get()
    # print()
    
def send_command(port,command):
    print(str(command) + " sent to port " + port)
    ser = serial.Serial("/dev/"+port,115200, timeout =1)
    if type(command) == str:
        command = str.encode(command)
    elif type(command) == int:
        pass
    ser.write(command)
    
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
            uname,pwd = item
            if pwd == new_pwd:
                print(uname)
                airef.child(incubator_name).set("registered to " + uname)
                userref = db.reference(uname)
                userref.child(incubator_name).set(current_config)
                print("New incubator registered under user " + uname)
                found = True
                print("final : " + uname)
                return uname
    
def query_techunit(port,cmd):
    response = None
    techser = serial.Serial("/dev/"+port,115200,timeout=1)
    techser.write(str.encode(cmd))
    while response == None:        
        techunitresponse = techser.readline().decode().rstrip()
        if techunitresponse != None and techunitresponse != "":
            return techunitresponse
        
        
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
    
def tech_unit_handler():
    logging.info("Registration Thread : starting")
    tech_unit()
    logging.info("Registration Thread : finishing")

'''actual work'''
def handle_updates():
    ##setup
    current_day = datetime.today().date()
    trigger = True
    duration = 2
    previous_lowest_temp = None
    attached_devices = {}
    active_devices = {}
    active_devices_data = {}
    active_devices_temp = {}
    while True:
        ##New Connections/Active Devices
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
                init_data_ref = db.reference(user_name+"/"+inc_name)
                init_data = init_data_ref.get()
                active_devices_data[inc_name] = init_data #initialise data for comparison
                active_devices_temp[inc_name] = init_data["temperature"]
                print("active devices : ",active_devices)
        else:
            print("Update thread: no new registration confirmations")
        if list(active_devices.keys()) != []:
            if trigger != False:
                for active_inc in active_devices.keys():
                    commands.put((active_inc,("c",active_devices[active_inc])))
                trigger = False;
            else:
                if datetime.today().date() != current_day:
                    for active_inc in active_devices.keys():
                        commands.put((active_inc,("c",active_devices[active_inc])))
        current_day = datetime.today().date()
        ##New Updates/Commands
        if list(active_devices.keys()) != []:
            for active_inc in active_devices.keys():
                print(active_inc)
                ##do actual commands
                new_data_ref = db.reference(user_name+"/"+active_inc)
                flag = False
                while flag != True:
                    new_data = new_data_ref.get()
                    if new_data != None:
                        flag = True
                    else:
                        time.sleep(2)
                if new_data != None:
                    changed_keys,changed_values=compare_jsons(active_devices_data[active_inc],new_data)
                    if type(changed_values) == list:
                        for change in changed_values:
                            if change[0] == "temperature":
#                                 temperature =
#                                 print("temp change recognised")
                                active_devices_data[active_inc][change[0]] = change[1]
                                active_devices_temp[active_inc] = change[1]
                                if min(active_devices_temp.values()) == change[1] and list(active_devices_temp.values()).count(change[1]) == 1:
                                    temp_queue.put(change[1])
                                    print("New lowest temp recorded : " + str(change[1]))
                                    for user,iname in active_devices.items():
                                        if iname != active_inc:
                                            db.reference(user+"/"+iname+"/temperature").set(change[1])
                                elif min(active_devices_temp.values()) == change[1] and list(active_devices_temp.values()).count(change[1]) != 1:
                                    print("ignoring this temp update for " + active_inc +"; rebound from previous temp setting...")
                                else:
                                    print("waduhek")
                            else:
                                commands.put((active_inc,change))
                                active_devices_data[active_inc][change[0]] = change[1]
                else:
                    print("No changes observed for active plant unit " + active_inc)
        ## check feedback queue and update all incs accordingly
        if feedback_queue.empty() != True:
            (tupdate,tvalue) = feedback_queue.get()
            print(tupdate,tvalue)
            for (inm,unm) in active_devices.items():
                print("updating " + unm + "/" + inm + "/" + tupdate + " with value " + str(tvalue))
                db.reference(unm + "/" + inm + "/" + tupdate).set(tvalue)
        time.sleep(duration)
        
def usb_detection():
    instructions = {
        "dose" : {0:"r",1:"R"},
        "lights" : {"On":"W","Off":"w"},
#         "sensor" : {0:0,1:1},
#         "fertiliser" : {0:0,1:1},
        "growth" : {datetime.today().date():0},
        "temperature" : 2,
        }
    plant_units = {}
    usb_conns = {}
    tech_unit = None
    cmd = "./dmsgts.sh 5"
    scanusb = "./scanusb.sh"
    old_results= [""]
    #first run, scan current devices
    print("USB Handler : First scan")
    currently_connected = subprocess.run(scanusb,stdout=subprocess.PIPE,shell=True).stdout.decode('utf-8').split("\n")
    #currently_connected = subprocess.run(scanusb,shell=True)
    for currently_connected_device in currently_connected:
        print(currently_connected_device)
        if "USB2.0-Serial" in currently_connected_device:
            location = currently_connected_device.split(" - ")[0].split("/")[-1]
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
        elif "Arduino" in currently_connected_device:
            location = currently_connected_device.split(" - ")[0].split("/")[-1]
            print("attempting to query /dev/" + location + " for tech unit")
            technamequery = False
            techser = serial.Serial("/dev/"+location,115200, timeout =1)
            time.sleep(10)
            techser.write(str.encode("i"))
            while technamequery == False:
                 techunitname = techser.readline().decode().rstrip()
                 print(techunitname)
                 if techunitname != "":
                     print("TECH UNIT FOUND: NAME IS " + techunitname)
                     #plant_units[techunitname] = location
                     tech_unit = {"name" : techunitname, "location" : location}
                     tech_queue.put((techunitname,location))
                     usb_conns[location] = techunitname
                     technamequery = True
                 else:
                     print("still waiting for tech unit at location " + location + " ...")
    while True:
        print("USB Handler: checking USB devices")
        result = subprocess.run(cmd,stdout=subprocess.PIPE,shell=True).stdout.decode('utf-8').split("\n")
        #result = subprocess.run(cmd,shell=True)
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
            instruction = item[1]
#             if instruction[0] == "temperature":
#                 if tech_unit != None:
#                     #print("send_command(tech_unit[location],idk what to put yet")
#                     temp_queue.put(temperature)
#                     related_port = plant_units[item[0]]
#                     print(item[1][1],type(item[1][1]))
#                     if type(item[1][1]) != dict:
#                         command = instructions[instruction[0]][instruction[1]]
#                         send_command(related_port,command)
#                         commands.task_done()
#                     else:
#                         commands.task_done()
#                 else:
#                     print("tech unit not conected!")
            if instruction[0] == "c":
                print("creating prediction for " + item[0])
                related_port = plant_units[item[0]]
                username = instruction[1]
                raw,percentage = rpiSelenium.predict_surface_area(username,item[0],related_port)
                db.reference(username).child(item[0]).child("growth").child(str(datetime.today().date())).set(percentage)                
            else:
                related_port = plant_units[item[0]]
                print(item[1][1],type(item[1][1]))
                if type(item[1][1]) != dict:
                    if item[1][0] in instructions.keys():
                        command = instructions[instruction[0]][instruction[1]]
                        send_command(related_port,command)
                        commands.task_done()
                    else:
                        print(item, "ignored")
                else:
                    commands.task_done()
        else:
            print("USB Handler : No new commands at the time")
        time.sleep(3)
        
def tech_unit():
    tech_unit = None
    previous_ec = None
    previous_water_level = None
    lowest_temp = None
    ser = None
    ec_change = None
    wl_change = None
    while True:
        #check if there is an update to temp
        while temp_queue.empty() != True:
            new_lowest_temp = temp_queue.get()
            if lowest_temp == None:
                lowest_temp = new_lowest_temp
            else:
                lowest_temp = new_lowest_temp
#                 if lowest_temp > new_lowest_temp:
#                     lowest_temp = new_lowest_temp
#                 else:
#                     print("logic problem for temp, but is ok second check caught it")
        #get tech unit from usbhandler
        while tech_queue.empty() != True:
            tech_unit = tech_queue.get()
            (tech_unit_name,tech_unit_location) = tech_unit
            print("New technical unit registered : ", tech_unit)
            ser = serial.Serial("/dev/"+tech_unit_location,115200, timeout =1)
        if tech_unit != None:
            print(tech_unit)
            print("attempting to query tech unit " + tech_unit[0] + " conditions at " + tech_unit[1])
            status = query_techunit(tech_unit_location,"2")
            print(status)
            temperature,ec,water_level = status.split(";")
            temperature,ec,water_level = float(temperature),float(ec),float(water_level)
            cold_enough = True
            cooling_down = False
            if lowest_temp != None:
                #compare temps
                if temperature > lowest_temp:
                    print("too hot, " + str(temperature) + " > " + str(lowest_temp))
                    cold_enough = False
                elif temperature + 2 < lowest_temp:
                    ser.write('0'.encode('utf-8'))
                    print("cold enough, " + str(temperature) + " < (by 2) " + str(lowest_temp))
                    cold_enough = True
                if cold_enough == False and cooling_down == False:
                    ser.write('1'.encode('utf-8'))
                    print("turning on cooler")
                    cooling_down = True
                elif cold_enough == True and cooling_down == False:
                    ser.write('0'.encode('utf-8'))
                    print("turning off cooler")
                    cooling_down = False
            #parse waterlevels and ec, check if change
            if previous_water_level == None:
                previous_water_level = water_level #init
                print("water level init : ",water_level)
            else:
                if previous_water_level != water_level:
                    wl_change = True
                    print("water level change : ",previous_water_level,water_level)
                    feedback_queue.put(("sensor",water_level))
                else:
                    wl_change = False
            if previous_ec == None:
                previous_ec = ec
                print("ec init")
            else:
                if previous_ec != ec:
                    ec_change = True
                    print("ec change : ",previous_ec,ec)
                    feedback_queue.put(("fertiliser",ec))
                else:
                    ec_change = False
            previous_water_level = water_level
            previous_ec = ec
        else:
            print("No available tech unit...")
        time.sleep(5)
            
def registration():
    # cred = credentials.Certificate("/home/pi/Downloads/capst0ned-firebase-adminsdk-oxj6s-7003ae62a1.json")
    # firebase_admin.initialize_app(cred,{'databaseURL': 'https://capst0ned.firebaseio.com/'})
    while True:
        if registration_queue.empty() != True:
            item = registration_queue.get()
            incubator_name,new_pwd = item
            print("checking if " + incubator_name + " is registered")
            incref = db.reference("Active Incubators/"+incubator_name)
            registered = False
            while registered == False:
                activeinc = incref.get()
                print("ACTIVE INC",activeinc)
                if activeinc != None:
                    if "registered" not in activeinc:
                        print(incubator_name + " still pending registration...")
                    else:
                        print(incubator_name + " already " + activeinc)
                        user_name = " ".join(activeinc.split(" ")[2:])
                        registered_queue.put((incubator_name,user_name))
                        registration_queue.task_done()
                        registered = True
                else:
                    print("registering new incubator " + incubator_name)
                    new_registered_user_name = register_new_incubator(incubator_name,new_pwd)
                    print(incubator_name + " successfully registered under " + new_registered_user_name)
                    registered_queue.put((incubator_name,new_registered_user_name))
                    registration_queue.task_done()
                    registered = True
            
if __name__ == "__main__":
    format = "%(asctime)s: %(message)s"
    logging.basicConfig(format=format, level=logging.INFO,
                        datefmt="%H:%M:%S")
    logging.info("Main    : before creating thread")
    # x = threading.Thread(target=thread_function, args=(1,),daemon=True)
    # logging.info("Main    : before running thread")
    # x.start()
    try:
        x = threading.Thread(target=updates_handler,daemon=True)
        logging.info("Main    : before running update thread")
        x.start()
        usbhandler = threading.Thread(target=usb_handler,daemon=True)
        logging.info("Main    : before running usb thread")
        usbhandler.start()
        registrationhandler = threading.Thread(target=registration_handler,daemon=True)
        logging.info("Main    : before running registration thread")
        registrationhandler.start()
        techunithandler = threading.Thread(target=tech_unit_handler,daemon=True)
        logging.info("Main    : before running tech unit thread")
        techunithandler.start()
        pause()
    # while True:
    #     if q.empty() != True:
    #         item = q.get()
    #         print("Got item from queue, ", item)
    #         q.task_done()
    #try:
    #    while True:
    #        if q.empty() != True:
    #            item = q.get()
    #            print("Got item from queue, ", item)
    #            commands.put(item)
    #            q.task_done()
    except (KeyboardInterrupt,SystemExit):
        print("Stopping main process;killing threads...")
        stop_threads = True
        x.join()
        usbhandler.join()
        registrationhandler.join()
        logging.info("Main    : all done")
        sys.exit()
        

# firebase_admin.initialize_app(cred, {    'databaseURL': 'https://capst0ned.firebaseio.com/'})
# var database = firebase.database();
# mainref = db.reference(username)
# print(ref.get())

