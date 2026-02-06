extends Node3D

@onready var maze = self.get_child(1).get_child(0)
@onready var monster = self.get_child(2)

func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("ui_accept"):
		await maze.make_maze()
		monster.position = Vector3(7.75, 2.0, 7.8)
	
