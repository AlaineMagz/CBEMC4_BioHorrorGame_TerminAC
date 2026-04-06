extends DirectionalLight3D

@onready var manager : Node3D = self.get_parent()

@export var peaceful_color : Color = Color("9abadc")
@export var stressed_color : Color = Color("923f2f")

func _process(_delta: float) -> void:
	
	var stress_level = manager.get_arduino_variables("ir") - 1
	
	self.light_color = (peaceful_color * max(min(1, (1 - stress_level)), 0)) + (stressed_color * max(0, min(1, stress_level)))
	
