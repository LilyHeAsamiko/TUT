# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""
from keras.models import Sequential, Model
from keras.layers.core import Dense, Activation
from keras.layers import Conv2D, MaxPooling2D, Flatten
from keras import losses
from keras.applications import VGG16

from keras.preprocessing import image
import glob
import numpy as np
from keras.utils import np_utils
from sklearn.preprocessing import normalize
from sklearn.cross_validation import train_test_split

def load_GTSRB():
    imlist = []
    GT = [] #ground truth
    
    C1files = glob.glob(r'''\\intra.tut.fi\home\peltonik\My Documents\Downloads\GTSRB_subset_2\GTSRB_subset_2\class1\*.jpg''' )
    C2files = glob.glob(r'''\\intra.tut.fi\home\peltonik\My Documents\Downloads\GTSRB_subset_2\GTSRB_subset_2\class2\*.jpg''' )
    
    for file in C1files:
        img = np.array(image.load_img(file))
        imlist.append((img-np.amin(img))/np.amax(img))
        GT.append(0)
    
    for file in C2files:
        img = np.array(image.load_img(file))
        imlist.append((img-np.amin(img))/np.amax(img))
        GT.append(1)
    
    return np.asarray(imlist).astype(float),GT

X,y = load_GTSRB()
#X = normalize(X)
y = np_utils.to_categorical(y,2)
X_train, X_test, y_train, y_test = train_test_split(X,y)


base_model = VGG16(include_top=False, weights = "imagenet",
                   input_shape = (64,64,3))

w = base_model.output

w = Flatten()(w)

w = Dense(100,activation= "relu")(w)

output = Dense(2, activation = "sigmoid")(w)

model = Model(inputs = [base_model.input], outputs = [output])

model.layers[-5].trainable = True
model.layers[-6].trainable = True
model.layers[-7].trainable = True


model.summary()
model.compile(optimizer = "sgd",metrics=['accuracy'], loss = 'binary_crossentropy')

model.fit(X_train, y_train, epochs=10, batch_size=32,validation_data=[X_test,y_test])
