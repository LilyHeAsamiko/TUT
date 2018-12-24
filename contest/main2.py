# -*- coding: utf-8 -*-
"""
Created on Sat Feb  3 14:10:17 2018

@author: pc
"""


import numpy as np
import matplotlib.pyplot as plt
import sklearn
import skimage.feature

#from scipy.io import loadmat
from matplotlib.image import imread
from math import pi
from sklearn.datasets import load_digits
from sklearn.cross_validation import train_test_split
from sklearn.neighbors import KNeighborsClassifier
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis
from sklearn.metrics import accuracy_score
from sklearn.svm import SVC
from sklearn.preprocessing import LabelEncoder
from sklearn.ensemble import RandomForestClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.preprocessing import LabelEncoder

   
if __name__ == "__main__":
    
    X_train = np.load('X_train.npy')
    X_test = np.load('X_test.npy')
           
    FILE = open("crossvalidation_train.csv", 'r')
    Y_train = []
    TTs = []
    
    for line in FILE:
        
        values = line.split(',')
        if values[0] == 'id':
            continue
        Y_train.append(values[1])
        TTs.append(values[2])
        
        
    le = LabelEncoder()
    Y_train = np.array(Y_train)
    Y_train = le.fit_transform(Y_train)
    TTs = np.array(TTs)
    
    x_train, x_test, y_train, y_test = [],[],[],[]# cross_train_x =[]
    
    for i in range(0,np.size(X_train,0)):
        if TTs[i] == 'train\n':
            x_train.append(X_train[i,:,:])
            y_train.append(Y_train[i])
        else:
            x_test.append(X_train[i,:,:])
            y_test.append(Y_train[i])
            
    x_train = np.array(x_train)
    y_train = np.array(y_train)
    x_test = np.array(x_test)
    y_test = np.array(y_test)
            
    '''
    for i in range(5):
        plt.subplot(5,1,i+1)
        plt.imshow(X_train[i+5,:,:])
    '''
    
    X_train_pixels = np.reshape(x_train, (3268, 20040))
    X_test_pixels = np.reshape(x_test, (1232, 20040))
       
    X_train_freq = np.mean(x_train, axis = 2)
    X_test_freq = np.mean(x_test, axis = 2)
    
    X_train_time = np.mean(X_train, axis = 1)
    X_test_time = np.mean(X_test, axis = 1)
    
    X_train_std=np.std(x_train,axis=2)
    X_test_std=np.std(x_test,axis=2)
    
    feature= np.concatenate((X_train_freq,X_train_std),axis=1)
    feature_test= np.concatenate((X_test_freq,X_test_std),axis=1)
    #feature = X_train_freq
    #feature_test = X_test_freq
    
    lda = LinearDiscriminantAnalysis()
    lda.fit(feature,y_train)
    y_pred = lda.predict(feature_test)
    print('LDA', accuracy_score(y_test, y_pred))
    
    svcRBF = SVC(kernel='rbf', gamma='auto', C=1)
    svcRBF.fit(feature,y_train)
    y_pred = svcRBF.predict(feature_test)
    print('SVC_rbf kernel', accuracy_score(y_test, y_pred))
    
    LogReg = LogisticRegression(C=1)
    LogReg.fit(feature,y_train)
    y_pred = LogReg.predict(feature_test)
    print('Logistic Regression', accuracy_score(y_test,y_pred))
    
    forest = RandomForestClassifier()
    forest.fit(feature,y_train)
    y_pred = forest.predict(feature_test)
    print('RadomForest', accuracy_score(y_test, y_pred))
    
    svcLin = SVC(kernel ='linear', C=1)
    svcLin.fit(feature,y_train)
    y_pred = svcLin.predict(feature_test)
    print('SVC_linear kernel', accuracy_score(y_test, y_pred))
    
    labels = list(le.inverse_transform(y_pred))
    with open("submission.csv", "w") as fp:
        fp.write("Id,Scene_label\n")
        for i, label in enumerate(labels):
            fp.write("%d,%s\n" % (i, label))

     
