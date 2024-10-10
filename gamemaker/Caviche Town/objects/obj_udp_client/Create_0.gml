/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

connected_server = noone
client = noone

function connect_to_server(_url, _port) {
	client = network_create_socket(network_socket_udp)
	connected_server = network_connect_raw(client, _url, _port)
}


function process_server_message(_message, _emisor) {

}

