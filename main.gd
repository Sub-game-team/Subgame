extends Node

@export var mob_scene: PackedScene
@export var player_scene: PackedScene
@export var tileset: PackedScene
@export var crosshair_scene: PackedScene
@export var vulkanschnecken_scene: PackedScene

var reset_progress = false

func create_mob(pos: Vector2 = Vector2(500,0)):
	var mob = mob_scene.instantiate()
	var direction = 0
	mob.rotation = direction
	mob.position = pos

	# Pass the player node reference to the mob
	mob.set_player_reference($Player)
	add_child(mob)
	mob.stop = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if not reset_progress:
		load_game()
	else:
		var player = player_scene.instantiate()
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
	$Timer_save.start()
	$Player.start_sub()
	create_mob()
	$mob.stop = false
	$Timer.start(3)
	$Button.queue_free()
	$Label.queue_free()
	$Player/TabContainer.queue_free()

func save_game():
	var save_game = FileAccess.open("res://Savegames/save1.save", FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		# Check if the node is an instanced scene so it can be instanced again during load.
		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check if the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		var node_data = node.call("save")

		# JSON provides a static method to serialized JSON string.
		var json_string = JSON.stringify(node_data)

		# Store the save dictionary as a new line in the save file.
		save_game.store_line(json_string)


func _on_timer_save_timeout():
	save_game()

# Note: This can be called from anywhere inside the tree. This function
# is path independent.
func load_game():
	if not FileAccess.file_exists("res://Savegames/save1.save"):
		return # Error! We don't have a save to load.

	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		i.queue_free()

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var save_game = FileAccess.open("res://Savegames/save1.save", FileAccess.READ)
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()

		# Creates the helper class to interact with JSON
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue	

		# Get the data from the JSON object
		var node_data = json.get_data()

		# Firstly, we need to create the object and add it to the tree and set its position.
		var new_object = load(node_data["filename"]).instantiate()
		add_child(new_object)
		get_node(node_data["parent"]).add_child(new_object)
		new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])

		# Now we set the remaining variables.
		for i in node_data.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				continue
			new_object.set(i, node_data[i])
