extends PointLight2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	look_at(get_global_mouse_position())

func change_flashlight_energy(changeby: float):
	if 0.35 < (get_energy()+changeby) and (get_energy()+changeby) < 1:
		set_energy(get_energy()+changeby)#
	print(get_energy())
