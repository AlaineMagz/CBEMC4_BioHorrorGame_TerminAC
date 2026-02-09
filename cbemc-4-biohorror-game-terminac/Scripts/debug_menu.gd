extends Control

@onready var heart_rate_label = $DebugPanel/HeartRateLabel
@export var heart_rate_text = "Heart Rate: "

@onready var average_heart_rate_label = $DebugPanel/AverageHeartRateLabel
@export var average_heart_rate_text = "Average Heart Rate: "

@onready var motion_label = $DebugPanel/MotionLabel
@export var motion_text = "Motion Detected: "

@onready var serial_monitor = $DebugPanel/ColorRect/RichTextLabel
@export var monitor_size : int = 8

@export var arduino_reader : Node3D

@onready var debugMenu = get_child(0)
@onready var deathScreen = get_child(1)

var text_queue : Array[String]

var overrideSwitch : bool = false
var heartRateOverride : float = 50
var averageHeartRateOverride : float = 50
var motionDetectOverride : bool = false

func _ready() -> void:
	debugMenu.visible = false
	deathScreen.visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug"):
		debugMenu.visible = !debugMenu.visible
	

func add_to_monitor(new_text : String) -> void:
	
	text_queue.push_back(new_text)
	
	if(text_queue.size() > monitor_size):
		text_queue.pop_front()
	
	var total_text = ""
	var num_of_space = monitor_size - text_queue.size()
	
	for num in num_of_space:
		total_text += "\n"
	
	for text in text_queue:
		total_text += text + "\n"
	
	serial_monitor.text = total_text
	

func _on_check_button_toggled(toggled_on: bool) -> void:
	motionDetectOverride = toggled_on
	motion_label.text = motion_text + str(toggled_on).capitalize()

func _on_h_slider_value_changed(value: float) -> void:
	heartRateOverride = value
	heart_rate_label.text = heart_rate_text + str(value)

func _on_override_button_toggled(toggled_on: bool) -> void:
	overrideSwitch = toggled_on

func _on_h_slider_2_value_changed(value: float) -> void:
	averageHeartRateOverride = value
	average_heart_rate_label = average_heart_rate_text + str(value)
