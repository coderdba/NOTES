#
#
# Load libraries
import pandas
from pandas.plotting import scatter_matrix
import matplotlib.pyplot as plt
from sklearn import model_selection
from sklearn.metrics import classification_report
from sklearn.metrics import confusion_matrix
from sklearn.metrics import accuracy_score
from sklearn.linear_model import LogisticRegression
from sklearn.tree import DecisionTreeClassifier
from sklearn.neighbors import KNeighborsClassifier
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis
from sklearn.naive_bayes import GaussianNB
from sklearn.svm import SVC


# =================

# Load dataset
print ("\nLoad dataset \n")

#url = "https://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data"
url = "file://localhost//mywork/python/ml/bin/mywork/iris.data"
names = ['sepal-length', 'sepal-width', 'petal-length', 'petal-width', 'class']
dataset = pandas.read_csv(url, names=names)

# shape
print ("Shape of the dataset \n")
print(dataset.shape)


# descriptions
print ("\nStatistical description of the dataset \n")
print(dataset.describe())

# class distribution
print ("\nClass distribution of the dataset \n")
print(dataset.groupby('class').size())

# PLOTS
print ("\n\nPLOTS\n\n")

# box and whisker plots
#dataset.plot(kind='box', subplots=True, layout=(2,2), sharex=False, sharey=False)
#plt.show()


# histograms
#dataset.hist()
#plt.show()


# scatter plot matrix
#scatter_matrix(dataset)
#plt.show()


# Create validation dataset
array = dataset.values

#print (array[:,0:4])
#print (array[:,3])

# Split-out validation dataset
array = dataset.values
X = array[:,0:4]
Y = array[:,4]
validation_size = 0.20
seed = 7
X_train, X_validation, Y_train, Y_validation = model_selection.train_test_split(X, Y, test_size=validation_size, random_state=seed)


# Test options and evaluation metric
seed = 7
scoring = 'accuracy'

# Spot Check Algorithms
models = []
models.append(('LR', LogisticRegression()))
models.append(('LDA', LinearDiscriminantAnalysis()))
models.append(('KNN', KNeighborsClassifier()))
models.append(('CART', DecisionTreeClassifier()))
models.append(('NB', GaussianNB()))
models.append(('SVM', SVC()))
# evaluate each model in turn
results = []
names = []
for name, model in models:

	kfold = model_selection.KFold(n_splits=8, random_state=2)
	#kfold = model_selection.KFold(n_splits=10, random_state=seed)
	#kfold = model_selection.KFold(n_splits=2)

	cv_results = model_selection.cross_val_score(model, X_train, Y_train, cv=kfold, scoring=scoring)
	results.append(cv_results)
	names.append(name)
	msg = "%s: %f (%f)" % (name, cv_results.mean(), cv_results.std())
	print(msg)



# Compare Algorithms
fig = plt.figure()
fig.suptitle('Algorithm Comparison')
ax = fig.add_subplot(111)
plt.boxplot(results)
#ax.set_xticklabels(names)
#plt.show()

# Make predictions on validation dataset
knn = KNeighborsClassifier()
knn.fit(X_train, Y_train)
predictions = knn.predict(X_validation)
print(accuracy_score(Y_validation, predictions))
print(confusion_matrix(Y_validation, predictions))
print(classification_report(Y_validation, predictions))

#print (predictions)

myArray=[(0.1,0.1,0.1,0.1)]
myPrediction = knn.predict(myArray)
print (myArray)
print (myPrediction)

myArray=[(6.2,3.4,5.4,2.3)]
print (myArray)
myPrediction = knn.predict(myArray)
print (myPrediction)

#myArray=[(5.2,3.4,5.4,1.0)]
myArray=[(5,3,5,1)]
print (myArray)
myPrediction = knn.predict(myArray)
print (myPrediction)
