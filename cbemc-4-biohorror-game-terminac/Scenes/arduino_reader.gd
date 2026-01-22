extends Node3D

var serial: GdSerial

@export var irValue: float = 1
@export var irMax: float = 50000

func _ready():
	serial = GdSerial.new()
	
	serial.set_port("COM3")
	serial.set_baud_rate(115200)
	
	serial.open()
	

func _process(_delta: float) -> void:
	
	#if(serial.is_open()):
		#var ir = float(serial.readline().split(" ")[0].split("=")[1].split(",")[0])
		#print(ir)
		#irValue = ir/irMax
		#print(irValue)
		#
		
		print(serial.readline())
	
