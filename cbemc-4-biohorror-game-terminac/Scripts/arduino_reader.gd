extends Node3D

@export var manager : Node3D

var serial: GdSerial

@export_category("Detected Values")
@export var serialOpen : bool = false
@export var irValue: float = 1
@export var isMotion : bool

@export_category("Debug")
@export var showDebug : bool = false

func _ready():
	
	open_serial()
	

func _process(_delta: float) -> void:
	
	var line
	
	if serialOpen and serial.bytes_available():
		line = serial.readline()
		read_values(line)
		if showDebug:
			print("+-----+")
			print("IR Value: " + str(irValue) + ", Motion Detected: " + str(isMotion).capitalize())
		manager.GUI.add_to_monitor(line)
	

func open_serial() -> void:
	
	serial = GdSerial.new()
	
	var ports = serial.list_ports()
	print("Available ports:", ports)
	
	var com_port_found = false
	
	for p in ports.values():
		if p.has("port_name") and p["port_name"] == "COM3":
			com_port_found = true
			break
	
	if not com_port_found:
		push_warning("COM3 not found. Serial not opened.")
		return
	
	serial.set_port("COM3")
	serial.set_baud_rate(115200)
	
	var open = serial.open()
	if !open:
		push_error("Failed to open COM3.")
	else:
		print("Serial port opened successfully!")
		serialOpen = true
	

func read_values(line : String) -> void:
	
	#if(serial.bytes_available()):
		#var ir = float(line.split(" ")[0].split(",")[0])
		#irValue = ir
		#isMotion = bool(int(line.split(" ")[3]))
		
		if showDebug:
			print("+-----+")
			print("Serial Read: " + line)
		
	
