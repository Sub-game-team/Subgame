extends Node

@export var mob_scene: PackedScene
@export var player_scene: PackedScene
@export var tileset: PackedScene
@export var crosshair_scene: PackedScene

func create_mob():
	var mob = mob_scene.instantiate()
	var direction = 0
	mob.rotation = direction
	mob.position = Vector2(500, 0)  # just temporary

	# Pass the player node reference to the mob
	mob.set_player_reference($Player) 
	add_child(mob)



# Called when the node enters the scene tree for the first time.
func _ready():
	var player = player_scene.instantiate()
	add_child(player)
	var tile_set = tileset.instantiate()
	add_child(tile_set)
	create_mob()
	var crosshair = crosshair_scene.instantiate()
	add_child(crosshair)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_timer_timeout():
	create_mob()
