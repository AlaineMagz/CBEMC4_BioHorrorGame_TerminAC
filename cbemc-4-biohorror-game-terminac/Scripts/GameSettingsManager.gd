@tool
extends Node3D

@export_category("Important Nodes")
@export var environment : WorldEnvironment
@export var sun : DirectionalLight3D
@export var player : CharacterBody3D
@export var maze : NavigationRegion3D
@export var monster : CharacterBody3D
@export var arduinoReader : Node3D
@export var GUI : Control

@export_tool_button("Reload Scene")
var button = reload_variables

@export_category("Control Settings")
@export_range(0.001, 0.005, 0.0005) var lookSpeed : float = 0.002

@export_category("Graphics Settings")
@export_range(0.0, 2, 0.05) var brightness : float = 0.5
@export_range(0.0, 1, 0.05) var ambient_light : float = 0.6
@export var heart_distance_mult = 1

func _ready() -> void:
	
	environment = $WorldEnvironment
	sun = $Sun
	player = $Player
	maze = $Maze
	monster = $MonsterRawrRawr
	arduinoReader = $ArduinoReader
	GUI = $GUI
	
	reload_variables()
	

func _process(_delta: float) -> void:
	
	if Engine.is_editor_hint():
		return
	
	#Fear Variables;
	if GUI.overrideSwitch:
		print("AHHH OVERRIDE SCARY")
	

func reload_variables() -> void:
	
	#Control Settings;
	player.look_speed = lookSpeed
	
	#Graphics Settings;
	sun.light_energy = brightness
	environment.environment.ambient_light_energy = ambient_light
	

func get_arduino_variables(value):
	
	if value == "ir":
		if GUI.overrideSwitch:
			return GUI.heartRateOverride / 50
		else:
			return arduinoReader.irValue
	

func death_screen() -> void:
	
	GUI.deathScreen.visible = true
	
	await get_tree().create_timer(3.0).timeout
	
	get_tree().quit()
	
