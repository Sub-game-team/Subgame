extends Area2D
@onready var spawnArea = $CollisionShape2D.shape.extents
@onready var origin = $CollisionShape2D.get_global_position() -  spawnArea

func gen_random_pos():
	var x = randf_range(origin.x, spawnArea.x)
	var y = randf_range(origin.y, spawnArea.y)
	
	return Vector2(x, y)

func _process(_delta):
	print(spawnArea)
	print(origin)
