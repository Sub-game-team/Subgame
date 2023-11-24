extends Node

@export var mob_scene: PackedScene
@export var character_body_2d: PackedScene

func create_mob():
	var mob = mob_scene.instantiate()
	var direction = 0
	mob.rotation = direction
	mob.position = Vector2(0,0)
	var velocity = Vector2(randf_range(15.0, 25.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)

# Called when the node enters the scene tree for the first time.
func _ready():
	var player = character_body_2d.instantiate()
	add_child(player)
	create_mob()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
