# -*- coding: utf-8 -*-
"""
Created on Wed Aug 12 09:04:13 2020

@author: Jen Yang
"""
from selenium import webdriver
import serial
import time
from PIL import Image
# import io
#from matplotlib import pyplot
from cv2 import imread
import numpy as np
import camera_script
def predict_surface_area(username,incubatorname,usb_port):
    '''find the usb port from dictionary'''
    '''Send command, Start the camera webserver, read the URL from'''
    '''save the URL as link'''
    ser = serial.Serial("/dev/"+usb_port, 115200, timeout = 1)
    cmd = "c"
    ser.write(str.encode(cmd))
    link_received = False
#     time.sleep(10)
    while link_received == False:
        link = ser.readline().decode().rstrip()
        if cmd == "c":
            if "Camera Ready" in link:
                link = link.split()[3].replace("'",'')
                print(link)
                link_received = True
              #link = "https://images.squarespace-cdn.com/content/v1/54243095e4b07ee637a9f812/1453928703877-3DRM2QGZ4DBUUXFE4434/ke17ZwdGBToddI8pDm48kBj6LGIT7OGJpY2i066AwL0UqsxRUqqbr1mOJYKfIPR7LoDQ9mXPOjoJoqy81S2I8N_N4V1vUb5AoIIIbLZhVYxCRW4BPu10St3TBAUQYVKcR8-sEVXP4LHRq5_-YybNmiQvS4IcXRcYxajYBzcdkIPfTkQIP6HpcIVJJrvKfBbV/raziel_angel_seraphim_mysteries_Mohrbacher?format=1000w"
              #driver = webdriver.Chrome(r"C:/Users/Jen Yang/Downloads/chromedriver_win32/chromedriver.exe")
              #driver = webdriver.Firefox(executable_path = r"/home/pi/Downloads/geckodriver")
                driver = webdriver.Chrome()
                driver.get(link)
                time.sleep(5)
                button = driver.find_element_by_id("get-still")
                button.click()
                time.sleep(15)
                img = driver.find_element_by_id("stream").screenshot_as_png
#                 print(img)
#                 print(type(img))
                #im = Image.open(BytesIO(img))
                #im.save("/home/pi/Downloads/waduhek")
                f = open("/home/pi/"+username+"/"+incubatorname+'.jpg','wb')
                f.write(img)
                f.close()
                cimg = np.array(Image.open("/home/pi/"+username+"/"+incubatorname+'.jpg'))
                cropped = cimg[20:200,60:220]
                Image.fromarray(cropped).save("/home/pi/"+username+"/"+incubatorname+'.png')
                croppedjpg = Image.open("/home/pi/"+username+"/"+incubatorname+'.png').convert('RGB')
                croppedjpg.save("/home/pi/"+username+"/"+incubatorname+'.jpg')
                #eff = open('waduuuhek_cropped.jpg','wb')
                #eff.write(cropped)
                #eff.close()
#                pyplot.imsave("/home/pi/Downloads/waduhek.png",img)
#                 imageStream = io.BytesIO(img)
#                 im = Image.open(imageStream)
#                 im.save("/home/pi/Downloads/waduhek","RGBA")
                #driver.save_screenshot("test_screenshot.png")
                driver.quit()
                (raw,percentage) = camera_script.run_image_processing_workflow2("/home/pi/"+username+"/"+incubatorname+'.jpg')
                return raw,percentage
        else:
            if link != "":
                print(link)
#                 link_received = True
                return link
#predict_surface_area("lmao")

    #link = "https://images.squarespace-cdn.com/content/v1/54243095e4b07ee637a9f812/1453928703877-3DRM2QGZ4DBUUXFE4434/ke17ZwdGBToddI8pDm48kBj6LGIT7OGJpY2i066AwL0UqsxRUqqbr1mOJYKfIPR7LoDQ9mXPOjoJoqy81S2I8N_N4V1vUb5AoIIIbLZhVYxCRW4BPu10St3TBAUQYVKcR8-sEVXP4LHRq5_-YybNmiQvS4IcXRcYxajYBzcdkIPfTkQIP6HpcIVJJrvKfBbV/raziel_angel_seraphim_mysteries_Mohrbacher?format=1000w"
    #driver = webdriver.Chrome(r"C:/Users/Jen Yang/Downloads/chromedriver_win32/chromedriver.exe")
    #driver = webdriver.Chrome(executable_path='/path/to/chromedriver') //linux
    #driver.get(link)
    #driver.save_screenshot("test_screenshot.png")
    #'''run function,get prediction'''
    #'''pull this incubator's list of previous predictions'''
    #'''update, push updated list'''
    #done
#predict_surface_area()
