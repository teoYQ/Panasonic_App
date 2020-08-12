# -*- coding: utf-8 -*-
"""
Created on Wed Aug 12 09:04:13 2020

@author: Jen Yang
"""


from selenium import webdriver

def predict_surface_area(incubator_name):
    '''find the usb port from dictionary'''
    '''Send command, Start the camera webserver, read the URL from'''
    '''save the URL as link'''
    link = "https://images.squarespace-cdn.com/content/v1/54243095e4b07ee637a9f812/1453928703877-3DRM2QGZ4DBUUXFE4434/ke17ZwdGBToddI8pDm48kBj6LGIT7OGJpY2i066AwL0UqsxRUqqbr1mOJYKfIPR7LoDQ9mXPOjoJoqy81S2I8N_N4V1vUb5AoIIIbLZhVYxCRW4BPu10St3TBAUQYVKcR8-sEVXP4LHRq5_-YybNmiQvS4IcXRcYxajYBzcdkIPfTkQIP6HpcIVJJrvKfBbV/raziel_angel_seraphim_mysteries_Mohrbacher?format=1000w"
    driver = webdriver.Chrome(r"C:/Users/Jen Yang/Downloads/chromedriver_win32/chromedriver.exe")
    #driver = webdriver.Chrome(executable_path='/path/to/chromedriver') //linux
    driver.get(link)
    driver.save_screenshot("test_screenshot.png")
    '''run function,get prediction'''
    '''pull this incubator's list of previous predictions'''
    '''update, push updated list'''
    #done