extends RigidBody2D
var wasShot = false

func fire():
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and wasShot:
		look_at(get_viewport().get_mouse_position())
		add_constant_central_force(get_viewport().get_mouse_position())
		wasShot = true
	
func _process(delta):
	fire()
