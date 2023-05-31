import socket
import os
import random
s = socket.socket()
s.bind(('0.0.0.0', 12355))
s.listen(50)
a = list()
def flag():
	for i in range(10):
		global a
		a.append(random.randint(1,10))
	a = ''.join (str(i) for i in a)
	return a
while True:
	c, addr = s.accept()
	print ('got connection from', addr)
	c.sendall(flag().encode())
	print (c.recv(1024))
	c.close()
	

