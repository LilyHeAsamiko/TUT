# -*- coding: utf-8 -*-
"""
Created on Mon Jan 22 13:02:34 2018

@author: Asamiko
"""

import numpy as np
import matplotlib.pyplot as plt

w = np.sqrt(0.25) * np.random.randn(100)
f0 = 0.017
n = np.linspace(0,99,100)

x = np.sin(2*np.pi*f0*n)
noisy_x = x + w

plt.plot(x)
plt.plot(noisy_x)

scores = []
frequencies = []

#calculating correlation for x[n] and e[n], where e[n] is the complex
#representation of the sinusoid. 
for f in np.linspace(0,0.5,1000):
    
    n = np.arange(100)
    z = -2*np.pi*1j*f*n
    e = np.exp(z)
    
    score = abs(np.dot(x,e))
    scores.append(score)
    frequencies.append(f)

#Choose f that causes e[n] to correlate the most with x[n]    
fhat = frequencies[np.argmax(scores)]

plt.plot(np.sin(2*np.pi*fhat*n))