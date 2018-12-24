# -*- coding: utf-8 -*-
"""
Created on Sat Jan 20 13:30:32 2018

@author: asamiko
"""

import numpy as np
import matplotlib.pyplot as plt
from sklearn.preprocessing import LabelEncoder
from sklearn.model_selection import train_test_split

from sklearn.linear_model import LogisticRegression
from sklearn.ensemble import *
from sklearn.neighbors import KNeighborsClassifier
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis
from sklearn.svm import SVC
import keras
from keras.utils import np_utils
from keras.models import Sequential
#from keras.layers.core import 
from keras.layers import  GlobalAveragePooling1D, LSTM, Permute,Reshape,Conv1D,MaxPooling1D,Convolution2D,SeparableConv2D, MaxPooling2D, Flatten, ActivityRegularization, Dense, Activation, Dropout, Input
from keras import losses
from sklearn.metrics import auc, roc_curve, accuracy_score, jaccard_similarity_score, roc_auc_score, confusion_matrix
from sklearn import preprocessing
from keras.metrics import categorical_accuracy
from keras.callbacks import LearningRateScheduler, ModelCheckpoint
import itertools 
from itertools import cycle
from scipy import interp

if __name__ == "__main__":
    #Load data from folder
##    X = np.load('X_train.npy')
#    with open('y_train.csv') as fp:        
#        for line in fp:            
#            values = line.split(" ")            
#            values = [float(v) for v in values]            
#            X.append(values)
##    y_data = np.genfromtxt('y_train.csv', dtype=str, delimiter=',')
##    le = LabelEncoder()
    #    y = le.fit_transform(y_data[1:,1]) #train using these
##    y = le.fit_transform(y_data[1:,1]) #train using these
    #X_test = np.load('X_test.npy') #task is to find class for these
##    X_train, X_test, y_train, y_test = train_test_split(X,y, test_size=0.2)
    KNN_pred, LDA_pred, SVC_pred, KNN_predb, LDA_predb, SVC_predb, acc_KNN, acc_LDA, acc_SVC, cnf_KNN, cnf_LDA, cnf_SVC = [],[],[],[],[],[],[],[],[],[],[],[]
    X1_train = np.load(r'D:\TUT\ML\advanced\contest\X_train.npy')
#    X1_test = np.load('X_test.npy')
    y_data = np.genfromtxt(r'D:\TUT\ML\advanced\contest\crossvalidation_train.csv', dtype=str, delimiter=',', skip_header = 1)
    train_index = np.where(y_data == 'train')
    test_index = np.where(y_data == 'test')
    train_index2 = np.where(train_index[1] == 2)
    test_index2 = np.where(test_index[1] == 2)    
    y_train = y_data[train_index2,1].transpose()
    y_test = y_data[test_index2,1].transpose()
    X_train = X1_train[train_index2,:,:]
    X_test = X1_train[test_index2,:,:]
    

    X_train_pixels = np.reshape(X_train,(3268,20040), order='C')
    X_test_pixels = np.reshape(X_test,(1232,20040), order='C')

    X_train_freq = np.mean(X_train, axis = 2)
    X_test_freq = np.mean(X_test, axis = 2)

    X_train_time = np.mean(X_train, axis = 1)
    X_test_time = np.mean(X_test, axis = 1)

    lb = preprocessing.LabelBinarizer()   
    train_labels = lb.fit_transform(y_train)
    test_labels = lb.fit_transform(y_test)

    KNN = KNeighborsClassifier(n_neighbors = 3)
    KNN.fit(X_train_pixels,y_train)
    KNN_pred = KNN.predict(X_test_pixels)
    acc_KNN = accuracy_score(y_test, KNN_pred)
#    auc_KNN = roc_auc_score(test_labels, KNN_pred)
#    KNN_pred = [np.argmax(t) for t in KNN_predb]
    cnf_KNN = confusion_matrix(y_test, KNN_pred)    
    
    LDA = LinearDiscriminantAnalysis()
    LDA.fit(X_train_pixels,y_train)
    LDA_pred = LDA.predict(X_test_pixels)
    LDA_predb = lb.fit_transform(LDA_pred)
    acc_LDA = jaccard_similarity_score(test_labels, LDA_predb)
#    auc_LDA = roc_auc_score(test_labels, LDA_predb)
    cnf_LDA = confusion_matrix(y_test, LDA_pred)

    SVC_ = SVC(kernel = 'linear')
    SVC_.fit(X_train_pixels,y_train)
    SVC_pred = SVC_.predict(X_test_pixels)
    SVC_predb = lb.fit_transform(SVC_pred)
    acc_SVC = jaccard_similarity_score(test_labels, SVC_predb)
#    auc_SVC = roc_auc_score(test_labels, SVC_predb)
    cnf_SVC = confusion_matrix(y_test, SVC_pred)
    
    Log = LogisticRegression()
    Log.fit(X_train_pixels,y_train)
    Log_pred = Log.predict(X_test_pixels)
    Log_predb = lb.fit_transform(Log_pred)
    acc_Log = jaccard_similarity_score(test_labels, Log_predb)
#    auc_SVC = roc_auc_score(test_labels, SVC_predb)
    cnf_Log = confusion_matrix(y_test, Log_pred) 
    
    RFC = RandomForestClassifier()
    RFC.n_estimators = 100
    RFC.fit(X_train_pixels,y_train)
    RFC_pred = RFC.predict(X_test_pixels)
    RFC_predb = lb.fit_transform(RFC_pred)
    acc_RFC = jaccard_similarity_score(test_labels, Log_predb)
#    auc_SVC = roc_auc_score(test_labels, SVC_predb)
    cnf_RFC = confusion_matrix(y_test, RFC_pred)
    
    clf_list = [LDA , SVC_]
    clf_name = ['LDA','SVC_','Log']
    C_range = 10.0**np.arange(-1,1)
    scores_linear = []
    clf_scores = []
    
    for clf,name in zip(clf_list, clf_name):
        for C in C_range:
            for penalty in ['L1','L2']:
                #logistic regression does not have convergent regularization 1 
                clf.C = C
                clf.penalty = penalty
                clf.fit(X_train_pixels, y_train)
                y_pred_linear = clf.predict(X_test_pixels)
                y_predb_linear = lb.fit_transform(y_pred_linear)
                score_linear =  jaccard_similarity_score(test_labels, y_predb_linear)
                scores_linear.append(score_linear)
                clf_scores.append((name, C, penalty, score_linear))
    
    i = scores_linear.idex(max(scores_linear))
    print(clf_scores[i]) 
               

    
#    LR = LinearRegression()
#    LR.fit(X_train_pixels,y_train)
#    LR_pred = LR.predict(X_test_pixels)
#    acc_LR = jaccard_similarity_score(y_test, LR_pred)
#   linear regression is predicts the continuous multiclass label 

#    predictions = [KNN_pred, LDA_pred, SVC_pred, LR_pred]
#    scores = []
#    for y_pred in predictions:
#        scores.append(accuracy_score(y_test,y_pred))
    print('acc_KNN:',acc_KNN, 'acc_LDA:',acc_LDA,'acc_SVC:',acc_SVC, 'acc_Log:',acc_Log, 'acc_RFC:',acc_RFC)

    def plot_confusion_matrix(cm, classes,
                              normalize=False,
                              title='Confusion matrix',
                              cmap=plt.cm.Blues):
        """
        This function prints and plots the confusion matrix.
        Normalization can be applied by setting `normalize=True`.
        """
        if normalize:
            cm = cm.astype('float') / cm.sum(axis=1)[:, np.newaxis]
            print("Normalized confusion matrix")
        else:
            print('Confusion matrix, without normalization')
    
        print(cm)
    
        plt.imshow(cm, interpolation='nearest', cmap=cmap)
        plt.title(title)
        plt.colorbar()
        tick_marks = np.arange(len(classes)) 
        plt.xticks(tick_marks, classes, rotation=45)
        plt.yticks(tick_marks, classes)
    
        fmt = '.2f' if normalize else 'd'
        thresh = cm.max() / 2.
        for i, j in itertools.product(range(cm.shape[0]), range(cm.shape[1])):
            plt.text(j, i, format(cm[i, j], fmt),
                     horizontalalignment="center",
                     color="white" if cm[i, j] > thresh else "black")
    
        plt.ylabel('True label')
        plt.xlabel('Predicted label')
        plt.axis('auto')
    
    class_names = list(np.unique(y_test))
    plt.figure(1)
    cm_KNN = plot_confusion_matrix(cnf_KNN, classes=class_names, normalize=False,
                          title='Normalized KNN confusion matrix')
    plt.figure(2)
    cm_LDA = plot_confusion_matrix(cnf_LDA, classes=class_names, normalize=False,
                          title='Normalized LDA confusion matrix')
    plt.figure(3)
    cm_SVC = plot_confusion_matrix(cnf_SVC, classes=class_names, normalize=False,
                          title='Normalized SVC confusion matrix')
    plt.figure(4)
    cm_Log = plot_confusion_matrix(cnf_Log, classes=class_names, normalize=False,
                          title='Normalized Log confusion matrix')
    plt.figure(5)
    cm_RFC = plot_confusion_matrix(cnf_RFC, classes=class_names, normalize=False,
                          title='Normalized RFC confusion matrix')
#    plt.figure(6)
#    cm_SVC = plot_confusion_matrix(cnf_SVC, classes=class_names, normalize=False,
#                          title='Normalized SVC confusion matrix')

    
    X_Train = np.empty((3268, 40, 501, 1))
    X_Test = np.empty((1232, 40, 501, 1))
    Test_labels = np.empty((1232, 15))
    Train_labels = np.empty((3268,15))
    Test_labels = np.array(test_labels)
    Train_labels = np.array(train_labels)
    X_Test = np.reshape(np.array(X_test)[0,:,:,:],(1232,40,501,1))
    X_Train = np.reshape(np.array(X_train)[0,:,:,:],(3268,40,501,1))

#    X_Train = X_train.reshape(X_train.shape[1], 1, 40, 501)
#    X_Test = X_test.reshape(X_test.shape[1], 1, 40, 501)
    Train_labels = np.array([np.argmax(t) for t in Train_labels])
    Test_labels =  np.array([np.argmax(t) for t in Test_labels])
   
    X_Train= X_Train.reshape(3268, 20040, 1)
    X_Test= X_Test.reshape(1232, 20040, 1) 
    Train_labels = Train_labels.reshape(3268, 1)
    Test_labels = Test_labels.reshape(1232, 1)
    model = Sequential()
    model.add(Conv1D(32, 3, activation='relu', input_shape=(20040,1)))
    model.add(Conv1D(32, 3, activation='relu'))
    model.add(MaxPooling1D(3))
    model.add(Conv1D(64, 3, activation='relu'))
    model.add(Conv1D(64, 3, activation='relu'))
    model.add(GlobalAveragePooling1D())
    #model.add(Dropout(0.5))
    #model.add(Flatten())
    print(model.output_shape)
    model.add(Reshape((32,2)))
    #print(model.output_shape)
    model.add(LSTM(32))
    model.add(ActivityRegularization(l1=0.1, l2=0.1))
    #print(model.output_shape)
    model.add(Dropout(0.5))
    model.add(Dense(15, activation='sigmoid'))
    
    #lr = 0.01
    epoch = 2
    #def lr_schedule(epoch):
    #    return lr * (0.1 ** int(epoch / 10))
    
    model.compile(loss='sparse_categorical_crossentropy',
                  optimizer='rmsprop',
                  metrics=['categorical_accuracy, roc'])
    #              callbacks=[LearningRateScheduler(lr_schedule),ModelCheckpoint('model.h5', save_best_only=True)])
    
    y_pred = model.fit(X_Train, Train_labels, batch_size=16, epochs=epoch)
    Y_pred = model.predict(X_Test)
    print(model.summary())
#    y_pred = history.predict(X_test).ravel()
    score = model.evaluate(X_Test, Test_labels, batch_size=16)
#    plt(history.history['categorical_accuracy'])
#    fpr, tpr, thresholds = roc_curve(test_labels, lb.fit_transform(y_pred))
    
    lw = 2
    
    #l Compute ROC curve and ROC area for each class
    fpr = dict()
    tpr = dict()
    roc_auc = dict()
    for i in range(len(Test_labels)):
        fpr[i], tpr[i], _ = roc_curve(y_test[:, i], lb.transform(Y_pred.reshape(1232,15)[:, i]))
        roc_auc[i] = auc(fpr[i], tpr[i])
    
    # Compute micro-average ROC curve and ROC area
    fpr["micro"], tpr["micro"], _ = roc_curve(y_test.ravel(), lb.transform(Y_pred.reshape(1232,15).ravel()))
    roc_auc["micro"] = auc(fpr["micro"], tpr["micro"])
    
    # Compute macro-average ROC curve and ROC area
    
    # First aggregate all false positive rates
    all_fpr = np.unique(np.concatenate([fpr[i] for i in range(15)]))
    
    # Then interpolate all ROC curves at this points
    mean_tpr = np.zeros_like(all_fpr)
    for i in range(15):
        mean_tpr += interp(all_fpr, fpr[i], tpr[i])
    
    # Finally average it and compute AUC
    mean_tpr /= 15
    
    fpr["macro"] = all_fpr
    tpr["macro"] = mean_tpr
    roc_auc["macro"] = auc(fpr["macro"], tpr["macro"])
    
    # Plot all ROC curves
    plt.figure(1)
    plt.plot(fpr["micro"], tpr["micro"],
             label='micro-average ROC curve (area = {0:0.2f})'
                   ''.format(roc_auc["micro"]),
             color='deeppink', linestyle=':', linewidth=4)
    
    plt.plot(fpr["macro"], tpr["macro"],
             label='macro-average ROC curve (area = {0:0.2f})'
                   ''.format(roc_auc["macro"]),
             color='navy', linestyle=':', linewidth=4)
    
    colors = cycle(['aqua', 'darkorange', 'cornflowerblue'])
    for i, color in zip(range(15), colors):
        plt.plot(fpr[i], tpr[i], color=color, lw=lw,
                 label='ROC curve of class {0} (area = {1:0.2f})'
                 ''.format(i, roc_auc[i]))
    
    plt.plot([0, 1], [0, 1], 'k--', lw=lw)
    plt.xlim([0.0, 1.0])
    plt.ylim([0.0, 1.05])
    plt.xlabel('False Positive Rate')
    plt.ylabel('True Positive Rate')
    plt.title('Some extension of Receiver operating characteristic to multi-class')
    plt.legend(loc="lower right")
    plt.show()
    
    
    # Zoom in view of the upper left corner.
    plt.figure(2)
    plt.xlim(0, 0.2)
    plt.ylim(0.8, 1)
    plt.plot(fpr["micro"], tpr["micro"],
             label='micro-average ROC curve (area = {0:0.2f})'
                   ''.format(roc_auc["micro"]),
             color='deeppink', linestyle=':', linewidth=4)
    
    plt.plot(fpr["macro"], tpr["macro"],
             label='macro-average ROC curve (area = {0:0.2f})'
                   ''.format(roc_auc["macro"]),
             color='navy', linestyle=':', linewidth=4)
    
    colors = cycle(['aqua', 'darkorange', 'cornflowerblue'])
    for i, color in zip(range(15), colors):
        plt.plot(fpr[i], tpr[i], color=color, lw=lw,
                 label='ROC curve of class {0} (area = {1:0.2f})'
                 ''.format(i, roc_auc[i]))
    
    plt.plot([0, 1], [0, 1], 'k--', lw=lw)
    plt.xlabel('False Positive Rate')
    plt.ylabel('True Positive Rate')
    plt.title('Some extension of Receiver operating characteristic to multi-class')
    plt.legend(loc="lower right")
    plt.show()

#   model = Sequential(SeparableConv2D(filters = 1, input_shape = (40,501,1),kernel_size=(3,3),  activation = 'relu',padding = 'same')))
#    model.add(MaxPooling2D(pool_size = (2,3)))
#    model.add(SeparableConv2D(filters = 2, kernel_size=(3,3), activation = 'relu',padding = 'same'))
#    model.add(MaxPooling2D(pool_size = (2,1)))
#    model.add(Flatten())
#    model.add(Dense(100, activation = 'sigmoid'))
#    model.add(Dense(15, activation = 'sigmoid'))
#    model.add(Dropout(rate = 0.1, noise_shape = None, seed = None))
 #   model.add(ActivityRegularization(l1=0.1, l2=0.1))
 #   print(model.summary())
    
#    model.compile(optimizer='rmsprop',loss='categorical_crossentropy',metrics = [categorical_accuracy, roc_auc_score])
#    model.fit(X_Train,Train_labels,batch_size = 16, epochs=32)
#,validation_data=(X_Test,Test_labels)
#model.compile(loss='binary_crossentropy',
#              optimizer='rmsprop',
#              metrics=['accuracy'])
#    model.fit(train, ltrain, batch_size=16, epochs=10)
#    score = model.evaluate(X_Test,Test_labels, batch_size=16)

#    w = base_model.output
#    w = Flatten()(w)
#    w = Dense(100,activation= "relu")(w)
#    output = Dense(2, activation = "sigmoid")(w)    
#    model2 = Model(inputs = [base_model.input], outputs = [output])
#    model2.layers[-5].trainable = True
#    model2.layers[-6].trainable = True
#    model2.layers[-7].trainable = True
#    model2.summary()
#    model2.compile(optimizer = "sgd",metrics=['accuracy'], loss = 'binary_crossentropy')
#    model2.fit(X, y, epochs=2, batch_size=32)

    KNN_labels = list(KNN_pred)
    LDA_labels = list(LDA_pred)
    SVC_labels = list(SVC_pred)
    
    with open("submission1.csv", "w") as fp:
        fp.write("Id,KNN_label,LDA_label,SVC_label\n")
        for i, label in enumerate(KNN_labels):
            fp.write("%d,%s,%s,%s\n" % (i, KNN_labels, LDA_labels, SVC_labels))
            

