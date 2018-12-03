# -*- coding: utf-8 -*-
"""
Created on Mon Jan 15 10:34:40 2018

@author: Asamiko
"""


import numpy as np
from sklearn.linear_model import LinearRegression
import matplotlib.pyplot as plt

if __name__ == "__main__":

    X = np.load('x.npy')
    X = X.reshape(-1,1)
    Y = np.load('y.npy')
    Y = Y.reshape(-1,1)
    
    model = LinearRegression()
    model.fit(X,Y)
    y_pred = model.predict(X)
    
    a = model.coef_[0]
    b = model.intercept_

    print("a = ", float(a), "b = ", float(b))
    
    plt.scatter(X,Y)
    
    y1 = a*(-10)+b
    y2 = a*10+b
    
    plt.plot([-10,10],[float(y1),float(y2)])