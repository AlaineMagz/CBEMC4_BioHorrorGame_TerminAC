extends SpotLight3D

func _process(delta: float) -> void:
	self.light_volumetric_fog_energy = 0.5 + randf() * 0.1
