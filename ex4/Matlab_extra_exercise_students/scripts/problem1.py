# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""
import scipy
import numpy as np
M = 300
A = np.zeros((M+1,M+1))
b = np.zeros((1,M+1))
j = 0
for i in range(301):
    while i <= j <= M-2:
        if j == i:
            A[i,j] = 1
        if j == i + 1:
            A[i,j] = 2
        if j == i + 2:
            A[i,j] = 3
    if i <= 2:
        A[i][i-2] = 2
    if np.mod(i,6) == 0:
        b[i] == 0
    if np.mod(i,6) == 1:
        b[i] == 0.1
    if np.mod(i,6) == 2:
        b[i] == 0.2
    if np.mod(i,6) == 3:
        b[i] == 0.3
    if np.mod(i,6) == 4:
        b[i] == 0.2
    if np.mod(i,6) == 5:
        b[i] == 0.1
b = b.T
x = scipy.linalg.solve(A,b)
