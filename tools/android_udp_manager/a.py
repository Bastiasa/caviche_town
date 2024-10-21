import socket

s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.bind(("0.0.0.0", 7890))
s.sendto(b'cts:holi', ("192.168.20.71", 8888))