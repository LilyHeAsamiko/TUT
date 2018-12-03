# -*- coding: utf-8 -*-
"""
Created on Mon Jan 15 16:39:41 2018

@author: Asamiko
"""

from scipy.io import loadmat
import matplotlib.pyplot as plt

if __name__ == "__main__":
    
    mat = loadmat('twoClassData.mat')
    
    X = mat["X"]
    Y = mat["y"].ravel()
    
    plt.plot(X[Y==0,0], X[Y==0,1], 'ro')
    plt.plot(X[Y==1,0], X[Y==1,1], 'bo')