extends Button

@export var text_box : TextEdit

func _on_pressed() -> void:
	GlobalVariables.device_id = text_box.text
	get_tree().change_scene_to_file("res://Scenes/test.tscn")
