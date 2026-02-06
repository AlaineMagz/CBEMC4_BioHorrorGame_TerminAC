extends CSGCombiner3D
#
#@export var geometry : GeometryInstance3D
#@export var player : CharacterBody3D
#@export var arduinoReader : Node3D
#
#@export var monster : CharacterBody3D
#
#
#
#func _ready() -> void:
	#if on:
		#var mat = geometry.material_override
		#mat.set("distance_fade_mode", 2)
		#monster.get_child(0).material_override.set("distance_fade_mode", 2)
#
#func _process(_delta: float) -> void:
	#if on:
		#var mat = geometry.material_override
		#mat.set("distance_fade_max_distance", max(5,(5 + (player.position.y * height_distance_mult) + (10 * arduinoReader.irValue))))
		#mat.set("distance_fade_min_distance", max(10,(10 + (player.position.y * height_distance_mult)  + (10 * arduinoReader.irValue))))
		#monster.get_child(0).material_override.set("distance_fade_min_distance", max(10,(10 + (player.position.y * height_distance_mult))))
