extends Node3D

enum BlockShape { O , L, L2, Z, Z2, I, T}
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

	var mats = []

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
		var x_new = x
		var y_new = y
		
		if x == 0 && y == 0:
			#nothing
			pass
		elif x == -1:
			if y == 1:
				x_new = 1
			elif y == 0:
				x_new = 0
				y_new = 1
			else:
				y_new = 1
		elif x== 0:
			y_new = 0
			if y == 1:
				x_new = 1
			else:
				x_new = -1
		else:
			if y == 1:
				y_new = -1
			elif y == 0:
				x_new = 0
				y_new = -1
			else:
				x_new = -1			
		
		print("X:" + str(x) + " => " + str(x_new) + "   Y:" + str(y) + " => " + str(y_new))		
		c.position = Vector3(x_new,y_new,0)
