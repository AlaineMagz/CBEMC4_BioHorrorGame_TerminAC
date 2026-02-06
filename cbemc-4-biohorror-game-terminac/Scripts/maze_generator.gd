@tool
extends NavigationRegion3D

@onready var geometry : CSGCombiner3D = self.get_child(0)

@export_tool_button("Generate Maze")
var button = make_maze

@export_category("Maze Settings")
@export var maze_height : int = 11
@export var maze_width : int = 11

@export_category("Cell Settings")
@export var cell_x : float = 5
@export var cell_y : float = 7.5
@export var cell_z : float = 5
@export var ceiling_height : float = 3

func make_maze() -> void:
	
	var maze_floor = geometry.get_child(0)
	maze_floor.size = Vector3(maze_width * cell_x, 0.2, maze_height * cell_z)
	maze_floor.position = Vector3(maze_floor.size.x / 2.0, 0.1, maze_floor.size.z / 2.0)
	
	var maze_structure = generate_maze()
	
	if geometry.get_child(1) != null:
		geometry.get_child(1).queue_free()
		await get_tree().process_frame
	
	fill_all_dead_ends(maze_structure)
	generate_maze_geometry(maze_structure)
	
	await get_tree().process_frame
	self.bake_navigation_mesh()
	

#Uses Prim's Algorithm for Maze Generation;
func generate_maze() -> Array:
	
	if maze_width % 2 == 0:
		maze_width += 1
	if maze_height % 2 == 0:
		maze_height += 1
	
	var maze : Array[Array] = []
	
	for z in maze_height:
		var row = []
		for x in maze_width:
			row.append(1)
		maze.append(row)
	
	var start_x = 1
	var start_y = 1
	maze[start_y][start_x] = 0
	
	var walls: Array = []
	
	var directions = [
		Vector2i(0, 2),
		Vector2i(0, -2),
		Vector2i(2, 0),
		Vector2i(-2, 0)
	]
	
	for d in directions:
		var nx = start_x + d.x
		var ny = start_y + d.y
		if nx > 0 and nx < maze_width - 1 and ny > 0 and ny < maze_height - 1:
			if maze[ny][nx] == 1:
				walls.append({
					"frontier": Vector2i(nx, ny),
					"cell": Vector2(start_x, start_y)
				})
	
	while walls.size() > 0:
		var index = randi() % walls.size()
		var wall = walls[index]
		walls.remove_at(index)
	
		var wx = wall.frontier.x
		var wy = wall.frontier.y
		var cx = wall.cell.x
		var cy = wall.cell.y
	
		if maze[wy][wx] == 1:
			maze[wy][wx] = 0
			maze[(wy + cy) / 2][(wx + cx) / 2] = 0
	
			for d in directions:
				var nx = wx + d.x
				var ny = wy + d.y
				if nx > 0 and nx < maze_width - 1 and ny > 0 and ny < maze_height - 1:
					if maze[ny][nx] == 1:
						walls.append({
							"frontier": Vector2i(nx, ny),
							"cell": Vector2i(wx, wy)
						})
	
	return maze
	

func fill_all_dead_ends(maze_structure: Array) -> void:
	for y in range(1, maze_height - 1):
		for x in range(1, maze_width - 1):
			if maze_structure[y][x] == 0:
				# check 4 neighbors: up, down, left, right
				var neighbors = [
					maze_structure[y - 1][x], # up
					maze_structure[y + 1][x], # down
					maze_structure[y][x - 1], # left
					maze_structure[y][x + 1]  # right
				]
				var wall_count = 0
				for n in neighbors:
					if n == 1:
						wall_count += 1
				# if 3 or 4 neighbors are walls, fill this cell
				if wall_count >= 3:
					if randi_range(0,1) == 1:
						maze_structure[y][x] = 2


func generate_maze_geometry(maze_structure : Array) -> void:
	
	var maze_walls = CSGCombiner3D.new()
	maze_walls.name = "maze_walls"
	geometry.add_child(maze_walls)
	maze_walls.owner = get_tree().edited_scene_root
	
	for x in maze_width:
		for z in maze_height:
			
			if maze_structure[z][x] == 1:
				var cell = CSGBox3D.new()
				cell.name = "Cell " + str(x) + "-" + str(z)
				cell.size = Vector3(cell_x, cell_y, cell_z)
				cell.position = Vector3((x * cell_x) + (cell_x / 2.0), cell_y / 2.0, (z * cell_z) +(cell_z / 2.0))
				maze_walls.add_child(cell)
				cell.owner = get_tree().edited_scene_root
			else: if maze_structure[z][x] == 2:
				var cell = CSGBox3D.new()
				cell.name = "Cell " + str(x) + "-" + str(z)
				cell.size = Vector3(cell_x, ceiling_height, cell_z)
				cell.position = Vector3((x * cell_x) + (cell_x / 2.0), cell_y - (cell.size.y / 2), (z * cell_z) +(cell_z / 2.0))
				maze_walls.add_child(cell)
				cell.owner = get_tree().edited_scene_root
			
	
