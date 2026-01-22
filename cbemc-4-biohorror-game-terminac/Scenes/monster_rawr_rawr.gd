extends CharacterBody3D

@onready var nav_agent : NavigationAgent3D = $NavigationAgent3D

@export var speed = 5.0

func _ready() -> void:
	var random_pos := Vector3.ZERO
	random_pos.x = randf_range(-98.0, 98.0)
	random_pos.z = randf_range(-98.0, 98.0)
	nav_agent.target_position = random_pos

func _unhandled_input(event: InputEvent) -> void:
	if(event.is_action_pressed("ui_accept")):
		var random_pos := Vector3.ZERO
		random_pos.x = randf_range(-98.0, 98.0)
		random_pos.z = randf_range(-98.0, 98.0)
		nav_agent.target_position = random_pos

func _physics_process(_delta: float) -> void:
	
	var dest = nav_agent.get_next_path_position()
	var local_dest = dest - global_position
	var dir = local_dest.normalized()
	
	velocity = dir * speed
	
	move_and_slide()
	
