import numpy as np
import os
data = []
np.random.seed(3453)
for i in range(70000):
	a=np.random.uniform(-2,2,(1,2))
	key = '_UTT_' + str(i)
	x = a[0,0]
	y = a[0,1]
	if np.sum(a**2) < 1:
		label = 1
	else:
		label = 0
	data.append([x, y, label])


data = np.array(data, dtype=np.int8)

train = data[:50000,:2]
test = data[50000:, :2]
train_label = data[:50000,2:].reshape((50000,1))
test_label = data[50000: ,2:].reshape((20000,1))




if not os.path.exists('./src'):
	os.makedirs('./src')

train.astype('int8').tofile('src/train')
test.astype('int8').tofile('src/test')
train_label.astype('int8').tofile('src/train-labels')
test_label.astype('int8').tofile('src/test-labels')
