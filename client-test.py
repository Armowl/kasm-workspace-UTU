import socket

s = socket.socket()
s.connect(('localhost', 12355))
print (s.recv(1024))
s.sendall(b'a')
s.close()
