# -*- coding: utf-8 -*-
"""
Created on Sat Jan 20 13:30:32 2018

@author: Konsta Peltoniemi
"""

import numpy as np
import matplotlib.pyplot as plt
from sklearn.preprocessing import LabelEncoder
from sklearn.model_selection import train_test_split
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis
from sklearn.metrics import accuracy_score

y_data = np.genfromtxt('y_train.csv', dtype=str, delimiter=',')
le = LabelEncoder()

X = np.load('X_train.npy')
y = le.fit_transform(y_data[1:,1]) #train using these
#X_test = np.load('X_test.npy') #task is to find class for these
X_train, X_test, y_train, y_test = train_test_split(X,y, test_size=0.2)

X_train_pixels = np.reshape(X_train,(3600,20040), order='C')
X_test_pixels = np.reshape(X_test,(900,20040), order='C')

X_train_freq = np.mean(X_train, axis = 2)
X_test_freq = np.mean(X_test, axis = 2)

X_train_time = np.mean(X_train, axis = 1)
X_test_time = np.mean(X_test, axis = 1)
C = 0
for C in np.linspace(0,1,10):
    model = LinearDiscriminantAnalysis(shrinkage = C)
    model.fit(X_train_pixels,y_train)
    y_pred = model.predict(X_test_pixels)
    acc = accuracy_score(y_test, y_pred)

a = X_train[1,:,:]
plt.imshow(a)

