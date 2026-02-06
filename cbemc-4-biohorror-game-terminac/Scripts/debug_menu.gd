extends Control

@onready var heart_rate_label = $DebugPanel/HeartRateLabel
@export var heart_rate_text = "Heart Rate: "

@onready var motion_label = $DebugPanel/MotionLabel
@export var motion_text = "Motion Detected: "

@export var arduino_reader : Node3D

@onready var debugMenu = get_child(0)
@onready var deathScreen = get_child(1)

var overrideSwitch : bool = false
var heartRateOverride : float = 50
var motionDetectOverride : bool = false

func _ready() -> void:
	debugMenu.visible = false
	deathScreen.visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug"):
		debugMenu.visible = !debugMenu.visible

func _on_check_button_toggled(toggled_on: bool) -> void:
	motionDetectOverride = toggled_on
	motion_label.text = motion_text + str(toggled_on).capitalize()

func _on_h_slider_value_changed(value: float) -> void:
	heartRateOverride = value
	heart_rate_label.text = heart_rate_text + str(value)

func _on_override_button_toggled(toggled_on: bool) -> void:
	overrideSwitch = toggled_on
