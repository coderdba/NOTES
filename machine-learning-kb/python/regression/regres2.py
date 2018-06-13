import sklearn
from sklearn import linear_model
reg = linear_model.LinearRegression()
#reg.fit ([[0, 0, 0], [1, 1, 1], [2, 2, 2]], [0, 1, 2])
reg.fit ([[0, 0.1, 0.25], [1, 1.75, 2.30], [2, 2.99, 1.5]], [0, 1, 2])
print (reg.coef_)

#print (reg.predict([[0,0.2,0.3]]))

print (reg.predict([[0,0.1,0.25]]))
print (reg.predict([[1,1.75,2.30]]))
print (reg.predict([[2,2.99,1.5]]))
print
print
print (reg.predict([[3,3.99,3.5]]))
