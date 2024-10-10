import socket

udp_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

ip = "0.0.0.0" 
port = 6060  

udp_socket.bind((ip, port))

password = ""
clients = set()

answered_reliable_messages = {}

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
            send_message("reliable_received#"+message_id, address)
            answered_reliable_messages[string_address].append(message_id)
    
    return message_content

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


    if check_command("connection_request:")

