extends CharacterBody3D

@onready var manager : Node3D = self.get_parent()
@onready var nav_agent : NavigationAgent3D = $NavigationAgent3D
@onready var search_timer : Timer = $SearchTimer
@onready var player = manager.player
@onready var vision_ray : RayCast3D = $VisionRay

@export_category("Movement Stats")
@export var baseWanderSpeed : float = 4.0
@export var baseChaseSpeed : float = 8.0
@export var rotation_speed : float = 8.0
@export var acceleration : float = 10.0

@export_category("Senses")
@export var vision_angle : float = 60.0 # The "Cone" width in degrees
@export var vision_range : float = 15.0
@export var scan_duration : float = 4.0 # How long to spin around
@export var idle_duration : float = 2.0 # How long to wait before wandering again

@export_category("Maze Settings")
@export var maze_bounds_rect : Rect2 = Rect2(0, 0, 50, 50) 
@export var min_wander_distance : float = 5.0

enum State { IDLE, WANDERING, SEARCHING, CHASING, MOVING_TO_LAST_POS, SCAN_AREA }
var current_state : State = State.IDLE

var last_known_player_pos : Vector3 = Vector3.ZERO
var start_scan_angle : float = 0.0

func _ready() -> void:
	
	search_timer.one_shot = true
	search_timer.timeout.connect(_on_search_timer_timeout)
	
	await get_tree().physics_frame
	enter_state(State.WANDERING)
	

func eat_a_guy() -> void:
	var random_pos := Vector3.ZERO
	random_pos.x = randf_range(0.0, 100.0)
	random_pos.y = randf_range(3, 3)
	random_pos.z = randf_range(0.0, 100.0)
	print("RAWR IM GONNA EAT THE PERSON AT " + str(random_pos))
	nav_agent.target_position = random_pos

func _physics_process(_delta: float) -> void:
	
	var dest = nav_agent.get_next_path_position()
	var local_dest = dest - global_position
	var dir = local_dest.normalized()
	
	velocity = dir * determine_speed()
	
	move_and_slide()
	

func determine_speed() -> float:
	
	return 0
	

func _on_area_3d_body_entered(body: Node3D) -> void:
	
	if body.name == "Player":
		manager.death_screen()
	

func _on_search_timer_timeout() -> void:
	
	pass
	
