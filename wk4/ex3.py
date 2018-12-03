# -*- coding: utf-8 -*-
"""
Created on Mon Jan 29 14:11:52 2018

@author: Asamiko
"""

import glob
import numpy as np
from matplotlib.image import imread
from skimage.feature import local_binary_pattern


def load_GTSRB():
    Class1 = []
    Class2 = []
    GT = [] #ground truth
    
    C1files = glob.glob(r'''C:\ml\GTSRB_subset\class1\*.jpg''' )
    C2files = glob.glob(r'''C:\ml\GTSRB_subset\class2\*.jpg''' )
    
    radius = 5
    n_points = 8
    
    for file in C1files:
        img = imread(file)
        lbp = local_binary_pattern(img, n_points, radius)
        hist = np.histogram(lbp, bins = range(0,256))[0]
        Class1.append(hist)
        GT.append(0)
    
    for file in C2files:
        img = imread(file)
        lbp = local_binary_pattern(img, n_points, radius)
        hist = np.histogram(lbp, bins = range(0,256))[0]
        Class2.append(hist)
        GT.append(1)
    
    X = np.concatenate((Class1,Class2),axis=0)
    return X,GT

def gaussian(x,mu,sigma):
    x = x.astype(float)
    mu = float(mu)
    sigma = float(sigma)
    var = np.power(sigma,2)
    
    p1 = 1/np.sqrt(2*np.pi*var)
    p2 = np.exp(-1/(2*var) * np.power((x-mu),2))
    return (p1 * p2)

def log_gaussian(x,mu,sigma):
    x = x.astype(float)
    mu = float(mu)
    sigma = float(sigma)
    var = np.power(sigma,2)
    
    term1 = np.log(1/np.sqrt(2*np.pi*var))
    term2 = -1/(2*var) * np.power((x-mu),2)
    p = term1 + term2
    return p

from sklearn.neighbors import KNeighborsClassifier
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis
from sklearn.svm import SVC
from sklearn.cross_validation import train_test_split
from sklearn.metrics import accuracy_score

X, GT = load_GTSRB()
X_train,X_test,y_train,y_test = train_test_split(X,GT)

KNN = KNeighborsClassifier(n_neighbors = 3)
KNN.fit(X_train,y_train)
KNN_pred = KNN.predict(X_test)

LDA = LinearDiscriminantAnalysis()
LDA.fit(X_train,y_train)
LDA_pred = LDA.predict(X_test)

SVC_ = SVC(kernel = 'linear')
SVC_.fit(X_train,y_train)
SVC_pred = SVC_.predict(X_test)

predictions = [KNN_pred, LDA_pred, SVC_pred]
scores = []
for y_pred in predictions:
    scores.append(accuracy_score(y_test,y_pred))
    
import matplotlib.pyplot as plt

x = np.linspace(-5,5,num=500)
plt.plot(x,gaussian(x,0,1))
plt.plot(x,log_gaussian(x,0,1))