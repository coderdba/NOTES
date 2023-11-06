# Import packages
from sklearn.naive_bayes import GaussianNB
from sklearn.model_selection import train_test_split
from sklearn.metrics import confusion_matrix
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns; sns.set()

# Import data
#training = pd.read_csv('https://raw.githubusercontent.com/selva86/datasets/master/iris_train.csv')
#test = pd.read_csv('https://raw.githubusercontent.com/selva86/datasets/master/iris_test.csv')

training = pd.read_csv('iris_train.csv')
test = pd.read_csv('iris_test.csv')


# Create the X, Y, Training and Test
xtrain = training.drop('Species', axis=1)
ytrain = training.loc[:, 'Species']
xtest = test.drop('Species', axis=1)
ytest = test.loc[:, 'Species']


# Init the Gaussian Classifier
print ("INFO - Intiaializing gaussian classifier")
model = GaussianNB()

# Train the model 
print ("INFO - Training the model with train data")
model.fit(xtrain, ytrain)

# Predict Output 
print ("INFO - Predicting output for test data")
pred = model.predict(xtest)

print ("\nINFO - Printing the predictions for the test data \n")
print (pred)

# Plot Confusion Matrix
mat = confusion_matrix(pred, ytest)
print ("\nINFO - Printing confusing_matrix \n")
print (mat)

names = np.unique(pred)
print ("\nINFO - Printing names from predictions \n")
print (names)

# Create heatmap plot using the matrix
sns.heatmap(mat, square=True, annot=True, fmt='d', cbar=False,
            xticklabels=names, yticklabels=names)
plt.xlabel('Truth')
plt.ylabel('Predicted')

# Show the plot - without this show() call plot wont show up on the screen
plt.show()
