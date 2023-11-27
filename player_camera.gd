extends Camera2D

var zoom_speed_fact = 0.1
var zoom_speed = 0
var min_zoom = 0.5
var max_zoom = 8

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	# Check for mouse wheel input
	var zoom_input = 0.0
	#print(Input.is_action_just_pressed("ui_zoom_in"), Input.is_action_just_pressed("ui_zoom_out"))
	if Input.is_action_just_pressed("ui_zoom_in"):
		zoom_input += 1.0
	if Input.is_action_just_pressed("ui_zoom_out"):
		zoom_input -= 1.0

	# Adjust the zoom based on the input
	zoom_camera(zoom_input)

func zoom_camera(zoom_input):
	# Calculate the new scale factor
	zoom_speed = calculate_zoom_speed(zoom_speed_fact)
	var new_scale = clamp(zoom.x + zoom_input * zoom_speed, min_zoom, max_zoom)
	# Set the new scale
	zoom.x = new_scale
	zoom.y = new_scale

func calculate_zoom_speed(zoom_speed_factor = 0.5) -> float:
	# You can adjust the coefficients of the quadratic function

	# Calculate the speed based on the current scale
	return zoom_speed_factor * pow(zoom.x, 2.0)
