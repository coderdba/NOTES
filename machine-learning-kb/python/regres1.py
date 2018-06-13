import sklearn
from sklearn import linear_model
reg = linear_model.LinearRegression()
reg.fit ([[0, 0], [1, 1], [2, 2]], [0, 1, 2])
print (reg.coef_)
print (reg.predict([[0,0]]))
print (reg.predict([[1,1]]))
print (reg.predict([[2,2]]))
