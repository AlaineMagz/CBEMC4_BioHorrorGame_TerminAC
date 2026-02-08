extends CharacterBody3D

@export var manager : Node3D
@onready var nav_agent : NavigationAgent3D = $NavigationAgent3D
@onready var state_timer : Timer = $StateTimer
@onready var player = manager.player
@onready var vision_ray : RayCast3D = $VisionCone

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
	
	state_timer.one_shot = true
	state_timer.timeout.connect(_on_state_timer_timeout)
	
	var maze = manager.maze
	maze_bounds_rect = Rect2(maze.cell_x, maze.cell_z, (maze.cell_x * (maze.maze_width - 1)), (maze.cell_z * (maze.maze_height - 1)))
	
	await get_tree().physics_frame
	enter_state(State.WANDERING)

func _physics_process(delta: float) -> void:
	
	if can_see_player() && current_state != State.CHASING:
		enter_state(State.CHASING)
	
	match current_state:
		
		State.IDLE:
			pass
		
		State.WANDERING:
			move_agent(determine_speed("wander"), delta)
			if nav_agent.is_navigation_finished():
				enter_state(State.IDLE)
		
		State.SEARCHING:
			pass #TODO
		
		State.CHASING:
			nav_agent.target_position = player.global_position
			move_agent(determine_speed("chase"), delta)
			if not can_see_player():
				last_known_player_pos = player.global_position
				enter_state(State.MOVING_TO_LAST_POS)
		
		State.MOVING_TO_LAST_POS:
			move_agent(determine_speed("chase"), delta)
			if nav_agent.is_navigation_finished():
				enter_state(State.SCAN_AREA)
		
		State.SCAN_AREA:
			rotate_y(rotation_speed * delta)
		
	
	print(current_state)
	

func enter_state(new_state : State) -> void:
	
	current_state = new_state
	
	match current_state:
		State.IDLE:
			velocity = Vector3.ZERO
			state_timer.start(idle_duration)
		
		State.WANDERING:
			pick_random_wander_point()
		
		State.SEARCHING:
			pass
		
		State.CHASING:
			state_timer.stop() # Don't timeout while chasing
		
		State.MOVING_TO_LAST_POS:
			nav_agent.target_position = last_known_player_pos
		
		State.SCAN_AREA:
			velocity = Vector3.ZERO
			state_timer.start(scan_duration)
	

func determine_speed(type : String) -> float:
	
	match type:
		
		"wander":
			return baseWanderSpeed
		
		"chase":
			return baseChaseSpeed
		
	
	return 1.0
	

func move_agent(move_speed : float, delta : float) -> void:
	
	var current_pos = global_position
	var next_pos = nav_agent.get_next_path_position()
	var new_velocity = (next_pos - current_pos).normalized() * move_speed
	
	velocity = velocity.move_toward(new_velocity, acceleration * delta)
	move_and_slide()
	
	if velocity.length() > 0.1:
		var look_target = global_position - velocity
		var target_rot = Transform3D(global_transform.basis).looking_at(look_target, Vector3.UP).basis
		global_transform.basis = global_transform.basis.slerp(target_rot, rotation_speed * delta)
	

func pick_random_wander_point() -> void:
	var random_x = randf_range(maze_bounds_rect.position.x, maze_bounds_rect.end.x)
	var random_z = randf_range(maze_bounds_rect.position.y, maze_bounds_rect.end.y)
	var target = Vector3(random_x, global_position.y, random_z)
	
	await NavigationServer3D.map_changed
	
	var map = get_world_3d().navigation_map
	var valid_target = NavigationServer3D.map_get_closest_point(map, target)
	
	if global_position.distance_to(valid_target) < min_wander_distance:
		pick_random_wander_point() # Retry
		return
		
	nav_agent.target_position = valid_target

func can_see_player() -> bool:
	
	if player == null : return false
	
	if player.is_hiding: return false
	
	var dist = global_position.distance_to(player.global_position)
	if dist > vision_range:
		return false
	
	var direction_to_player = global_position.direction_to(player.global_position)
	var angle_to_player = (-global_transform.basis.z).angle_to(direction_to_player)
	
	if rad_to_deg(angle_to_player) > (vision_angle / 2.0):
		return false
	
	vision_ray.look_at(player.global_position, Vector3.UP)
	vision_ray.force_raycast_update()
	
	if vision_ray.is_colliding():
		var collider = vision_ray.get_collider()
		if collider == player or collider.get_parent() == player:
			return true
	
	return false
	

func _on_area_3d_body_entered(body: Node3D) -> void:
	
	if body.name == "Player":
		manager.death_screen()
	

func _on_state_timer_timeout() -> void:
	
	match current_state:
		
		State.IDLE:
			enter_state(State.WANDERING)
		
		State.SCAN_AREA:
			enter_state(State.IDLE)
		
	
