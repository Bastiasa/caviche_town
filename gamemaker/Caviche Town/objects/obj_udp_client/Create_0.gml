/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

connected_server = noone
client = noone

function connect_to_server(_url, _port) {
	show_debug_message(string_concat("Trying to connect to ",_url,":",_port,"."))
	client = network_create_socket(network_socket_udp)
	connected_server = network_connect_raw(client, _url, _port)
	
	var _connect_command = "connection_request:"
	var _length = string_length(_connect_command)
	var _buffer = buffer_create(_length, buffer_grow, 1)
	buffer_write(_buffer, buffer_string, _connect_command)
	
	network_send_udp_raw(client, _url, _port, _buffer, _length)
	
	buffer_delete(_buffer)
	
	if connected_server > 0 {
		show_debug_message("Connection completed.")
		return true
	} else {
		show_debug_message("Connection failed.")
		network_destroy(client)
		return false
	}
	
}


function process_server_message(_message, _emisor) {

}

