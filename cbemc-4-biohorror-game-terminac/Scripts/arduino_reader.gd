extends Node3D

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
	
	if serialOpen:
		read_values()
		if showDebug:
			print("+-----+")
			print("IR Value: " + str(irValue) + ", Motion Detected: " + str(isMotion).capitalize())
	

func open_serial() -> void:
	
	serial = GdSerial.new()
	
	var ports = serial.list_ports()
	print("Available ports:", ports)
	
	if not ports.has("COM3"):
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
	

func read_values() -> void:
	
	if(serial.bytes_available()):
		var ir = float(serial.readline().split(" ")[0].split(",")[0])
		irValue = ir
		isMotion = bool(int(serial.readline().split(" ")[3]))
		
		if showDebug:
			print("+-----+")
			print("Serial Read: " + serial.readline())
		
	
