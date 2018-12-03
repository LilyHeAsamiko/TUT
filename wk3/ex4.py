# -*- coding: utf-8 -*-
"""
Created on Mon Jan 22 13:34:55 2018

@author: Asamiko
"""

from sklearn.datasets import load_digits
from sklearn.cross_validation import train_test_split
from sklearn.neighbors import KNeighborsClassifier
from sklearn.metrics import accuracy_score
import matplotlib.pyplot as plt
import numpy as np

digits = load_digits()

"""
plt.gray()
plt.imshow(digits.get('images')[8])
digits.get('target')[8]
"""

X = digits.get('data')
Y = digits.get('target')

x_train, x_test, y_train, y_test = train_test_split(X,Y,test_size = 0.4)

scores = []
k_values = np.linspace(1,51,20)

for k in k_values:
    #Fit
    model = KNeighborsClassifier(int(k))
    model.fit(x_train,y_train)
    
    #Predict
    y_pred = model.predict(x_test)
    score = accuracy_score(y_test,y_pred)
    scores.append(score)

plt.plot(k_values,scores)