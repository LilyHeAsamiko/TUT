# -*- coding: utf-8 -*-
"""
Created on Mon Jan 15 16:55:57 2018

@author: Asamiko
"""

import matplotlib.pyplot as plt
from matplotlib.image import imread
import numpy as np
#from skimage import color
#from skimage import io



if __name__ == "__main__":
        
    # Read the data
    #img = color.rgb2gray(io.imread('uneven_illumination.png'))
    img = imread("uneven_illumination.png")
    plt.imshow(img, cmap='gray')
    plt.title("Image shape is %dx%d" % (img.shape[1], img.shape[0]))
    plt.show()
    
    # Create the X-Y coordinate pairs in a matrix
    X, Y = np.meshgrid(range(1300), range(1030))
    Z = img
    
    x = X.ravel()
    y = Y.ravel()
    z = Z.ravel()
    
    # ********* TODO 1 **********
    # Create data matrix
    # Use function "np.column_stack".
    # Function "np.ones_like" creates a vector like the input.
    
    x_sqrd = x * x
    y_sqrd = y * y
    xy = np.multiply(x, y)
    ones = np.ones_like(x)
    H = np.column_stack([x_sqrd, y_sqrd, xy, x, y, ones])
    
    # ********* TODO 2 **********
    # Solve coefficients
    # Use np.linalg.lstsq
    # Put coefficients to variable "theta" which we use below.
    H = np.matrix(H)
    z = np.matrix(z)
    
    #theta = np.linalg.inv((H.T @ H)) @ (H.T @ z.T)
    """
    H2 = np.dot(H.transpose(), H)
    H2_inv = np.linalg.inv(H2)
    H3 = np.dot(H2, H.transpose())
    theta = np.dot(H3, z)
    """
    theta = np.linalg.lstsq(H,z)[0]
    # Predict
    z_pred = np.dot(H,theta)
    Z_pred = np.reshape(z_pred, X.shape)
    
    
    # Subtract & show
    S = Z - Z_pred
    
    plt.imshow(S, cmap = 'gray')
    plt.show()
    
