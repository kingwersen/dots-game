extends Node2D

@export var bind_addr : String 	= "0.0.0.0"
@export var bind_port : int 	= 12345
@export var send_addr : String 	= "127.0.0.1"
@export var send_port : int 	= 12346

var socket : PacketPeerUDP = null
var json : JSON = null

var client_has_input = false
var client_input = Globals.empty_input()
var client_input_time = Time.get_unix_time_from_system()  # Seconds UTC
@export var client_timeout = 0.25  # Seconds



# Called when the node enters the scene tree for the first time.
func _ready():
	# ClientConnection uses UDP so that we can blindly send and
	# receive packets without implementing connections.
	socket = PacketPeerUDP.new()
	socket.bind(bind_port, bind_addr)
	socket.connect_to_host(send_addr, send_port)
	json = JSON.new()
	Globals.client_connection = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	recv_packets()
	send_indicators()
	assert_client_liveliness()


func recv_packets():
	while (true):
		var packet = socket.get_packet().get_string_from_utf8()
		if packet:
			handle_packet(packet)
		else:
			break

func handle_packet(packet : String):
	# Update input map with values from the received JSON packet.
	var content = json.parse_string(packet)
	if content:
		for key in client_input:
			if key in content:
				client_input[key] = content[key]
				update_client_liveliness()

func send_indicators():
	# Send the values of each indicator as a JSON array.
	# Indicators are ordered clockwise starting from the top/north.
	var content = []
	for indicator in Globals.indicators.get_children():
		content.push_back(indicator.value)
	socket.put_packet(json.stringify(content).to_utf8_buffer())

func update_client_liveliness():
	# Keep listening to the client's inputs for another client_timeout`` seconds.
	client_has_input = true
	client_input_time = Time.get_unix_time_from_system()

func assert_client_liveliness():
	# Clear inputs if client has not provided input recently.
	if client_has_input and Time.get_unix_time_from_system() - client_input_time > client_timeout:
		client_has_input = false
		client_input = Globals.empty_input()
