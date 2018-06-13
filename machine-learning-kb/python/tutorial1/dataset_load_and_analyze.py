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
dataset.plot(kind='box', subplots=True, layout=(2,2), sharex=False, sharey=False)
plt.show()


# histograms
dataset.hist()
plt.show()


# scatter plot matrix
scatter_matrix(dataset)
plt.show()
