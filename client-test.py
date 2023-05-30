import socket

s = socket.socket()
s.connect(('localhost', 12345))
s.sendall(b'a')
s.close()
