# Load dataset

import pandas

#url = "https://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data"
url = "file://localhost//mywork/python/ml/bin/mywork/iris.data"
names = ['sepal-length', 'sepal-width', 'petal-length', 'petal-width', 'class']
dataset = pandas.read_csv(url, names=names)
