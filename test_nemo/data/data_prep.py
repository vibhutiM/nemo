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
		label = -1
	data.append([key, x, y, key, label])


data = np.array(data)

train = data[:50000,:3]
test = data[50000:, :3]
train_label = data[:50000,3:]
test_label = data[50000: ,3:]

if not os.path.exists('./src'):
	os.makedirs('./src')
np.savetxt('src/train.txt', train, delimiter=' ', fmt='%s')
np.savetxt('src/test.txt', test, delimiter=' ', fmt='%s')
np.savetxt('src/train-labels.txt', train_label, delimiter=' ', fmt='%s')
np.savetxt('src/test-labels.txt', test_label, delimiter=' ', fmt='%s')