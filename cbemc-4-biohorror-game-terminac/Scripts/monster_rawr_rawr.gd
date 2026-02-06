extends CharacterBody3D

@onready var manager : Node3D = self.get_parent()
@onready var nav_agent : NavigationAgent3D = $NavigationAgent3D

@export_category("Fixed Gameplay Values")
@export var baseSpeed = 50.0
@export var nextDestThreshold = 7.5
@export var followPlayer : bool = false

@export var player : CharacterBody3D
@export var arduino : Node3D

var speed : float = 0

func _ready() -> void:
	if !followPlayer:
		eat_a_guy()

func _unhandled_input(event: InputEvent) -> void:
	if(event.is_action_pressed("ui_accept")) && !followPlayer:
		eat_a_guy()

func eat_a_guy() -> void:
	var random_pos := Vector3.ZERO
	random_pos.x = randf_range(0.0, 100.0)
	random_pos.y = randf_range(3, 3)
	random_pos.z = randf_range(0.0, 100.0)
	print("RAWR IM GONNA EAT THE PERSON AT " + str(random_pos))
	nav_agent.target_position = random_pos

func _physics_process(_delta: float) -> void:
	
	determine_speed()
	
	if followPlayer:
		nav_agent.target_position = player.global_position
	
	var dest = nav_agent.get_next_path_position()
	var local_dest = dest - global_position
	var dir = local_dest.normalized()
	
	if nav_agent.target_position.distance_to(self.global_position) < nextDestThreshold && !followPlayer:
		eat_a_guy()
	
	velocity = dir * speed
	
	move_and_slide()
	

func determine_speed() -> void:
	
	speed = manager.get_arduino_variables("ir") * baseSpeed
	

func _on_area_3d_body_entered(body: Node3D) -> void:
	
	if body.name == "Player":
		manager.death_screen()
	
