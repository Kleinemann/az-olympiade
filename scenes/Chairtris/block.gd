extends Node3D

enum BlockShape { O, L, L2, Z, Z2, I, T}
var shape

func _init() -> void:
	randomize()
	var colors: Array[Color]
	colors.append(Color.RED)
	colors.append(Color.GREEN)
	colors.append(Color.YELLOW)
	colors.append(Color.BLUE)
	colors.append(Color.ORANGE)
	colors.append(Color.PINK)
	colors.append(Color.GRAY)
	colors.append(Color.AQUA)
	
	var color = colors[randi() % colors.size()]

	var s = BlockShape.get(BlockShape.keys()[randi() % BlockShape.size()])

	var mat = StandardMaterial3D.new()
	mat.albedo_color = color 
		
	if s == BlockShape.O:
		add_brick(mat, Vector3(0, 0, 0))
		add_brick(mat, Vector3(1, 0, 0))
		add_brick(mat, Vector3(0, 1, 0))
		add_brick(mat, Vector3(1, 1, 0))

	if s == BlockShape.L:
		add_brick(mat, Vector3(0, 0, 0))
		add_brick(mat, Vector3(-1, 0, 0))
		add_brick(mat, Vector3(1, 1, 0))
		add_brick(mat, Vector3(1, 0, 0))

	if s == BlockShape.L2:
		add_brick(mat, Vector3(0, 0, 0))
		add_brick(mat, Vector3(1, 0, 0))
		add_brick(mat, Vector3(-1, 1, 0))
		add_brick(mat, Vector3(-1, 0, 0))

	if s == BlockShape.Z:
		add_brick(mat, Vector3(0, 0, 0))
		add_brick(mat, Vector3(-1, 0, 0))
		add_brick(mat, Vector3(0, 1, 0))
		add_brick(mat, Vector3(1, 1, 0))

	if s == BlockShape.Z2:
		add_brick(mat, Vector3(0, 0, 0))
		add_brick(mat, Vector3(1, 0, 0))
		add_brick(mat, Vector3(0, 1, 0))
		add_brick(mat, Vector3(-1, 1, 0))

	if s == BlockShape.I:
		add_brick(mat, Vector3(0, 0, 0))
		add_brick(mat, Vector3(-1, 0, 0))
		add_brick(mat, Vector3(1, 0, 0))

	if s == BlockShape.T:
		add_brick(mat, Vector3(0, 0, 0))
		add_brick(mat, Vector3(-1, 0, 0))
		add_brick(mat, Vector3(1, 0, 0))		
		add_brick(mat, Vector3(0, 1, 0))		
		
func add_brick(mat: Material, v: Vector3) -> void:
	var scene = load("res://scenes/Chairtris/brick.tscn");
	var b = scene.instantiate()
	b.position = v
	b.get_node("MeshInstance3D").material_override = mat
	add_child(b)


func rotate_block() -> void:
	if shape == BlockShape.O:
		return
	
	for c in get_children():
		var x = c.position.x
		var y = c.position.y
		var x_new = 0
		var y_new = 0
		
		#lines
		if x != 0 && y == 0:
			if x == -1:
				y_new = -1
			else:
				y_new = 1

		if y != 0 && x == 0:
			if y == 1:
				x_new = -1
			else:
				x_new = 1
		
		#Corner
		if x != 0 && y != 0:
			if x == -1:
				if y == 1:
					x_new = -1
					y_new = 1
				else:
					x_new = 1
					y_new = -1
			else:
				if y == 1:
					x_new = -1
					y_new = 1
				else:
					x_new = 1
					y_new = 1
		c.position = Vector3(x_new,y_new,0)

		 			
