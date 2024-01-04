extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if get_parent().reset_settings == false:
		load_settings()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_button_pressed():
	var torp_menu_stuff = get_tree().get_nodes_in_group("torpedo_menu")
	for i in torp_menu_stuff:
		if i.is_visible():
			i.set_visible(false)
		else:
			i.set_visible(true)

func save_settings():
	var settings_file = FileAccess.open("res://Savegames/settings.save", FileAccess.WRITE)
	var save_dict = {
		"Torpedo1_homing" : $Button/TabContainer/torp1/CheckButton.is_pressed(),
		"Torpedo1_speed" : $Button/TabContainer/torp1/CheckButton2.is_pressed(),
		"Torpedo1_damage" : $Button/TabContainer/torp1/CheckButton3.is_pressed(),
		"Torpedo1_radius" : $Button/TabContainer/torp1/CheckButton4.is_pressed(),
		"Torpedo2_homing" : $Button/TabContainer/torp2/CheckButton.is_pressed(),
		"Torpedo2_speed" : $Button/TabContainer/torp2/CheckButton2.is_pressed(),
		"Torpedo2_damage" : $Button/TabContainer/torp2/CheckButton3.is_pressed(),
		"Torpedo2_radius" : $Button/TabContainer/torp2/CheckButton4.is_pressed(),
		"Torpedo3_homing" : $Button/TabContainer/torp3/CheckButton.is_pressed(),
		"Torpedo3_speed" : $Button/TabContainer/torp3/CheckButton2.is_pressed(),
		"Torpedo3_damage" : $Button/TabContainer/torp3/CheckButton3.is_pressed(),
		"Torpedo3_radius" : $Button/TabContainer/torp3/CheckButton4.is_pressed(),
	}
	var json_string = JSON.stringify(save_dict)
	settings_file.store_line(json_string)

func load_settings():
	if not FileAccess.file_exists("res://Savegames/settings.save"):
		return
	var settings_file = FileAccess.open("res://Savegames/settings.save", FileAccess.READ)
	while settings_file.get_position() < settings_file.get_length():
		var json_string = settings_file.get_line()

		# Creates the helper class to interact with JSON
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		# Get the data from the JSON object
		var node_data = json.get_data()
		var buttons = [
			$Button/TabContainer/torp1/CheckButton3,#damage
			$Button/TabContainer/torp1/CheckButton,#homing
			$Button/TabContainer/torp1/CheckButton4,#radius
			$Button/TabContainer/torp1/CheckButton2,#speed
			$Button/TabContainer/torp2/CheckButton3,
			$Button/TabContainer/torp2/CheckButton,
			$Button/TabContainer/torp2/CheckButton4,
			$Button/TabContainer/torp2/CheckButton2,
			$Button/TabContainer/torp3/CheckButton3,
			$Button/TabContainer/torp3/CheckButton,
			$Button/TabContainer/torp3/CheckButton4,
			$Button/TabContainer/torp3/CheckButton2,
		]
		var x = 0
		for i in node_data.keys():
			buttons[x].set_pressed(node_data[i])
			x += 1

func _on_check_button_pressed():
	save_settings()

func _on_check_button_2_pressed():
	save_settings()

func _on_check_button_3_pressed():
	save_settings()

func _on_check_button_4_pressed():
	save_settings()
