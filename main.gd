extends Node

@export var mob_scene: PackedScene
@export var player_scene: PackedScene
@export var tileset: PackedScene
@export var crosshair_scene: PackedScene
@export var vulkanschnecken_scene: PackedScene
var player

func create_mob(pos: Vector2 = Vector2(500,0)):
	var mob = mob_scene.instantiate()
	var direction = 0
	mob.rotation = direction
	mob.position = pos

	# Pass the player node reference to the mob
	mob.set_player_reference($Player)
	add_child(mob)

# Called when the node enters the scene tree for the first time.
func _ready():
	player = player_scene.instantiate()
	add_child(player)
	var tile_set = tileset.instantiate()
	add_child(tile_set)
	
	var crosshair = crosshair_scene.instantiate()
	add_child(crosshair)
	var vulkanschnecke = vulkanschnecken_scene.instantiate()
	vulkanschnecke.position = Vector2(-1340, 800)
	add_child(vulkanschnecke)

func _on_timer_timeout():
	create_mob($Area2D_mobspawner.gen_random_pos())


func _on_button_pressed():
	player.start_sub()
	create_mob()
	$Timer.start(3)
	$Button.queue_free()
	$Label.queue_free()
	$Player/TabContainer.queue_free()
