extends Node3D

var last_fall
var speed = 0.5
var current_block
var next_block

var cols = 10
var rows = 14
var grid : Array[Array]

var points = 0

enum GameMode { STOP, PAUSE, RUNNING }
var game_state = GameMode.STOP

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var mesh_instance := MeshInstance3D.new()
	var mesh_instance_l := MeshInstance3D.new()
	var mesh_instance_r := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var immediate_mesh_l := ImmediateMesh.new()
	var immediate_mesh_r := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance_l.mesh = immediate_mesh_l
	mesh_instance_r.mesh = immediate_mesh_r
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	mesh_instance_l.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	mesh_instance_r.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	for i in range(-5,6):
		immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
		immediate_mesh.surface_add_vertex(Vector3(i-0.5, 0, -0.5))
		immediate_mesh.surface_add_vertex(Vector3(i-0.5, rows, -0.5))
		immediate_mesh.surface_end()

	for i in range(0, rows):
		grid.append([])
		for j in cols:
			grid[i].append(null)
		
		immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
		immediate_mesh.surface_add_vertex(Vector3(-5.5, i-0.5, -0.5))
		immediate_mesh.surface_add_vertex(Vector3(4.5, i-0.5, -0.5))
		immediate_mesh.surface_end()
		
		immediate_mesh_l.surface_begin(Mesh.PRIMITIVE_LINES, material)
		immediate_mesh_l.surface_add_vertex(Vector3(-5.5, i-0.5, -0.5))
		immediate_mesh_l.surface_add_vertex(Vector3(-5.5, i-0.5, 0.5))
		immediate_mesh_l.surface_end()

		immediate_mesh_r.surface_begin(Mesh.PRIMITIVE_LINES, material)
		immediate_mesh_r.surface_add_vertex(Vector3(4.5, i-0.5, -0.5))
		immediate_mesh_r.surface_add_vertex(Vector3(4.5, i-0.5, 0.5))
		immediate_mesh_r.surface_end()


	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.WHITE_SMOKE
	material.albedo_color.a = 0.2
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	
	get_tree().get_root().add_child.call_deferred(mesh_instance)
	get_tree().get_root().add_child.call_deferred(mesh_instance_l)
	get_tree().get_root().add_child.call_deferred(mesh_instance_r)
	
	game_state = GameMode.RUNNING

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game_state != GameMode.RUNNING:
		return
	
	if next_block == null:
		var scene = load("res://scenes/Chairtris/block.tscn");
		next_block = scene.instantiate()
		next_block.position = Vector3(10, rows-2, 0)
		add_child(next_block)
	
	if current_block == null:
		current_block = next_block
		next_block = null
		current_block.position = Vector3(0, rows-1, 0)
		add_child(current_block)
		last_fall = 0		
	else:
		last_fall+= delta
		if last_fall >= speed:
			last_fall = 0

			if !check_and_move(Vector3(0, -1, 0)):
				grid_add_block()
				current_block = null
	check_rows()
	

func _input(event):
	var pos_new = null
	
	if current_block == null:
		return
	
	if Input.is_action_pressed("ui_up"):
		current_block.rotate_block()
	
	if Input.is_action_pressed("ui_right"):
		pos_new = Vector3(1, 0, 0)
		
	if Input.is_action_pressed("ui_left"):
		pos_new = Vector3(-1, 0, 0)

	if Input.is_action_pressed("ui_down"):
		pos_new = Vector3(0, -1, 0)			
			
	if pos_new != null:
		check_and_move(pos_new)
		

func check_and_move(v: Vector3) -> bool:
	var p = current_block.position
	var children = current_block.get_children()
	for c in children:
		var pos = p + c.position + v
		if !check_position(pos):
			return false
	
	current_block.position += v
				
	return true	

func check_position(v: Vector3) -> bool:
	return v.y >= 1 && v.y < rows && v.x > -6 && v.x < 5 && grid[v.y][v.x] == null


func grid_add_block() -> void:
	var p = current_block.position
	
	var children = current_block.get_children()
	for c in children:
		var pos = p + c.position
		
		if pos.y < rows:
			grid[pos.y][pos.x] = c
		else:
			OS.alert("GAME OVER");
			game_state = GameMode.STOP
	
func check_rows() -> void:
	var del : Array[int]
	for y in range(0, rows):
		var complete = true
		for x in cols:
			if grid[y][x] == null:
				complete = false
				break
		
		if complete:
			del.append(y)
	
	if del.size() > 0:
		points+= del.size()		
		var blub = "[color=blue]" + str(points) + "[/color]"
		get_node("RichTextLabel3").clear()
		get_node("RichTextLabel3").append_text(blub)
		for y in del:
			speed -= (speed / 5)
			for x in cols:
				grid[y][x].queue_free()
				grid[y][x] = null
		
		for y in range(del[0], rows-del.size()):
			for x in cols:
				var offset = del.size()
				
				if grid[y+offset][x] != null:
					grid[y][x] = grid[y+offset][x]
					grid[y][x].position += Vector3(0, -offset, 0)
					grid[y+offset][x] = null
