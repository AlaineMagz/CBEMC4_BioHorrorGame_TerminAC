extends Node

var server := UDPServer.new()
var port := 4242

var heartRate : float = 0 
var averageHeartRate : float = 0
var motionDetected : bool = false

@export var GUI : Control

func _ready():
	await get_tree().process_frame
	var err = server.listen(port)
	if err != OK:
		print("Could not listen on port ", port)
	else:
		print("Godot is listening for IoT data on port ", port)

func _process(_delta):
	server.poll() # Check for new data
	if server.is_connection_available():
		var peer : PacketPeerUDP = server.take_connection()
		var packet = peer.get_packet()
		var data_string = packet.get_string_from_utf8()
		
		GUI.add_to_monitor(data_string)
		
		# Parse the JSON
		var json = JSON.new()
		var error = json.parse(data_string)
		if error == OK:
			var data = json.data
			_update_visuals(data)

func _update_visuals(data : Dictionary):
	
	var type = data["sensorData"]
	var value = data["sensorValue"]
	
	if type == "heartRate":
		heartRate = value
	else: if type == "averageHeartRate":
		averageHeartRate = value
	else: if type == "motionDetected":
		motionDetected = value
		
	
