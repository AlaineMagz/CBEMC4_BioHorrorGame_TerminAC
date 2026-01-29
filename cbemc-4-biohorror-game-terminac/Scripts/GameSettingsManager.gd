@tool
extends Node3D

@onready var player : CharacterBody3D = $Player
@onready var sun : DirectionalLight3D = $DirectionalLight3D

@export_tool_button("Reload Scene")
var button = reload_variables

@export_category("Control Settings")
@export_range(0.001, 0.005, 0.0005) var lookSpeed : float = 0.002

@export_category("Graphics Settings")
@export_range(0.1, 3, 0.1) var brightness : float = 0.5

@export_category("Fear Variables")
@export var overrideFear = false
@export_range(50, 200, 5) var heartRate : float = 0

func _ready() -> void:
	
	reload_variables()
	

func reload_variables() -> void:
	
	#Control Settings;
	player.look_speed = lookSpeed
	
	#Graphics Settings;
	sun.light_energy = brightness
	
	#Fear Variables;
	if overrideFear:
		pass
	
