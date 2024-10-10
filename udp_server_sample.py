import socket
import time

from threading import Thread

udp_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

ip = "0.0.0.0" 
port = 6060  

udp_socket.bind((ip, port))

password = ""
max_clients = 4
ping_timeout = 30

clients:list[list[tuple|int]|float] = []

answered_reliable_messages = {}

def get_client_index_by_address(address:tuple):
    for client_index, client in enumerate(clients):
        if client[0][0] == address[0] and client[0][1] == address[1]:
            return client_index
    
    return -1

def address_to_string(address):
    return f"{address[0]}:{address[1]}"

def send_message(message:str, address:tuple):

    print("[Package] => "+address_to_string(address))

    message = message.encode('utf-8')
    udp_socket.sendto(message, address)

def handle_reliable(message:str, address:tuple):
    parts = message.split(":", 1)

    message_id = parts[0].removeprefix("reliable#")
    message_content = parts[1]

    string_address = address_to_string(address)

    if not string_address in answered_reliable_messages:
        answered_reliable_messages[string_address] = [message_id]
    else:
        found_id = answered_reliable_messages[string_address].index(message_id)

        if found_id != -1:
            answered_reliable_messages[string_address].append(message_id)
        else:
            message_content = ""
    
    send_message("reliable_received#"+message_id, address)
    return message_content

def background_process():

    global clients, max_clients, ping_timeout

    while True:
        
        for client_index, client in enumerate(clients):

            if time.time() - client[1] > ping_timeout:
                print(f"Client connection destroyed for ping timeout: {address_to_string(client[0])}.")
                send_message(client[0], "connection_destroyed")
                break



background_process_thread = Thread(target=background_process)
background_process_thread.start()

while True:
    message, address = udp_socket.recvfrom(1024)
    message = message.decode('utf-8')

    if message.startswith("reliable#"):
        message = handle_reliable(message, address)

    print(f"{address_to_string(address)} => [Package]")

    no_command_message = ""

    def check_command(command):
        global no_command_message
        no_command_message = message.removesuffix(command)
        return message.startswith(command)


    if check_command("connection_request:") and no_command_message == password and clients.__len__() < max_clients:
        clients.append([address, time.time()])
        send_message("connection_stablished", address)

    if check_command("connection_ping"):
        found_client_index = get_client_index_by_address(address)

        if found_client_index != -1 :
            clients[found_client_index][1] = time.time()


