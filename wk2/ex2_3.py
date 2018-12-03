# -*- coding: utf-8 -*-
"""
Created on Mon Jan 15 16:20:21 2018

@author: Asamiko
"""
import numpy as np

if __name__ == "__main__":
    
    X = []
    
    with open('locationData.csv') as fp:
        
        for line in fp:
            
            values = line.split(" ")
            
            values = [float(v) for v in values]
            
            X.append(values)

    X = np.array(X)
    X2 = np.loadtxt('locationData.csv')
    
    is_same = (X==X2).all() #true
    
    
    