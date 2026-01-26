extends CharacterBody3D

@onready var nav_agent : NavigationAgent3D = $NavigationAgent3D

@export var speed = 5.0
@export var player : CharacterBody3D
@export var arduino : Node3D

@export var followPlayer : bool = false

func _ready() -> void:
	var random_pos := Vector3.ZERO
	random_pos.x = randf_range(-48.0, 48.0)
	random_pos.z = randf_range(-48.0, 48.0)
	print("RAWR IM GONNA EAT THE PERSON AT " + str(random_pos))
	nav_agent.target_position = random_pos

func _unhandled_input(event: InputEvent) -> void:
	if(event.is_action_pressed("ui_accept")):
		var random_pos := Vector3.ZERO
		random_pos.x = randf_range(-48.0, 48.0)
		random_pos.y = randf_range(0, 18.0)
		random_pos.z = randf_range(-48.0, 48.0)
		print("RAWR IM GONNA EAT THE PERSON AT " + str(random_pos))
		nav_agent.target_position = random_pos

func _physics_process(_delta: float) -> void:
	
	if followPlayer:
		nav_agent.target_position = player.global_position
	
	var dest = nav_agent.get_next_path_position()
	var local_dest = dest - global_position
	var dir = local_dest.normalized()
	
	velocity = (dir * speed * max(0.5, arduino.irValue)) * max(1, (10 * int(arduino.isMotion)))
	
	move_and_slide()
	
