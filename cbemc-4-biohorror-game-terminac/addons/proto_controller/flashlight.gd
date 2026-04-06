extends SpotLight3D

@onready var player : CharacterBody3D = self.get_parent().get_parent().get_parent()

@export var change_speed : float = 0.1
@export var flicker_intensity : float = 1

func _process(delta: float) -> void:
	
	var stress_level = player.manager.get_arduino_variables("ir") - 1
	var light_target = max(0, 1 - min(1, randf() * (0.8 * (1 + stress_level) * flicker_intensity)))
	var vol_target = 0.5 + randf() * (0.1 * (1 + stress_level) * flicker_intensity)
	
	if player.is_hiding:
		self.light_volumetric_fog_energy = lerpf(self.light_volumetric_fog_energy, 0, change_speed)
		self.light_energy = lerpf(self.light_energy, 0, change_speed)
	else:
		self.light_energy = lerpf(self.light_energy, light_target, change_speed)
		self.light_volumetric_fog_energy = lerpf(self.light_volumetric_fog_energy, vol_target, change_speed)
	
