import socket

s = socket.socket()
s.bind(('0.0.0.0', 12345))

s.listen(20)
while True:
	c, addr = s.accept()
	print ('got connection from', addr)
	print (c.recv(1024))
	c.close()

