import numpy as np
from sklearn.preprocessing import LabelEncoder
from sklearn.preprocessing import LabelBinarizer

from keras.models import Sequential
from keras.optimizers import SGD
from keras.layers import LSTM, Dense, Conv2D, MaxPooling2D, Reshape, Input

import matplotlib.pyplot as plt


def load_data(path):
    X_train = np.load(path + 'X_train.npy')
    X_test = np.load(path + 'X_test.npy')
    
    #Separate X_train using crossvalidation file
    FILE = open(path + "crossvalidation_train.csv", 'r')
    Y_train = []
    TTs = [] #test/train vector

    for line in FILE:

        values = line.split(',')
        if values[0] == 'id':
            continue
        Y_train.append(values[1])
        TTs.append(values[2])


    #Encode labels to 00010000 etc.    
    le = LabelEncoder()
    Y_train = np.array(Y_train)
    Y_train = le.fit_transform(Y_train)
    TTs = np.array(TTs)
    
    #lowercase x/y data is used for model selection, decided by the meta_train
    #cross validation file
    x_train, x_test, y_train, y_test = [],[],[],[]

    for i in range(0,np.size(X_train,0)):
        if TTs[i] == 'train\n':
            x_train.append(X_train[i,:])
            y_train.append(Y_train[i])
        else:
            x_test.append(X_train[i,:])
            y_test.append(Y_train[i])

    x_train = np.array(x_train)
    y_train = np.array(y_train)
    x_test = np.array(x_test)
    y_test = np.array(y_test)
    
    class_names = ['a','b','c','d','e','f','g','i','h','k','l','k','n','m','o']
    return x_train, y_train, x_test, y_test, class_names


path = "D:\\TUT\\ML\\contest\\"
X_train, y_train, X_test, y_test, class_names = load_data(path)

lb = LabelBinarizer()
lb.fit(y_train)
y_train = lb.transform(y_train)
y_test  = lb.transform(y_test)
num_classes = y_train.shape[1]    

# Shuffle dimensions. 
# Originally the dims are (sample_idx, frequency, time)
# Should be like: (sample_idx, time, frequency), so that
# LSTM runs along 'time' dimension.
#X_train = np.reshape(X_train,(3268,501,40,1))
#X_test = np.reshape(X_test,(1232,501,40,1))
X_train =X_train[..., np.newaxis]
X_test =X_test[..., np.newaxis]

X_train = np.transpose(X_train, (0, 2, 1,3))
X_test  = np.transpose(X_test,  (0, 2, 1,3))

# Define the net. Just 1 LSTM layer; you can add more.

inputs = Input(shape=((501,40,1)))
x = Conv2D(filters = 1, kernel_size = (3,3))(inputs)
x = MaxPooling2D(pool_size=(3,2))
shp = x.output_shape()
newshp = tuple([for x in x in shp.as_list() if x != 1 and x is not None])


model = Sequential()
model.add(Conv2D(filters = 1, kernel_size = (3,3), input_shape = (501,40,1)))
model.add(MaxPooling2D(pool_size=(3,2)))
model.add(Reshape((167,20)))
model.add(LSTM(128, return_sequences = False))
model.add(Dense(num_classes, activation = 'softmax'))

# Define optimizer such that we can adjust the learning rate:
optimizer = SGD(lr = 1e-3)

# Compile and fit
model.compile(optimizer = optimizer,
              loss = 'categorical_crossentropy',
              metrics = ['accuracy'])

history = model.fit(X_train, y_train, epochs = 30, 
                    validation_data = (X_test, y_test))

# Plot learning curve.
# History object contains the metrics for each epoch.
# If you want to use plotting on remote machine, import like this:
#
# > import matplotlib
# > matplotlib.use("PDF") # Prevents crashing due to no window manager
# > import matplotlib.pyplot as plt

fig, ax = plt.subplots(2, 1)
ax[0].plot(history.history['acc'], 'ro-', label = "Train Accuracy")
ax[0].plot(history.history['val_acc'], 'go-', label = "Test Accuracy")
ax[0].set_xlabel("Epoch")
ax[0].set_ylabel("Accuracy / %")
ax[0].legend(loc = "best")
ax[0].grid('on')

ax[1].plot(history.history['loss'], 'ro-', label = "Train Loss")
ax[1].plot(history.history['val_loss'], 'go-', label = "Test Loss")
ax[1].set_xlabel("Epoch")
ax[1].set_ylabel("Loss")
ax[1].legend(loc = "best")
ax[1].grid('on')

plt.tight_layout()
plt.savefig("Accuracy.pdf", bbox_inches = "tight")