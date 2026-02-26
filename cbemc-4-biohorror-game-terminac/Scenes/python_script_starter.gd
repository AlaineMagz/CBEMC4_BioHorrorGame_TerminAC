extends Node

var python_pid : int = -1

func _ready():
	# 1. Get the global path to your relay script
	# This assumes 'relay_to_godot.py' is in your project's root folder
	var script_path = ProjectSettings.globalize_path("res://certs/python_to_godot.py")
	var project_dir = ProjectSettings.globalize_path("res://")
	
	# 2. Define the command. 
	# On Windows, use "python". On Mac/Linux, usually "python3".
	var command = "python" 
	var args = [script_path, project_dir]
	
	# 3. Start the process in the background (blocking = false)
	# create_process is cleaner for background tasks than OS.execute
	python_pid = OS.create_process(command, args, true)
	
	if python_pid == -1:
		print("Failed to start Python Relay script!")
	else:
		print("Python Relay started with PID: ", python_pid)

# IMPORTANT: Kill the relay when you close the game
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST or what == NOTIFICATION_PREDELETE:
		if python_pid != -1:
			print("Closing Python Relay...")
			OS.kill(python_pid)
